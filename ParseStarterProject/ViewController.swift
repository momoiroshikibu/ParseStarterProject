//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tweetText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterText: UITextField!
    
    // つぶやき
    var tweets: Array<AnyObject>!
    
    // Tweetクラスのカラム定義
    enum Tweet: String {
      case Body = "body"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tweets = []
        fetchTweets(filterText.text)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * フィルタ入力値変更イベント.
     */
    @IBAction func onEdigintChanged(sender: AnyObject) {
        fetchTweets(filterText.text)
    }
    
    /**
     * つぶやく.
     */
    @IBAction func tweet(sender: AnyObject) {
        
        var tweetObject = PFObject(className: "Tweet")
        tweetObject.setObject(tweetText.text, forKey: Tweet.Body.rawValue)
        // save
        tweetObject.saveInBackgroundWithBlock { (Bool, NSError) -> Void in
            self.tweetText.text = nil
            self.fetchTweets(self.filterText.text)
        }
    }
    
    
    /**
     * セルの行数を取得する.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    /**
     * セルの内容を変更する.
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        let tweetObject: PFObject = tweets[indexPath.row] as PFObject
        let body = tweetObject.objectForKey(Tweet.Body.rawValue) as? String
        cell.textLabel?.text = body
        return cell
    }
    
    
    /**
     * つぶやきを取得する.
     */
    func fetchTweets(query: String) {
        let tweetQuery = PFQuery(className: "Tweet")
        tweetQuery.whereKey(Tweet.Body.rawValue, containsString: query)
        tweetQuery.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            self.tweets = objects
            self.tableView.reloadData()
        }
    }
    
}
