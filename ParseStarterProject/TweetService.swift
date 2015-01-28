//
//  TweetService.swift
//  ParseStarterProject
//
//  Created by kosuke on 1/28/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

/**
 * つぶやきサービス
 */
import Parse

struct TweetService {
    
    /**
     * Tweetクラスのカラム定義
     */
    enum TweetColumns: String {
        case Body = "body"
    }
    
    /**
     * つぶやく.
     */
    static func tweet(tweetBody: String, block: PFBooleanResultBlock) {
        var tweetObject = PFObject(className: "Tweet")                       // Tweetオブジェクトクラス
        tweetObject.setObject(tweetBody, forKey: TweetColumns.Body.rawValue) // "body"につぶやき内容を設定
        tweetObject.saveInBackgroundWithBlock(block)                         // 保存(後にブロックを実行)
    }
    
    /**
     * つぶやきを取得する.
     */
    static func fetchTweets(query: String, block: PFArrayResultBlock) {
        let tweetQuery = PFQuery(className: "Tweet")                           // Tweetクエリクラス
        tweetQuery.whereKey(TweetColumns.Body.rawValue, containsString: query) // where: 本文に{query}を含む
        tweetQuery.orderByDescending("createdAt")                              // order by: 作成日の降順
        tweetQuery.findObjectsInBackgroundWithBlock(block)                     // 検索(後にブロックを実行)
    }
    
}
