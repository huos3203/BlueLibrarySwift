//
//  AlbumExtensions.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 31/07/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import Foundation
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
