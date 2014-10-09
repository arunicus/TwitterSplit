//
//  TwitterTableViewController.swift
//  TwitterSplitViewApp
//
//  Created by Arun Venkatesh on 10/7/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import UIKit

class TwitterTableViewController: UITableViewController, TwitterResponseParserDelegate {

    var xmlParser : TwitterResponseParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "http://feeds.feedburner.com/appcoda")
        xmlParser = TwitterResponseParser()
        xmlParser.delegate = self
        xmlParser.twitterLogin()
    }
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.parsedTweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell
        
        let currentDictionary = xmlParser.parsedTweets[indexPath.row] as Dictionary<String, String>
        
        cell.textLabel?.text = currentDictionary["userName"]
        cell.detailTextLabel?.text = currentDictionary["tweetText"]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let dictionary = xmlParser.parsedTweets[indexPath.row] as Dictionary<String, String>
//        let tutorialLink = dictionary["link"]
//        
//        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idDetailViewController") as DetailsViewController
//        
//        detailsViewController.tutorialURL = NSURL(string: tutorialLink!)
//        
//        showDetailViewController(detailsViewController, sender: self)
        
    }

}
