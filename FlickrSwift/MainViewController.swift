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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Flickr Viewer"
        if nil != gCurrentImageDownloader {
            gDownloaders.replaceObject(at: gSelectedItemIndex, with: gCurrentImageDownloader!)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - NSURLSesson
    
    
    func fetchFlickrPhotoWithSearchString(_ searchString:String) {
        
        guard let url = getURLForString("Ric") else {
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if nil == error, let data = data {
                self.disseminateJSON(data: data)
            }
        }
        
        task.resume()
        
        
//        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data:Data?, response: URLResponse?, error:NSError?) in
//
//           // if let httpRes = response as? HTTPURLResponse {
//                //                if httpRes.statusCode == 200 {
//                //                    let string = stringByRemovingFlickrJavaScriptFromData(data!)
//                //                    let myData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//                //
//                //                    do {
//                //                        let JSONDict: NSDictionary = try  JSONSerialization.jsonObject(with: myData!, options: .allowFragments) as! NSDictionary
//                ////
//                ////                        let photos: AnyObject? = JSONDict["photos"]
//                ////
//                ////                        photoData = (photos!["photo"] as! Array<Dictionary<String,AnyObject>>)
//                ////
//                ////                        let myCount = (photoData!.count - 1)
//                ////
//                ////                        for index in 0...myCount {
//                ////                            let downloader:ImageDownloader = ImageDownloader(dict: photoData![index])
//                ////                            gDownloaders.add(downloader)
//                ////                        }
//                //
//                //                        DispatchQueue.main.async(execute: {
//                //                            self.collectionView.reloadData();
//                //                        })
//                //                    } catch _ {
//                //
//                //                    }
//                //
//                //                } else {
//                //                    let controller = UIAlertController(title: "Service Not Found", message: "Code: \(httpRes.statusCode)\n Check your URL value.", preferredStyle: .alert)
//                //                    let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//                //                    controller.addAction(myAlertAction)
//                //                    self.present(controller, animated:true, completion:nil)
//                //                    return;
//                //                }
////            } else {
////                let controller = UIAlertController(title: "No Wi-Fi", message: "Wi-Fi needs to be restored before continuing.", preferredStyle: .alert)
////                let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
////                controller.addAction(myAlertAction)
////                self.present(controller, animated:true, completion:nil)
////                return;
////            }
//            } as! (Data?, URLResponse?, Error?) -> Void)
        
        task.resume()
        
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func doSomething() {
        guard let requestTokenURL = getRequestTokenURL() else {
            return
        }
        
        // (2)...counterpart to (1) func() "complReturn"
        fetchResponseForRequest(requestTokenURL, completion: {(statusCode:Int?, response:String?, error:NSError?) in
            if let myError = error {
                print(error)
            } else {
                if let myStatusCode = statusCode {
                    if myStatusCode != 200 {
                        let controller = UIAlertController(title: "Unable to Generate Request Token", message: "Code: \(myStatusCode)\n Check your URL value.", preferredStyle: .alert)
                        let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        controller.addAction(myAlertAction)
                        self.present(controller, animated:true, completion:nil)
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
    
    
    @IBAction func doSomethingAction(_ sender: UIButton) {
        
        let myFlickr = FlickrKit(apiKey: "Turkey", sharedSecret: "Turkey is great with Cranberry Sauce")
        let me = FKPermission.fkPermissionRead
        let url = myFlickr.userAuthorizationURLWithRequestToken("http://www.apple.com",requestedPermission: me)
        
        print("Hello from ViewController:\(url)")
    }
    
    @IBAction func exitAction(_ sender: AnyObject) {
        exit(0)
    }
    
}

// =======================================================================================================================
// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gDownloaders.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for:indexPath)
        let photoImageView = cell.viewWithTag!(1) as! UIImageView
        
        let selectedItemIndex = indexPath.item as Int
        let currentImageDownloader:ImageDownloader = gDownloaders[selectedItemIndex] as! ImageDownloader
        
        if let image:UIImage = currentImageDownloader.image {
            photoImageView.image = image
        } else {
            var myDict = currentImageDownloader.dict!
            let urlString:String = myDict["url_sq"]! as! String
            let url = URL(string:urlString)
            
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems as [IndexPath]?
            gSelectedItemIndex = selectedIndexPaths![0].item
            gCurrentImageDownloader = gDownloaders.object(at: gSelectedItemIndex) as? ImageDownloader
        }
    }
}








