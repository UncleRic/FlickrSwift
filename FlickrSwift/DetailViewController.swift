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
            self.title = (currentImageDownloader.dict!["title"] as! String)
        } else {
            self.title = "No Title"
        }
        self.imageView.isHidden = false
        displayBigImage()
    }
    
    // -----------------------------------------------------------------------------------------------------------------------
    
    override func willMove(toParentViewController parent: UIViewController?) {
    
        if let _ = parent {
            if let myBigImage  = self.imageView?.image {
                gCurrentImageDownloader?.bigImage = myBigImage
            }
        } else {
            // Returning to MainViewController
            imageView.isHidden = true
        }
    }

    
    // -----------------------------------------------------------------------------------------------------
    
    func displayBigImage() {
        if let image = gCurrentImageDownloader!.bigImage {
            self.imageView.image = image;
        } else {
            
            if let currentImageDownloader = gCurrentImageDownloader {
                let url = URL(string: (currentImageDownloader.dict!["url_m"] as! String))
              
                currentImageDownloader.downloadImageAtURL(url!, completion: {(image, error) in
                    if let myError = error {
                        print(myError)
                    } else {
                        self.imageView.image = image;
                    }
                })
            }
        }
    }
}


