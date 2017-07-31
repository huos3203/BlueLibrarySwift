//
//  PersistencyManager.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit

///管理model
class PersistencyManager
{
    //定义了一个私有属性，用来存储专辑数据
    fileprivate var albums = [Album]()
    //初始化数据
    init() {
        //
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
                           artist: "David Bowie",
                           gener: "Pop",
                           coverUrl: "http://boyers.coding.me/images/QQ20160114-0.png",
                           year: "1992")
        
        let album2 = Album(title: "It's My Life",
                           artist: "No Doubt",
                           gener: "Pop",
                           coverUrl: "http://boyers.coding.me/images/vIfAjiY.png!web.png",
                           year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
                           artist: "Sting",
                           gener: "Pop",
                           coverUrl: "http://boyers.coding.me/images/IMG_0028.JPG",
                           year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
                           artist: "U2",
                           gener: "Pop",
                           coverUrl: "http://boyers.coding.me/images/QQ20160114-1.png",
                           year: "2000")
        
        
        let album5 = Album(title: "American Pie",
                           artist: "Madonna",
                           gener: "Pop",
                           coverUrl: "http://boyers.coding.me/images/QbMJNrM.png!web.png",
                           year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
    }
    
    //查询
    func getAlbums()->[Album]{
        return albums
    }
    
    //添加专辑
    func addAlbum(_ album:Album,index:Int){
        if albums.count >= index {
            //
            albums.insert(album, at: index)
        }else{
            albums.append(album)
        }
    }
    func saveAlbums() {
        let filename = NSHomeDirectory().appending("/Documents/albums.bin")
        let data = NSKeyedArchiver.archivedData(withRootObject: albums)
        (data as NSData).write(toFile: filename, atomically: true)
    }
    //删除操作
    func deleteAlbumAt(_ index:Int) {
        //
        albums.remove(at: index)
    }
    
    func getImage(_ filename: String) -> UIImage? {
        var err: Error?
        let path = NSHomeDirectory().appending("/Documents/\(filename)")
        var data:Data!
        do {
            data = try NSData.init(contentsOfFile: path, options: .uncachedRead) as Data!
        } catch {
            err = error
        }
        if err != nil {
            return nil
        } else {
            return UIImage(data: data as Data)
        }
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = NSHomeDirectory().appending("/Documents/\(filename)")
        let data = UIImagePNGRepresentation(image)
        (data! as NSData).write(toFile: path, atomically: true)
    }
}
