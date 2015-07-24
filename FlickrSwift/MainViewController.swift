//  MainViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

var gDownloaders:NSMutableArray = NSMutableArray()
var gCurrentImageDownloader:ImageDownloader?
var gSelectedItemIndex:Int = 0

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlickrPhotoWithSearchString("Ric");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Flickr Viewer"
        if nil != gCurrentImageDownloader {
            gDownloaders.replaceObjectAtIndex(gSelectedItemIndex, withObject: gCurrentImageDownloader!)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - NSURLSesson
    
    
    func fetchFlickrPhotoWithSearchString(searchString:String) {
        
        let url = getURLForString("Ric")
        
        var photoData:Array<Dictionary<String,AnyObject>>?
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data:NSData?, response: NSURLResponse?, error:NSError?) in
            if let httpRes = response as? NSHTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let string = stringByRemovingFlickrJavaScriptFromData(data!)
                    let myData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    
                    do {
                        let JSONDict: NSDictionary = try  NSJSONSerialization.JSONObjectWithData(myData!, options: .AllowFragments) as! NSDictionary
                        
                        let photos: AnyObject? = JSONDict["photos"]
                        
                        photoData = (photos!["photo"] as! Array<Dictionary<String,AnyObject>>)
                        
                        let myCount = (photoData!.count - 1)
                        
                        for index in 0...myCount {
                            let downloader:ImageDownloader = ImageDownloader(dict: photoData![index])
                            gDownloaders.addObject(downloader)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.collectionView.reloadData();
                        })
                    } catch _ {
                        
                    }
                    
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
    
    // -----------------------------------------------------------------------------------------------------
    
    func doSomething() {
        let requestTokenURL = getRequestTokenURL()   // 1.
        
        // (2)...counterpart to (1) func() "complReturn"
        fetchResponseForRequest(requestTokenURL, completion: {(statusCode:Int?, response:String?, error:NSError?) in
            if let myError = error {
                print(error)
            } else {
                if let myStatusCode = statusCode {
                    if myStatusCode != 200 {
                        let controller = UIAlertController(title: "Unable to Generate Request Token", message: "Code: \(myStatusCode)\n Check your URL value.", preferredStyle: .Alert)
                        let myAlertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                        controller.addAction(myAlertAction)
                        self.presentViewController(controller, animated:true, completion:nil)
                        return;
                    } else {
                        // do Something with data.
                    }
                }
            }
        }) // ...end completion.
    }
    
    // =======================================================================================================================
    // MARK: - Action Methods
    
    
    @IBAction func doSomethingAction(sender: UIButton) {
        
        let myFlickr = FlickrKit(apiKey: "Turkey", sharedSecret: "Turkey is great with Cranberry Sauce")
        let me = FKPermission.FKPermissionRead
        let url = myFlickr.userAuthorizationURLWithRequestToken("http://www.apple.com",requestedPermission: me)
        
        print("Hello from ViewController:\(url)")
    }
    
    @IBAction func exitAction(sender: AnyObject) {
        exit(0)
    }
    
}

// =======================================================================================================================
// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gDownloaders.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath:indexPath)
        let photoImageView = cell.viewWithTag!(1) as! UIImageView
        
        let selectedItemIndex = indexPath.item as Int
        let currentImageDownloader:ImageDownloader = gDownloaders[selectedItemIndex] as! ImageDownloader
        
        if let image:UIImage = currentImageDownloader.image {
            photoImageView.image = image
        } else {
            var myDict = currentImageDownloader.dict!
            let urlString:String = myDict["url_sq"]! as! String
            let url = NSURL(string:urlString)
            
            currentImageDownloader.downloadImageAtURL(url!, completion: {(image:UIImage?, error:NSError?) in
                if let myImage = image {
                    photoImageView.image = myImage
                } else if let myError = error {
                    print("*** ERROR in cell: \(myError.userInfo)")
                }
            }) // ...end completion.
        }
        return cell as! UICollectionViewCell
    }
}

// -----------------------------------------------------------------------------------------------------

extension MainViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems() as [NSIndexPath]?
            gSelectedItemIndex = selectedIndexPaths![0].item
            gCurrentImageDownloader = gDownloaders.objectAtIndex(gSelectedItemIndex) as? ImageDownloader
        }
    }
}








