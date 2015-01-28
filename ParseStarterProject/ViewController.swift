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
    
    
    /**
     * ビューのロードイベント.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tweets = []
        fetchTweets(filterText.text)
        
    }
    
    /**
     * フィルタ入力値変更イベント.
     */
    @IBAction func onEdigintChanged(sender: AnyObject) {
        fetchTweets(filterText.text) // つぶやき一覧を再取得
    }
    
    
    /**
     * つぶやくボタンの押下イベント.
     */
    @IBAction func onClickTweet(sender: AnyObject) {
        TweetService.tweet(self.tweetText.text,
            { (Bool, NSError) -> Void in               // 保存完了時の動作
                self.tweetText.text = nil              // つぶやいた言葉をクリアする
                self.fetchTweets(self.filterText.text) // つぶやき一覧を取得
            }
        )
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
        let body = tweetObject.objectForKey(Tweet.Body.rawValue) as String
        cell.textLabel?.text = body
        return cell
    }
    
    
    /**
     * つぶやきを取得する.
     */
    func fetchTweets(query: String) {
        TweetService.fetchTweets(query,
            { (objects:[AnyObject]!, error:NSError!) -> Void in
                self.tweets = objects       // つぶやきを取得したつぶやきに更新
                self.tableView.reloadData() // テーブルビューをリロード
            }
        )
    }
    
}
