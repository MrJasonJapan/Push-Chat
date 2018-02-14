//
//  Message.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation

struct Message {
    // prevent any changing of sender outside of the class -> privage(set) var
    private(set) var sender: String = User.current.username
    let body: String
    
    init(body: String) {
        self.body = body
    }
    
    init?(dict: [String : String]) {
        guard let sender = dict["sender"],
            let body = dict["body"]
            else {return nil}
        
        self.sender = sender
        self.body = body
    }
    
    init?(userInfo: [AnyHashable : Any]) {
        // is userInfo available inside the notification's message.
        guard let aps = userInfo["aps"] as? [String : Any],
            let alert = aps["alert"] as? [String : Any],
            let sender = alert["title"] as? String,
            let body = alert["body"] as? String
            else { return nil }
        
        // take what we need from userInfo and initialize a standard message
        self.sender = sender
        self.body = body
    }
    
    func dictionaryRepresentation() -> [String : String] {
        let dict: [String : String] = ["sender" : sender, "body" : body]
        
        return dict
    }
}
