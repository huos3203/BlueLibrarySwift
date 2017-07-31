//
//  ViewController.swift
//  BlueLibrarySwift
//
//  Created by Xcode Server on 2017/4/17.
//  Copyright © 2017年 XcodeServer. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var dataTable: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet weak var scroller: HorizontalScroller!
    
    private var allAlbums = [Album]()
    private var currentAlbumData : (titles:[String], values:[String?])?
    private var currentAlbumIndex = 0
    
    // We will use this array as a stack to push and pop operation for the undo option
    var undoStack: [(Album, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
        self.navigationController?.navigationBar.isTranslucent = false
        currentAlbumIndex = 0
        
        //2
        allAlbums = LibraryAPI.shared.getAlbums()
        
        // 3
        // the uitableview that presents the album data
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        view.addSubview(dataTable!)
        
        self.showDataForAlbum(currentAlbumIndex)
        
        loadPreviousState()
        
        scroller.delegate = self
        reloadScroller()
        
        let undoButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action:"undoAction")
        undoButton.isEnabled = false;
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action:nil)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target:self, action:"deleteAlbum")
        let toolbarButtonItems = [undoButton, space, trashButton]
        toolbar.setItems(toolbarButtonItems, animated: true)
        
        NotificationCenter.default.addObserver(self, selector:"saveCurrentState", name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        return currentAlbumIndex
    }
    
    func showDataForAlbum(_ albumIndex: Int) {
        // defensive code: make sure the requested index is lower than the amount of albums
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            //fetch the album
            let album = allAlbums[albumIndex]
            // save the albums data to present it later in the tableview
            currentAlbumData = album.ae_TableRepresentation()
        } else {
            currentAlbumData = nil
        }
        // we have the data we need, let's refresh our tableview
        dataTable!.reloadData()
    }
    
    func reloadScroller() {
        allAlbums = LibraryAPI.shared.getAlbums()
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if currentAlbumIndex >= allAlbums.count {
            currentAlbumIndex = allAlbums.count - 1
        }
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAlbumAtIndex(album: Album,index: Int) {
        LibraryAPI.shared.addAlbum(album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
    
    func deleteAlbum() {
        //1
        var deletedAlbum : Album = allAlbums[currentAlbumIndex]
        //2
        var undoAction = (deletedAlbum, currentAlbumIndex)
        undoStack.insert(undoAction, at: 0)
        //3
        LibraryAPI.shared.deleteAlbum(currentAlbumIndex)
        reloadScroller()
        //4
        let barButtonItems = toolbar.items as! [UIBarButtonItem]
        var undoButton : UIBarButtonItem = barButtonItems[0]
        undoButton.isEnabled = true
        //5
        if (allAlbums.count == 0) {
            var trashButton : UIBarButtonItem = barButtonItems[2]
            trashButton.isEnabled = false
        }
    }
    
    func undoAction() {
        let barButtonItems = toolbar.items as! [UIBarButtonItem]
        //1
        if undoStack.count > 0 {
            let (deletedAlbum, index) = undoStack.remove(at: 0)
            addAlbumAtIndex(album: deletedAlbum, index: index)
        }
        //2
        if undoStack.count == 0 {
            var undoButton : UIBarButtonItem = barButtonItems[0]
            undoButton.isEnabled = false
        }
        //3
        let trashButton : UIBarButtonItem = barButtonItems[2]
        trashButton.isEnabled = true
    }
    
    //MARK: Memento Pattern
    func saveCurrentState() {
        // When the user leaves the app and then comes back again, he wants it to be in the exact same state
        // he left it. In order to do this we need to save the currently displayed album.
        // Since it's only one piece of information we can use NSUserDefaults.
        UserDefaults.standard.set(currentAlbumIndex, forKey: "currentAlbumIndex")
        LibraryAPI.shared.saveAlbums()
    }
    
    func loadPreviousState() {
        currentAlbumIndex = UserDefaults.standard.integer(forKey: "currentAlbumIndex")
        showDataForAlbum(currentAlbumIndex)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albumData = currentAlbumData {
            return albumData.titles.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        if let albumData = currentAlbumData {
            cell.textLabel?.text = albumData.titles[indexPath.row]
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = albumData.values[indexPath.row]
            }
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
}

extension ViewController: HorizontalScrollerDelegate {
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> (Int) {
        return allAlbums.count
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> (UIView) {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), albumCover: album.coverUrl)
        if currentAlbumIndex == index {
            albumView.highlightAlbum(didHighlightView: true)
        } else {
            albumView.highlightAlbum(didHighlightView: false)
        }
        return albumView
    }
    
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        //1
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(didHighlightView: false)
        //2
        currentAlbumIndex = index
        //3
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        albumView.highlightAlbum(didHighlightView: true)
        //4
        showDataForAlbum(index)
    }
}
