//  DetailViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var mainViewController:MainViewController?
    var downloadItem:ImageDownloadItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = downloadItem?.photoInfo?.title {
            self.title = title
        } else {
            self.title = "No Title"
        }
        
        self.imageView.isHidden = false
        displayBigImage()
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func displayBigImage() {
        if let bigImage = downloadItem?.bigImage {
            self.imageView.image = bigImage;
        } else {
            let url = URL(string: (downloadItem?.photoInfo?.url_m)!)
            mainViewController?.downloadImageAtURL(url!, completion: {(bigImage, error) in
                if let myError = error {
                    print(myError)
                } else {
                    DispatchQueue.main.async(execute: {
                        self.downloadItem?.bigImage = bigImage
                        self.imageView.image = bigImage;
                    })
                }
            })
        }
    }
}


