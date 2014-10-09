//
//  DetailsViewController.swift
//  TwitterSplitViewApp
//
//  Created by Arun Venkatesh on 10/7/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController,UITableViewDelegate , UITableViewDataSource ,TwitterResponseParserDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pubDateButton: UIBarButtonItem!
    var xmlParser : TwitterResponseParser = TwitterResponseParser()


    
    var tutorialURL : NSURL!
    var tutorialsButtonItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tutorialsButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: "showDetailsViewController")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleFirstViewControllerDisplayModeChangeWithNotification:"), name: "PrimaryVCDisplayModeChangeNotification", object: nil)
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleFirstViewControllerDisplayModeChangeWithNotification(notification: NSNotification){
        let displayModeObject = notification.object as? NSNumber
        let nextDisplayMode = displayModeObject?.integerValue
        
        if toolBar.items?.count == 3{
            toolBar.items?.removeAtIndex(0)
        }
        
        if nextDisplayMode == UISplitViewControllerDisplayMode.PrimaryHidden.toRaw() {
            toolBar.items?.insert(tutorialsButtonItem, atIndex: 0)
        }
        else{
            toolBar.items?.insert(splitViewController!.displayModeButtonItem(), atIndex: 0)
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        if previousTraitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact{
            let firstItem = toolBar.items?[0] as? UIBarButtonItem
            if firstItem?.title == "Home"{
                toolBar.items?.removeAtIndex(0)
            }
        }
        else if previousTraitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular{
            if toolBar.items?.count == 3{
                toolBar.items?.removeAtIndex(0)
            }
            
            if splitViewController?.displayMode == UISplitViewControllerDisplayMode.PrimaryHidden {
                toolBar.items?.insert(tutorialsButtonItem, atIndex: 0)
            }
            else{
                toolBar.items?.insert(self.splitViewController!.displayModeButtonItem(), atIndex: 0)
            }
        }
    }
    
    func showDetailsViewController(){
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if toolBar.items?.count == 3{
            toolBar.items?.removeAtIndex(0)
        }
        
        if splitViewController?.displayMode == UISplitViewControllerDisplayMode.PrimaryHidden {
            toolBar.items?.insert(tutorialsButtonItem, atIndex: 0)
        }
        else{
            toolBar.items?.insert(self.splitViewController!.displayModeButtonItem(), atIndex: 0)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        xmlParser.delegate = self
        
    }
    
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBAction func searchTwitterEntered(sender: AnyObject) {
        if(!searchText.text.isEmpty)
        {
            xmlParser.searchIntwitter(searchText.text)
        }
    }
    
    @IBAction func searchEntered(sender: AnyObject) {
        if(!searchText.text.isEmpty)
        {
            xmlParser.searchIntwitter(searchText.text)
        }
    }
    
    @IBAction func showPublishDate(sender: AnyObject) {
        if(!searchText.text.isEmpty)
        {
            xmlParser.searchIntwitter(searchText.text)
        }
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.parsedTweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchTwitCell", forIndexPath: indexPath) as UITableViewCell
        
        let currentDictionary = xmlParser.parsedTweets[indexPath.row] as Dictionary<String, String>
        
        cell.textLabel?.text = currentDictionary["userName"]
        cell.detailTextLabel?.text = currentDictionary["tweetText"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

   
}
