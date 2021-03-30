//
//  Tweet.swift
//  TwitterDemo
//
//  Created by mac on 11/30/20.
//

import Foundation
import FirebaseDatabase

struct Tweet {
    var content: String?
    var author: String?
    var date : String?
    var hastag: String?
    var dict: [String : String]{
        return[
            "tweet" : content!,
            "author" : author!,
            "date" : date!,
            "hashtag" : hastag!
            
        ]
    }
    init(_ content: String,_ author: String,_ date: String,_ hastag: String) {
        self.author = author
        self.content = content
        self.date = date
        self.hastag = hastag
        
    }
    init(snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: String]{
            content = value["tweet"]
            author = value["author"]
            date = value["date"]
            hastag = value["hashtag"]
        }
    }
}
