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
    var downloadItems:[ImageDownloadItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sender = mainViewController else {
            return
        }
        self.downloadItems = sender.downloadItems
        if let title = downloadItems?[sender.itemID].photoInfo?.title {
            self.title = title
        } else {
            self.title = "No Title"
        }
        
        self.imageView.isHidden = false
        displayBigImage(sender: sender)
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func displayBigImage(sender: MainViewController) {
        
        if let bigImage = downloadItems![sender.itemID].bigImage {
            self.imageView.image = bigImage;
        } else {
            let url = URL(string: (sender.downloadItems[sender.itemID].photoInfo?.url_m)!)
            mainViewController?.downloadImageAtURL(url!, completion: {(bigImage, error) in
                if let myError = error {
                    print(myError)
                } else {
                    DispatchQueue.main.async(execute: {
                        sender.downloadItems[sender.itemID].bigImage = bigImage
                        self.imageView.image = bigImage;
                    })
                }
            })
        }
    }
}


