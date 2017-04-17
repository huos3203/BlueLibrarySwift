//
//  HttpClientManager.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit
import Foundation
/**
 访问网络
 下载远程文件
 管理远程数据
 */

class HttpClientManager: NSObject
{
    
    
    typealias handlerType = (URL)->Void
    var complection:handlerType?
    
    
    
    ///下载接口
    func downImageBy(url:URL,complecion:@escaping handlerType)
    {
        ///
        URLSession.shared.downloadTask(with: url) { (location, response, error) in
            //
            if error != nil
            {
                print("\(error?.localizedDescription)")
            }
            complecion(location!)
        }
        
    }
    
    
    /// del api
    func delBy(albumId:String,hander:@escaping handlerType)
    {
        ///
        let api = "http://www.com.cn"+albumId
        let request = URLRequest.init(url: URL.init(string: api)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            ///
            if error != nil
            {
                print("删除错误：\(error?.localizedDescription)")
            }
            
            hander(URL.init(string: "")!)
        }
    }
    /// add api
    
    /// update api

}
