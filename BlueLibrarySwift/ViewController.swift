//
//  ViewController.swift
//  BlueLibrarySwift
//
//  Created by Xcode Server on 2017/4/17.
//  Copyright © 2017年 XcodeServer. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albums = LibraryAPI.shared.getAlbumArray()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //
        return albums.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            //
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        let album = LibraryAPI.shared.getAlbumArray()[indexPath.row]
        cell?.textLabel?.text = album.title
        cell?.detailTextLabel?.text = album.artist
        return cell!
    }
    
    
    
    //代理tableView点击某个单元格的事件
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //提示点击了某个单元格
        let alertView = UIAlertController.init(title: "代理事件", message: "点击对象是：\(albums[indexPath.row].artist)", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .destructive) { _ in
            //默认消失...
            print("点击OK")
        }
        
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}

