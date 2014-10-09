//
//  TwitterResponseParser.swift
//  TwitterSplitViewApp
//
//  Created by Arun Venkatesh on 10/7/14.
//  Copyright (c) 2014 Arun Venkatesh. All rights reserved.
//

import UIKit
import Social
import Accounts
@objc protocol TwitterResponseParserDelegate{
    func parsingWasFinished() -> Void
}

class TwitterResponseParser: NSObject {
    
    var accountStore: ACAccountStore
    var parsedTweets : Array <AnyObject> = Array<AnyObject>()
    var delegate : TwitterResponseParserDelegate?
    var arrayOfAccount: NSArray
    
    override init() {
        arrayOfAccount = []
        accountStore = ACAccountStore()
    }
    func twitterLogin(){
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil,
            completion: { (granted, error) in
                if (granted) {
                    // invoke twitter API
                    self.arrayOfAccount = self.accountStore.accountsWithAccountType(accountType)
                    
                    if (self.arrayOfAccount.count > 0) {
                        let twitterAccount = self.arrayOfAccount.lastObject as ACAccount
                        
                        let twitterParams = [
                            "count" : "100"
                        ]
                        let twitterAPIURL = NSURL.URLWithString(
                            "https://api.twitter.com/1.1/statuses/home_timeline.json")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                            requestMethod:SLRequestMethod.GET,
                            URL:twitterAPIURL,
                            parameters:twitterParams)
                        request.account = self.arrayOfAccount[0] as ACAccount
                        request.performRequestWithHandler ( {
                            (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
                            println(error)
                            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                        })
                    }
                    
                    
                } else {
                    // do something
                    println("NOT PERMITTED")
                }
            }
        )
    }
    
    func searchIntwitter(query: String)
    {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil,
            completion: { (granted, error) in
                if (granted) {
                    // invoke twitter API
                    self.arrayOfAccount = self.accountStore.accountsWithAccountType(accountType)
                    
                    if (self.arrayOfAccount.count > 0) {
                        let twitterAccount = self.arrayOfAccount.lastObject as ACAccount
                        
                        let twitterParams = [
                            "count" : "100",
                            "q":"#"+query
                        ]
                        let twitterAPIURL = NSURL.URLWithString(
                            "https://api.twitter.com/1.1/search/tweets.json")
                        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                            requestMethod:SLRequestMethod.GET,
                            URL:twitterAPIURL,
                            parameters:twitterParams)
                        request.account = self.arrayOfAccount[0] as ACAccount
                        request.performRequestWithHandler ( {
                            (NSData data, NSHTTPURLResponse urlResponse, NSError error) -> Void in
                            println(error)
                            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                        })
                    }
                    
                    
                } else {
                    // do something
                    println("NOT PERMITTED")
                }
            }
        )
    }
    
    
    func handleTwitterData (data: NSData!,
        urlResponse: NSHTTPURLResponse!,
        error: NSError!) {
            if let dataValue = data {
                let jsonString = NSString (data: data, encoding:NSUTF8StringEncoding)
                var parseError : NSError? = nil
                var jsonObject : AnyObject? =
                NSJSONSerialization.JSONObjectWithData(dataValue,
                    options: NSJSONReadingOptions(0),
                    error: &parseError)
                if parseError != nil {
                    return
                }
                println(jsonObject?["statuses"])
                if(jsonObject?["statuses"] != nil){
                    jsonObject = jsonObject?["statuses"]
                }
                if let jsonArray = jsonObject as? Array<Dictionary<String, AnyObject>> {
                    self.parsedTweets.removeAll(keepCapacity: true)
                    for tweetDict in jsonArray {
                        var inputDict:Dictionary = [String : String]()
                        inputDict.updateValue(tweetDict["text"]  as NSString, forKey: "tweetText")
                        inputDict.updateValue(tweetDict["created_at"]  as NSString, forKey: "createdAt")
                        let userDict = tweetDict["user"] as NSDictionary
                        inputDict.updateValue(userDict["name"] as NSString, forKey: "userName")
                        inputDict.updateValue(userDict ["profile_image_url"] as NSString, forKey: "userAvatarURL")

                        self.parsedTweets.append(inputDict)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.parsingWasFinished()
                        ()
                    }
                }
            } else {
                println ("handleTwitterData received no data")
            }
    }
}
