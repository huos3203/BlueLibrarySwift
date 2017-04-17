//
//  LocalFileManager.swift
//  BlueLibrarySwift
//
//  Created by pengyucheng on 17/04/2017.
//  Copyright © 2017 XcodeServer. All rights reserved.
//

import UIKit

/**
 /文件系统的管理工具
 创建目录
 保存文件
 删除文件
 查找文件
 */
class LocalFileManager: FileManager
{
    ///
    func createDocumentPathFrom(fileName name:String) -> String
    {
        //
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return docPath + name
    }
    
    
    ///将下载到本地的图片数据，保存到沙河文档目录
    func saveImageToDocument(location tmpUrl:URL,imageName fileName:String) -> String
    {
        //将下载到本地的图片数据，保存到文档目录
        let docPath = createDocumentPathFrom(fileName: fileName)
        
        let targetDir = URL.init(string: docPath)!
        //Data方法
        let imageData = try? Data.init(contentsOf: tmpUrl)
        try? imageData?.write(to: targetDir, options: .atomic)
        
        //File方法
        //try? copyItem(at: tmpUrl, to: targetDir)
        return docPath
    }
}
