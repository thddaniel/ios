//
//  PreviewViewController.swift
//  Memory
//
//  Created by tanghao on 14/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import UIKit
import Parse


class PreviewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageFile: PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
            if error == nil
            {
                if let imageData = imageData
                {
                    let image = UIImage(data:imageData)
                    self.imageView.image = image
                }
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.imageView
    }

}
