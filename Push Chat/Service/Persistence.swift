//
//  Persistence.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/13.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation

class PersistenceService {
    
    private init() {}
    // set our singleton
    static let shared = PersistenceService()
    
    let userDefaults = UserDefaults.standard
    
    func save(_ messages: [Message]) {
        var dictArray = [[String: String]]()
        
        for message in messages {
            dictArray.append(message.dictionaryRepresentation())
        }
        
        userDefaults.setValue(dictArray, forKey: "messages")
    }
    
    func getMessages(completion: @escaping ([Message]) -> Void) {
        guard let dictArray = userDefaults.array(forKey: "messages") as? [[String : String]] else { return }
        
        var messages = [Message]()
        for dict in dictArray {
            guard let message = Message(dict: dict) else { continue }
            messages.append(message)
        }
        
        DispatchQueue.main.async {
            completion(messages)
        }
    }
    
}
