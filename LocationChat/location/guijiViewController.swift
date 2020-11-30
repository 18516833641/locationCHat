//
//  guijiViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/30.
//

import UIKit
import MapKit
// MARK:- 常量
fileprivate struct Metric {
    static let StartAnnotation = "sport_icon_qidian"
    static let EndAnnotation = "sport_icon_zhongdian"
    static let animationDuration = 3.0
    static let lineWidth: CGFloat = 4.0
}

class guijiViewController: AnalyticsViewController {
    
    let trackMapView = MKMapView(frame: UIScreen.main.bounds)
    var trackArr = Array<String>()
    var coordinates: [CLLocationCoordinate2D] = []
    var lineOne: MKPolyline?
    var shapeLayer: CAShapeLayer?
    var onceUseAnnotation = false //只隐藏一次动画
    fileprivate var tempCoordinateRegion: MKCoordinateRegion?
    var startImageView = UIImageView.init(image: UIImage(named: Metric.StartAnnotation))
    var endImageView = UIImageView.init(image: UIImage(named: Metric.EndAnnotation))
 
    var circle: MKCircle!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "轨迹"
        
        loactionAction()
        
        trackPlayback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
//        locationManager.stopUpdatingLocation()

    }
    
    //MARK:定位方法
    func loactionAction() {
        
        trackMapView.delegate = self
        view.addSubview(trackMapView)
        trackArr = sporttrailDetails.components(separatedBy: ",")
        
        var maxX = 0.0
        var minX = 0.0
        var maxY = 0.0
        var minY = 0.0
        for item in trackArr {
            let item = item.components(separatedBy: "|")
            
            let latitude = (item.first! as NSString).doubleValue
            let longitude = (item.last! as NSString).doubleValue
            
            // 获取最大最小经纬度
            if latitude > maxX {  maxX = latitude  }
            if latitude < minX {  minX = latitude  }
            if longitude > maxY {  maxY = longitude  }
            if longitude < minY {   minY = longitude }
            let coor = CLLocationCoordinate2DMake(latitude,longitude)
            coordinates.append(coor)
        }
        lineOne = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        //计算距离
        let sysDistance = CLLocation(latitude: minX, longitude: minY).distance(from: CLLocation(latitude: maxX, longitude: maxY))
        
        //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
        let bili = sysDistance/1110000000.0;
        let latM = 1.4 * bili * Double(UIScreen.main.bounds.size.width/375.0);
        let lonM = 1.4 * bili * Double(UIScreen.main.bounds.size.height/667.0);
        
        // 轨迹线范围
        let span = MKCoordinateSpan(latitudeDelta: latM, longitudeDelta: lonM)
        tempCoordinateRegion = MKCoordinateRegion.init(center: lineOne!.coordinate, span: span)
        trackMapView.setRegion(tempCoordinateRegion!, animated: true)
        let circle = MKCircle(center: CLLocationCoordinate2DMake(39.905, 116.398), radius: 100000000)
        circle.title = "opaque1"
        trackMapView.insertOverlay(circle, at: 0)
        self.circle = circle
        
    }
    
    
    //添加轨迹动画
    func trackPlayback() {
        
        let pointArr = pointsForCoordinates(tempCoordinate: coordinates)
        let path = pathForPoints(tempPointS: pointArr)
        initShapeLayerWithPath(path: path)
        constructShapeLayerAnimation()
        
        //在view上添加开始的图和结束的图
        startImageView.center = pointArr.first!
        view.addSubview(startImageView)
        endImageView.center = pointArr.last!
        view.addSubview(endImageView)
        let endAnnotation = constructEndAnnotationWithPath(path: path)
        endImageView.layer.add(endAnnotation, forKey: "annotation")
        
        //图层被挡住了
        perform(#selector(hiddenAnnotation), with: self, afterDelay: TimeInterval(Metric.animationDuration))
      
    }
    //自动隐藏动画
    @objc func hiddenAnnotation() {
        if onceUseAnnotation {
            return
        } else {
            onceUseAnnotation = true
        }
        
        // 起始点
        addAnnotation(coordinates.first!, Metric.StartAnnotation)
        addAnnotation(coordinates.last!, Metric.EndAnnotation)
        trackMapView.addOverlay(lineOne!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.shapeLayer!.isHidden = true
            self.shapeLayer!.removeAllAnimations()
            self.startImageView.removeFromSuperview()
            self.endImageView .removeFromSuperview()
        }
    }
    //手动隐藏动画
    func touchHiddenAnnotation() {
        if onceUseAnnotation {
            return
        } else {
            onceUseAnnotation = true
        }
        
        // 起始点
        addAnnotation(coordinates.first!, Metric.StartAnnotation)
        addAnnotation(coordinates.last!, Metric.EndAnnotation)
        trackMapView.addOverlay(lineOne!)
        
        self.shapeLayer?.isHidden = true
        self.shapeLayer?.removeAllAnimations()
        self.startImageView.removeFromSuperview()
        self.endImageView .removeFromSuperview()
    }


}

