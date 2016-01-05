//
//  BooksViewController.swift
//  Library
//
//  Created by Bart Jacobs on 07/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {

    let CellIdentifier = "Cell Identifier"
    let SegueBookCoverViewController = "BookCoverViewController"
    
    var author: [String: AnyObject]?
    
    lazy var books: [AnyObject] = {
        // Initialize Books
        var buffer = [AnyObject]()
        
        if let author = self.author, let books = author["Books"] as? [AnyObject] {
            buffer += books
            
        } else {
            let filePath = NSBundle.mainBundle().pathForResource("Books", ofType: "plist")
            
            if let path = filePath {
                let authors = NSArray(contentsOfFile: path) as! [AnyObject]
                
                for author in authors {
                    if let books = author["Books"] as? [AnyObject] {
                        buffer += books
                    }
                }
            }
        }
        
        return buffer
    }()
    
    // MARK: -
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "icon-books"), tag: 1)
        
        // Configure Tab Bar Item
        tabBarItem.badgeValue = "8"
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let author = author, let name = author["Author"] as? String {
            title = name
        } else {
            title = "Books"
        }
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueBookCoverViewController {
            if let indexPath = tableView.indexPathForSelectedRow, let book = books[indexPath.row] as? [String: String]  {
                let destinationViewController = segue.destinationViewController as! BookCoverViewController
                destinationViewController.book = book
            }
        }
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue Resuable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        if let book = books[indexPath.row] as? [String: String], let title = book["Title"] {
            // Configure Cell
            cell.textLabel?.text = title
        }
        
        return cell;
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform Segue
        performSegueWithIdentifier(SegueBookCoverViewController, sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
