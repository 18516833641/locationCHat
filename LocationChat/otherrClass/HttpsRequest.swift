//
//  HttpsRequest.swift
//  NorthEnvironmenSwift
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 jietingzhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RequestType {
    case Get
    
    case Post
    
    case Put
    
    case Delete
}

typealias complete = (Error?,Data?)->Void


class BKHttpTool {

    static let shareInstance:BKHttpTool = {
        
        let tools = BKHttpTool()
        return tools
    }()
}

extension BKHttpTool {
    
    static func requestData(requestType : RequestType,URLString : String,parameters : [String:Any]? ,headers: HTTPHeaders? = nil, successed : @escaping complete,failured:@escaping complete){
        
        //获取请求类型
        var method : HTTPMethod?
        
        switch requestType {
        case .Get:
            method = HTTPMethod.get
        case .Post:
            method = HTTPMethod.post
        case .Put:
            method = HTTPMethod.put
        case .Delete:
            method = HTTPMethod.delete
            
        }
       
//        
//        let headers:HTTPHeaders = [
//            "token"     : "token",
//        ]
        
        //发送网络请求responseJSON
        AF.request(URLString, method: method!, parameters: parameters, headers: headers).responseJSON { (response) in
            //获取返回结果
//            let res = response
            
            switch response.result {
            case .success:
                
//                let json = JSON(response.value as Any)
//                print("-------:\(json)")
                successed(nil, response.data)
                
            case .failure:

                failured(response.error, nil)
            }
            
        }
    }

    
    
}
