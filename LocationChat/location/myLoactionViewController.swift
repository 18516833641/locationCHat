//
//  myLoactionViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
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

class myLoactionViewController: AnalyticsViewController {
    
    var location = ""
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var startTimeBut: UIButton!
    @IBOutlet weak var endTimeBut: UIButton!
    
    var startTimeLab = ""
    var endTimeLab = ""
    
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
        self.title = "我的轨迹"
        
        trackMapView.delegate = self
//        trackMapView.zoomLevel = 9
        view.addSubview(trackMapView)
        
        self.view.bringSubviewToFront(topView)

        
        
    }
    
    func apiLocaton() {

        let user = BmobUser.current()

        let query:BmobQuery = BmobQuery(className: "Locat" + user!.mobilePhoneNumber)
        
        query.whereKey("lastTime", greaterThanOrEqualTo:startTimeLab ) //大于等于开始时间
        query.whereKey("lastTime", lessThanOrEqualTo: endTimeLab)//小于结束时间
        
            query.findObjectsInBackground { (array, error) in
                for i in 0..<array!.count{
                    let obj = array?[i] as! BmobObject
                    self.latitude = obj.object(forKey: "latitude") as! Double
                    self.longitude = obj.object(forKey: "longitude") as! Double
                    
                    self.location = String(self.latitude) + "|" + String(self.longitude)
                    
                    self.trackArr.append(self.location)
                
//                    print("======\(self.latitude) + \(self.longitude)")
                        print("-------- \(self.trackArr)")

               }
                
                self.loactionAction()
                
//                self.tableView.reloadData()
           }
        
//
    }
    
    

    //MARK:开始时间
    @IBAction func startTimeAction(_ sender: Any) {
    
        Dialog()
            
        .wDateTimeTypeSet()("yyyy-MM-dd HH:mm")
        .wTypeSet()(DialogTypeDatePicker)
        .wOKColorSet()(UIColor.lightGray)
//            .wTitle("开始时间")
        .wCancelColorSet()(UIColor.lightGray)
        .wShadowAlphaSet()(0.3)
        .wStart()
        
        .wEventOKFinishSet()(){ anyid,otherData in
           
           print("\(otherData as! String)")

           self.startTimeLab = otherData as! String

           self.startTimeBut.setTitle((otherData as! String), for: .normal)

        }
        
    }
    
    //MARK:结束时间
    @IBAction func endTimeAction(_ sender: Any) {
        
        Dialog()
            
        .wDateTimeTypeSet()("yyyy-MM-dd HH:mm")
//             = "结束时间"
//            .wTitle
        .wTypeSet()(DialogTypeDatePicker)
        .wOKColorSet()(UIColor.lightGray)
        .wCancelColorSet()(UIColor.lightGray)
        .wShadowAlphaSet()(0.3)
        .wStart()
        
        .wEventOKFinishSet()(){ anyid,otherData in
           
           print("\(otherData as! String)")

            self.endTimeLab = otherData as! String

           self.endTimeBut.setTitle((otherData as! String), for: .normal)

        }
        
    }
    
    //MARK:开始轨迹回放
    @IBAction func myLoactionAction(_ sender: Any) {
        
        if startTimeLab.isEmpty {
            SVProgressHUD.show(withStatus: "请选择开始时间")
            SVProgressHUD.dismiss(withDelay: 1)
            
            return
        }
        if endTimeLab.isEmpty {
            SVProgressHUD.show(withStatus: "请选择结束时间")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        
        trackArr.removeAll()

        apiLocaton()
        
        
        
    }
    
    
    //MARK:画线方法
    func loactionAction() {


        print("\(trackArr)")
        
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
        trackPlayback()
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
        
        if coordinates.first == nil {
            return
        }
        
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
extension myLoactionViewController: CAAnimationDelegate {
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
extension myLoactionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHiddenAnnotation()
    }
}
extension myLoactionViewController: MKMapViewDelegate {
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

extension  MKMapView  {
     //缩放级别
     var  zoomLevel:  Int  {
         //获取缩放级别
         get  {
             return  Int (log2(360 * ( Double ( self .frame.size.width/256)
                 /  self .region.span.longitudeDelta)) + 1)
         }
         //设置缩放级别
         set  (newZoomLevel){
             setCenterCoordinate(coordinate:  self .centerCoordinate, zoomLevel: newZoomLevel,
                                 animated:  false )
         }
     }
     
     //设置缩放级别时调用
     private  func  setCenterCoordinate(coordinate:  CLLocationCoordinate2D , zoomLevel:  Int ,
                                      animated:  Bool ){
        
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2,  Double (zoomLevel)) *  Double ( self .frame.size.width) / 256)
        setRegion( MKCoordinateRegion (center: centerCoordinate, span: span), animated: animated)
        
    
     }
}
