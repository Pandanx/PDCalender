//
//  NetWorkManager.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/8/15.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import Foundation
import Alamofire
let testUrl: String = "https://www.baidu.com"
class NetWorkManager {
    func request() {
        Alamofire.request(URL(string:testUrl)!).responseJSON { (response) in
            print("========\(response)======")
        }
    }
    
}
