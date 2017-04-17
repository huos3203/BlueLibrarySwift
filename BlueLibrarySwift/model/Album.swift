//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by Xcode Server on 2017/4/17.
//  Copyright © 2017年 XcodeServer. All rights reserved.
//

import UIKit

/**
 专辑对象
    * 专辑名称
    * 专辑作者
    * 派系
    * 封面
    * 年份
 */
class Album: NSObject
{
    var title:String?
    var artist:String?
    var gener:String?
    var coverUrl:String?
    var year:String?
    
    ///构造器
    init(title:String,artist:String,gener:String,coverUrl:String,year:String)
    {
        //
        self.title = title
        self.artist = artist
        self.gener = gener
        self.coverUrl = coverUrl
        self.year = year
    }
    
    override var description: String
    {
        return "标题：\(title) 艺术家：\(artist) 派系：\(gener) 封面：\(coverUrl) 年份：\(year)"
    }
}

/// 修饰器：扩展model方法，达到VM模式
extension Album
{
    func ae_TableRepresentation() -> (titles:[String],values:[String?])
    {
        let titles = ["Artist","title","gener","year"]
        let values = [artist,title,gener,year]
        return (titles,values)
    }
}


