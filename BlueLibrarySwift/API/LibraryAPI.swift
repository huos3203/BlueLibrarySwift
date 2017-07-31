//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit

/// 使用创建型单例模式，结构型外观模式封装各层级接口
class LibraryAPI: NSObject
{
    ///单例，类计算属性
    class var shared:LibraryAPI {
        
        struct Singleton {
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
        NotificationCenter.default.addObserver(self, selector:Selector(("downloadImage:")), name: Notification.Name(rawValue: "BLDownloadImageNotification"), object: nil)
    }
    
    /// get album array
    func getAlbums()->[Album]
    {
        //
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(_ album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClientManager.postRequest("/api/addAlbum", body: album.description)
        }
    }
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    func deleteAlbum(_ index: Int) {
        persistencyManager.deleteAlbumAt(index)
        if isOnline {
            httpClientManager.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    /// down image
    func downloadImageByURLSession()
    {
        ///
        httpClientManager.downImageBy(url: URL.init(string: "")!) { (location) in
            ///
            self.localFileManager.saveImageToDocument(location: location, imageName: "")
        }
    }
    
    func downloadImage(notification: Notification) {
        //1
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imageView = userInfo["coverImage"] as! UIImageView?
        let coverUrl = userInfo["coverUrl"] as! NSString
        imageView?.image = UIImage(named: "barcelona-thumb")
        //2
        if let imageViewUnWrapped = imageView {
            imageViewUnWrapped.image = persistencyManager.getImage(coverUrl.lastPathComponent)
            if imageViewUnWrapped.image == nil {
                //3
                DispatchQueue.global().async {
                    let downloadedImage = self.httpClientManager.downloadImage(url: coverUrl as String)
                    //4
                    DispatchQueue.main.async {
                        imageViewUnWrapped.image = downloadedImage
                        self.persistencyManager.saveImage(image: downloadedImage, filename: coverUrl.lastPathComponent)
                    }
                }
            }
        }
    }
}
