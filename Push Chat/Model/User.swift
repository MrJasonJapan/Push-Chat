//
//  User.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import Foundation

class User {
    
    var username = "" {
        // when it changes (is Set) automatically put the username as a key inside of our UserDefaults
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    private init() {}
    static let current = User()
    
    func signIn() {
        let userDefaults = UserDefaults.standard
        guard let username = userDefaults.string(forKey: "username") else { return }
        
        self.username = username
    }
    
    func isSignedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "username") != nil
    }
}
