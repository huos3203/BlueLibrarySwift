//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit

/// 使用创建型单例模式，结构型外观模式封装各层级接口
class LibraryAPI
{
    ///单例，类计算属性
    class var shared:LibraryAPI {
        
        struct Singleton {
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    
    let httpClientManager:HttpClientManager
    let localFileManager:LocalFileManager
    let persistencyManager:PersistencyManager
    
    init()
    {
        httpClientManager = HttpClientManager()
        localFileManager = LocalFileManager()
        persistencyManager = PersistencyManager()
    }
    
    /// down image
    func getImage()
    {
        ///
        httpClientManager.downImageBy(url: URL.init(string: "")!) { (location) in
            ///
            self.localFileManager.saveImageToDocument(location: location, imageName: "")
        }
    }
    
    
    /// get album array
    func getAlbumArray()->[Album]
    {
        //
        return persistencyManager.getAlbums()
    }
    
    
}
