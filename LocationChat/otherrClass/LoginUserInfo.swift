//
//  LoginUserInfo.swift
//  NorthEnvironmenSwift
//
//  Created by mac on 2020/8/21.
//  Copyright © 2020 jietingzhang. All rights reserved.
//

import UIKit

// 登录信息
struct t_LoginInfo_data:Decodable {

    var PhoneNumber:String? = nil//手机号
    var vip:String = "0" //是否开通vip
    var nickName:String? = nil//昵称
    var address:String = ""
    var time = ""
    var headerImage = ""
    
    
    
    
    
}

extension UserDefaults {
    enum LoginInfo: String {

        case PhoneNumber//手机号
        case nickName//昵称
        case vip
        case address
        case time
        case headerImage
    }
    
    //存数据
    static func set(value: String, forKey key: LoginInfo) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }

    //取数据
    static func string(forKey key: LoginInfo) -> String? {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key)
    }
}
