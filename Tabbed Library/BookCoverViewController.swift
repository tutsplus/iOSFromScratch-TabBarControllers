//
//  BookCoverViewController.swift
//  Library
//
//  Created by Bart Jacobs on 07/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class BookCoverViewController: UIViewController {

    @IBOutlet var bookCoverView: UIImageView!
    
    var book: [String: String]?
    
    lazy var bookCoverImage: UIImage? = {
        var image: UIImage?
        
        if self.book == nil {
            // Initialize Buffer
            var buffer = [AnyObject]()
            
            let filePath = NSBundle.mainBundle().pathForResource("Books", ofType: "plist")
            
            if let path = filePath {
                let authors = NSArray(contentsOfFile: path) as! [AnyObject]
                
                for author in authors {
                    if let books = author["Books"] as? [AnyObject] {
                        buffer += books
                    }
                }
            }
            
            if buffer.count > 0 {
                let random = Int(arc4random()) % buffer.count
                
                if let book = buffer[random] as? [String: String] {
                    self.book = book
                }
            }
        }
        
        if let book = self.book, let fileName = book["Cover"] {
            image = UIImage(named: fileName)
        }
        
        return image
    }()
    
    // MARK: -
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Cover", image: UIImage(named: "icon-cover"), tag: 2)
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bookCoverImage = bookCoverImage {
            bookCoverView.image = bookCoverImage
            bookCoverView.contentMode = .ScaleAspectFit
        }
    }

}