// MARK: - 工具方法
extension guijiViewController: CAAnimationDelegate {
    fileprivate func addAnnotation(_ coordinate: CLLocationCoordinate2D, _ title: String?) {
        let annotation = MKPointAnnotation()
        annotation.title = title ?? ""
        annotation.coordinate = coordinate
        trackMapView.addAnnotation(annotation)
    }
    //经纬度转屏幕坐标
    func pointsForCoordinates(tempCoordinate: [CLLocationCoordinate2D]) -> [CGPoint] {
        if tempCoordinate.isEmpty {
            return []
        }
        var pointArr: [CGPoint] = []
        for temp2D in tempCoordinate {
            pointArr.append(trackMapView.convert(temp2D, toPointTo: trackMapView))
        }
        return pointArr
    }
    //构建path
    func pathForPoints(tempPointS: [CGPoint]) -> CGMutablePath {
        let path = CGMutablePath()
        path.addLines(between: tempPointS)
        return path
    }
    //构建Annotation动画
    func constructEndAnnotationWithPath(path: CGMutablePath) -> CAAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.duration =  CFTimeInterval(Metric.animationDuration)
        keyFrameAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        keyFrameAnimation.path = path
        keyFrameAnimation.calculationMode = .paced
        return keyFrameAnimation
    }
    //初始化shapeLayer
    func initShapeLayerWithPath(path: CGPath) {
        shapeLayer = CAShapeLayer()
        shapeLayer?.strokeColor = UIColor.red.cgColor
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineJoin = .round
        shapeLayer?.path = path
        shapeLayer?.lineWidth = Metric.lineWidth
        view.layer.addSublayer(self.shapeLayer!)
    }
    //构建shapeLayer的动画
    func constructShapeLayerAnimation() {
       let theStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        theStrokeAnimation.duration = CFTimeInterval(Metric.animationDuration)
        theStrokeAnimation.fromValue = 0
        theStrokeAnimation.toValue = 1
        theStrokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
       //必须先初始化 shapeLayer
        theStrokeAnimation.delegate = self
        theStrokeAnimation.isRemovedOnCompletion = false
        theStrokeAnimation.fillMode = .forwards
        shapeLayer?.add(theStrokeAnimation, forKey: "shape")
    }
}
//按屏幕的监听
extension guijiViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHiddenAnnotation()
    }
}
extension guijiViewController: MKMapViewDelegate {
    // 起始点
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
        let imageName = annotation.title!!
        annotationView.image = UIImage(named: imageName)
        return annotationView
    }
    
    // 轨迹 && 蒙版
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.classForCoder()) {
            //半透明蒙层
            let circleRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
            if overlay.title == "opaque" {
                circleRenderer.fillColor = UIColor.orange
            } else {
                circleRenderer.fillColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            }
            return circleRenderer
        }
        // 轨迹
        let polyline = overlay as! MKPolyline
        let polylineRenderer = MKPolylineRenderer(polyline: polyline)
        polylineRenderer.lineWidth = Metric.lineWidth
        polylineRenderer.strokeColor = .red
        polylineRenderer.lineCap = .round
        polylineRenderer.lineJoin = .round
        return polylineRenderer as MKOverlayRenderer
    }
}

fileprivate let sporttrailDetails = "22.5544151627497|113.951851439363,22.5535714862551|113.951547026838,22.5544687886934|113.951605530715,22.5534893283866|113.951303951808,22.5535706880443|113.951220108493,22.5545477473901|113.950947559891,22.5546416545603|113.95095889657,22.5547295025474|113.950913998889,22.5548382690131|113.95091492902,22.5549186553884|113.950979057649,22.5549751646696|113.951071973507,22.5550676811827|113.951101187634,22.5551614216347|113.951112944033,22.5552543804109|113.951132338195,22.5553245541544|113.951050676975,22.555392157642|113.950983703863,22.5554881307141|113.950979429436,22.5555598455818|113.950914387195,22.5556196325934|113.950836418999,22.5556616313978|113.950727395586,22.555665585723|113.950624832874,22.5556730209966|113.950523194038,22.5556832992982|113.950417611114,22.5556714562396|113.95031647549,22.5556387148476|113.950223815773,22.5556106616742|113.950105474581,22.5556074903475|113.950001403311,22.5555732344395|113.949905135797,22.5555723529856|113.949792421002,22.5555722130222|113.949694981494,22.5555869391869|113.949590325621,22.555609940444|113.949495238325,22.5556349535737|113.949399983676,22.5556795580749|113.949314214247,22.5556745036623|113.949210062314,22.5557042965689|113.949115144788,22.5556866810235|113.949017539043,22.5556710635165|113.948912212777,22.5556501001366|113.948817041436,22.5556577901162|113.94871331207,22.5556754024763|113.948603289534,22.5557026657276|113.948498974867,22.5557328843463|113.948406242154,22.5558001950213|113.948103959197,22.5558375366996|113.948009214354,22.5560106147961|113.947715670803,22.5560859167113|113.947659700892,22.5559799071197|113.947394592514,22.5558881782236|113.94735816588,22.5558062218428|113.947301851183,22.5557079730601|113.947275830184,22.5556096641066|113.947263152256,22.5555332782706|113.947204488423,22.555445594422|113.947179978728,22.5553544743166|113.947155804514,22.5552639465105|113.947134735332,22.5551716426857|113.947104770747,22.5550825176537|113.947071030096,22.554960990677|113.94703552517,22.5548689903445|113.947035015841,22.5547737770457|113.947042646332,22.5546831079059|113.94703643068,22.5545931394807|113.947023501655,22.5545023593617|113.947001845152,22.5544159754344|113.946953671014,22.5543456190044|113.946891064219"



