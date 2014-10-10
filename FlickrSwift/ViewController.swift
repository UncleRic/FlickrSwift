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
        
      let url = getURLForString("Ric")
        
        var photoData:Array<Dictionary<String,AnyObject>>?
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data:NSData!, response: NSURLResponse!, error:NSError!) in
            if let httpRes = response as? NSHTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let string = stringByRemovingFlickrJavaScriptFromData(data)
                    let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    var jsonError:NSError?
                    //TODO: Use Optional handler for NSDictionary.  Curently NSDictionary doesn't handle optionals; filed an Apple Bug accordingly.
                    let JSONDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: &jsonError) as NSDictionary
                    
                    if let error = jsonError {
                        println("*** ERROR found in JSONDict parsing. ****")
                        return;
                    }
                    let photos: AnyObject? = JSONDict["photos"]
                    
                    photoData = (photos!["photo"] as Array<Dictionary<String,AnyObject>>)
                    
                    let myCount = (photoData!.count - 1)
                    
                    for index in 0...myCount {
                        let downloader:ImageDownloader = ImageDownloader(dict: photoData![index])
                        gDownloaders.addObject(downloader)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView.reloadData();
                    })
                    
                } else {
                    let controller = UIAlertController(title: "Service Not Found", message: "Code: \(httpRes.statusCode)\n Check your URL value.", preferredStyle: .Alert)
                    let myAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    controller.addAction(myAlertAction)
                    self.presentViewController(controller, animated:true, completion:nil)
                    return;
                }
            } else {
                let controller = UIAlertController(title: "No Wi-Fi", message: "Wi-Fi needs to be restored before continuing.", preferredStyle: .Alert)
                let myAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                controller.addAction(myAlertAction)
                self.presentViewController(controller, animated:true, completion:nil)
                return;
            }
        }
        
        task.resume()
        
    }
    
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
            
            currentImageDownloader.downloadImageAtURL(url!, completion: {(image:UIImage?, error:NSError?) in
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

