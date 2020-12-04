//
//  userInfoViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/20.
//

import UIKit

class userInfoViewController: AnalyticsViewController {

    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var vipTitle: UILabel!

    @IBOutlet weak var vipLevel: UILabel!
    
    @IBOutlet weak var vipLine: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "编辑资料"
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
                vipTitle.isHidden = true
                vipLevel.isHidden = true
                vipLine.isHidden = true
               
            }else if vip as! Int == 1 {//已开通月卡会员
                
                vipTitle.isHidden = false
                vipLevel.isHidden = false
                vipLine.isHidden = false
                vipLevel.text = "月卡会员"
               
            }else if vip as! Int == 2 {//已开通季卡会员
                
                vipTitle.isHidden = false
                vipLevel.isHidden = false
                vipLine.isHidden = false
                
                vipLevel.text = "季卡会员"
                
                
            }else if vip as! Int == 3{//已开通年卡会员
                
                vipTitle.isHidden = false
                vipLevel.isHidden = false
                vipLine.isHidden = false
                
                vipLevel.text = "年卡会员"
                
            }
        }else{
           
        }
        

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 27/255, green: 39/255, blue: 85/255, alpha: 1)

        let niakname = user?.object(forKey: "nickName")
        if niakname == nil {
            let user = BmobUser.current()?.mobilePhoneNumber.replacePhone()
            
            textField.attributedPlaceholder = NSAttributedString.init(string:user!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        }else{
            
            textField.attributedPlaceholder = NSAttributedString.init(string:niakname as! String, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let savedImage = UIImage(contentsOfFile: UserDefaults.string(forKey: .headerImage) ?? "") {
            
            self.header.image = savedImage
            
        } else {
            
            print("文件不存在")
            
        }
    }
    
    //MARK: - 相机

    //从相册中选择
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }


    //拍照
    func initCameraPicker(){

        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {

           print("不支持拍照")

        }

    }

    //MARK:选择头像
    @IBAction func iconAction(_ sender: Any) {
        
        let sexActionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)

                weak var weakSelf = self

        let sexNanAction = UIAlertAction(title: "从相册中选择", style: UIAlertAction.Style.default){ (action:UIAlertAction)in

                    weakSelf?.initPhotoPicker()

                }

        let sexNvAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
                    weakSelf?.initCameraPicker()
            
                }


        let sexSaceAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){ (action:UIAlertAction)in

                }

        sexActionSheet.addAction(sexNanAction)
        sexActionSheet.addAction(sexNvAction)
        sexActionSheet.addAction(sexSaceAction)
        self.present(sexActionSheet, animated: true, completion: nil)
        
    }
    
    //MARK:确认提交
    @IBAction func centerAction(_ sender: Any) {
        SVProgressHUD.showInfo(withStatus: "保存信息中")
        if textField.text!.count > 1 {
            let user = BmobUser.current()
            user!.setObject(textField.text, forKey: "nickName")
            user!.updateInBackground { (isSuccessful, error) in

                if(isSuccessful){
                    SVProgressHUD.dismiss()
                    SVProgressHUD.show(withStatus: "更新昵称成功")
                    SVProgressHUD.dismiss(withDelay: 0.75)
                }else{
                    SVProgressHUD.show(withStatus: "更新昵称失败")
                    SVProgressHUD.dismiss(withDelay: 0.75)
                }
                
            }
        }else{
            print("没有改变昵称")
        }
        
        if (header.image != nil) {
            
            let imagepath = saveImage(currentImage: header.image!, persent: 1, imageName: "header")
            
            UserDefaults.set(value: imagepath, forKey: UserDefaults.LoginInfo.headerImage)
            
           
            
//            let imageData = header.image?.pngData()
//
////            print(path)
//               let obj = BmobObject(className: "phone")
////               let  file = BmobFile(filePath: headerPath)
//            let file = BmobFile(fileName: "hedaer.png", withFileData: imageData)
//
//                file?.save(inBackground: { (isSuccessful, error) in
//               if isSuccessful {
//                   //如果文件保存成功，则把文件添加到file列
//                   let weakFile = file
//                obj?.setObject(weakFile, forKey: "file")
//                obj?.setObject("helloworld", forKey: "name")
//                obj?.saveInBackground(resultBlock: { (success, err) in
//                       if err != nil {
//                           print("save \(error)")
//                       }
//                   })
//               }else{
//                   print("upload \(error)")
//               }
//               }) { (progress) in
//                   print("progress \(progress)")
//               }

        }
        
    }
//    if let imageData = currentImage.jpegData(compressionQuality: persent) as NSData? {
    
    
}


extension userInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获得照片
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage

               // 拍照
               if picker.sourceType == .camera {
                //保存相册
               UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
               }

               header.image = image

               self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {

            if error != nil {

                print("保存失败")


            } else {

                print("保存成功")


            }
        }

}
