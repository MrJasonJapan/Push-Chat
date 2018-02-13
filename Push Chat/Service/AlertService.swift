//
//  AlertService.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func signIn(in vc: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Sign In", message: nil, preferredStyle: .alert)
        alert.addTextField { (usernameTF) in
            usernameTF.placeholder = "Enter your username"
        }
        let signIn = UIAlertAction(title: "Sign In", style: .default) { (_) in
            guard let username = alert.textFields?.first?.text else { return }
            User.current.username = username
            completion()
        }
        alert.addAction(signIn)
        vc.present(alert, animated: true)
    }
    
    static func composeAlert(in vc: UIViewController, completion: @escaping (Message) -> Void) {
        let alert = UIAlertController(title: "Compose Message", message: "What is on your mind?", preferredStyle: .alert)
        alert.addTextField { (messageBodyTF) in
            messageBodyTF.placeholder = "Enter Message"
        }
        let send = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let messageBody = alert.textFields?.first?.text else { return }
            let message = Message(body: messageBody)
            completion(message)
        }
        alert.addAction(send)
        vc.present(alert, animated: true)
    }
}
