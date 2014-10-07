//  ViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

var gDownloaders:NSMutableArray = NSMutableArray()
var currentImageDownloader:ImageDownloader?
var gSelectedItemIndex:Int?

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlickrPhotoWithSearchString("Ric");
    }
    
    override func viewDidAppear(animated: Bool) {
        self.title = "Flickr Viewer"
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - NSURLSesson
    
    
    func fetchFlickrPhotoWithSearchString(searchString:String) {
        
        let url = getURLForString(searchString)
        
        var gPhotoData:Array<Dictionary<String,AnyObject>>?
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            if let httpRes = response as? NSHTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let string = stringByRemovingFlickrJavaScriptFromData(data)
                    let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    
                    let JSONDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as NSDictionary!
                    let photos: AnyObject? = JSONDict["photos"]
                    
                    gPhotoData = (photos!["photo"] as Array<Dictionary<String,AnyObject>>)
                    
                    let myCount = (gPhotoData!.count - 1)
                    
                    for index in 0...myCount {
                        let downloader:ImageDownloader = ImageDownloader(dict: gPhotoData![index])
                        gDownloaders.addObject(downloader)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView.reloadData();
                    })
                    
                } else {
                    println("*** ERROR: http status code: \(httpRes.statusCode)")
                }
            } else {
                println("*** ERROR: Bad Response: \(response)")
            }
        }
        
        task.resume()
        
    } // ...end class ViewController().
    
    // =======================================================================================================================
    // MARK: -
    func doSomething() {
        //   ...something
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Action Methods
    
    @IBAction func doSomething(sender: AnyObject) {
        doSomething()
    }
    
    @IBAction func exitAction(sender: AnyObject) {
        exit(0)
    }
    
}

// =======================================================================================================================
// MARK: - Extensions

extension ViewController: UICollectionViewDataSource {
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gDownloaders.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath:indexPath)
        let photoImageView = cell.viewWithTag!(1) as UIImageView
        
        gSelectedItemIndex = indexPath.item as Int
        let currentImageDownloader:ImageDownloader = gDownloaders[gSelectedItemIndex!] as ImageDownloader
        
        if let image:UIImage = currentImageDownloader.image {
            photoImageView.image = image
        } else {
            var myDict = currentImageDownloader.dict!
            var urlString:String = myDict["url_sq"]! as String
            let url = NSURL(string:urlString)
            
            currentImageDownloader.downloadImageAtURL(url, completion: {(image:UIImage?, error:NSError?) in
                if let myImage = image {
                    photoImageView.image = myImage
                } else if let myError = error {
                    println("*** ERROR in cell: \(myError.userInfo)")
                }
            }) // ...end completion.
            
        }
        return cell as UICollectionViewCell
    }
    
}

