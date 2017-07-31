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




