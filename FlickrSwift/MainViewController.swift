//  MainViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

var gSelectedItemIndex:Int = 0

class MainViewController: UIViewController {
    var photos:PhotoStuff?
    var downloadItems = [ImageDownloadItem]()
    var downloadItem:ImageDownloadItem?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlickrPhotoWithSearchString("Ric");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Flickr Viewer"
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - NSURLSesson
    
    
    func fetchFlickrPhotoWithSearchString(_ searchString:String) {
        guard let url = getURLForString("Ric") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if nil == error, let data = data {
                self.dessiminateData(photoItems: self.disseminateJSON(data: data)?.photo)
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            } else {
                let controller = UIAlertController(title: "No Wi-Fi", message: "Wi-Fi needs to be restored before continuing.", preferredStyle: .alert)
                let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                controller.addAction(myAlertAction)
                self.present(controller, animated:true, completion:nil)
                return;
            }
        }
        task.resume()
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func dessiminateData(photoItems: [PhotoInfo]? = nil) {
        guard let photoItems = photoItems else {
            return
        }
        photoItems.forEach { (photoInfo) in
            let imageDownloadItem = ImageDownloadItem(photoInfo: photoInfo)
            self.downloadItems.append(imageDownloadItem)
        }
        
        return
    }
    // -----------------------------------------------------------------------------------------------------
    
    func doSomething() {
        guard let requestTokenURL = getRequestTokenURL() else {
            return
        }
        
        // (2)...counterpart to (1) func() "complReturn"
        fetchResponseForRequest(requestTokenURL, completion: {(statusCode:Int?, _, error:NSError?) in
            if let error = error {
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
        return downloadItems.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for:indexPath)
        let photoImageView = cell.viewWithTag!(1) as! UIImageView
        downloadItem = downloadItems[indexPath.item]

        if let image = downloadItem?.image {
            photoImageView.image = image
        } else if let urlSQ = downloadItem?.photoInfo?.url_sq {
            let url = URL(string:urlSQ)
            self.downloadImageAtURL(url!, completion: {(image:UIImage?, error:NSError?) in
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
            let destinationViewController = segue.destination as? DetailViewController
            destinationViewController?.downloadItem = downloadItem
        }
    }
}








