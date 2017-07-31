//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit
//外观模式（Facade）作为专辑管理类的入口
//LibraryAPI 暴露一个简单的接口给其他类来访问，这样外部的访问类不需要知道内部的业务具体是怎样的，也不用知道你是通过 PersistencyManager 还是 HTTPClient 获取到数据的
/// 使用创建型单例模式，结构型外观模式封装各层级接口
class LibraryAPI: NSObject
{
    ///单例，计算属性的类变量
    class var shared:LibraryAPI {
        
        struct Singleton {
            //存储类型的类常量，延时加载的策略(static静态修饰符)
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    
    private let httpClientManager:HttpClientManager
    private let localFileManager:LocalFileManager
    private let persistencyManager:PersistencyManager
    private let isOnline: Bool
    override init()
    {
        httpClientManager = HttpClientManager()
        localFileManager = LocalFileManager()
        persistencyManager = PersistencyManager()
        
        isOnline = false
        super.init()
        NotificationCenter.default.addObserver(self, selector:#selector(LibraryAPI.downloadImage(notification:)),
                                               name: Notification.Name(rawValue: "BLDownloadImageNotification"),
                                               object: nil)
    }
    
    //MARK: - 管理专辑： 增删改查
    func addAlbum(_ album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClientManager.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func getAlbums()->[Album]
    {
        //
        return persistencyManager.getAlbums()
    }
    
    
    func deleteAlbum(_ index: Int) {
        persistencyManager.deleteAlbumAt(index)
        if isOnline {
            httpClientManager.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    
    //MARK: - 加载专辑封面图片
    func downloadImageByURLSession()
    {
        ///
        httpClientManager.downImageBy(url: URL.init(string: "")!) { (location) in
            ///
//            self.localFileManager.saveImageToDocument(location: location, imageName: "")
        }
    }
    
    func downloadImage(notification: Notification) {
        //1
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imageView = userInfo["coverImage"] as! UIImageView?
        let coverUrl = userInfo["coverUrl"] as! String
        imageView?.image = UIImage(named: "barcelona-thumb")
        //2
        if let imageViewUnWrapped = imageView {
            imageViewUnWrapped.image = persistencyManager.getImage((coverUrl as NSString).lastPathComponent)
            if imageViewUnWrapped.image == nil {
                
                httpClientManager.downImageBy(url: URL(string: coverUrl)!, complecion: { (location) in
                    
                    let downloadedImage = UIImage.init(contentsOfFile: location)
                    imageViewUnWrapped.image = downloadedImage
                })
                /*/3
                DispatchQueue.global().async {
                    let downloadedImage = self.httpClientManager.downloadImage(url: coverUrl as String)
                    //4
                    DispatchQueue.main.async {
                        imageViewUnWrapped.image = downloadedImage
                        if let image = downloadedImage{
                            self.persistencyManager.saveImage(image: image, filename: coverUrl.lastPathComponent)
                        }
                        
                    }
                }
                */
            }
        }
    }
}
