//  DetailViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentImageDownloader = gCurrentImageDownloader {
            self.title = (currentImageDownloader.dict!["title"] as String)
        } else {
            self.title = "No Title"
        }
        self.imageView.hidden = false
        displayBigImage()
    }
    
    // -----------------------------------------------------------------------------------------------------------------------
    
    override func willMoveToParentViewController(parent: UIViewController?) {
    
        if let myParent = parent {
            if let myBigImage  = self.imageView?.image {
                gCurrentImageDownloader?.bigImage = myBigImage
            }
        } else {
            // Returning to MainViewController
            imageView.hidden = true
        }
    }

    
    // -----------------------------------------------------------------------------------------------------
    
    func displayBigImage() {
        if let image = gCurrentImageDownloader!.bigImage {
            self.imageView.image = image;
        } else {
            var urlString:String?
            if let currentImageDownloader = gCurrentImageDownloader {
                let url = NSURL(string: (currentImageDownloader.dict!["url_m"] as String))
                currentImageDownloader.downloadImageAtURL(url!, completion: {(image, error) in
                    if let myError = error {
                        println(myError)
                    } else {
                        self.imageView.image = image;
                    }
                })
            }
        }
    }
}


