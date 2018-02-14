//
//  UNService.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/13.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            
            print(error ?? "no un authorization error")
            
            guard granted else { return }
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func configure() {
        unCenter.delegate = self
        
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
        
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {
        // this section basically lets us make it so when pressing on a notification we have the ability to direcly reply and send a message back.
        let replyAction = UNTextInputNotificationAction(identifier: NotificaitonActionID.reply.rawValue,
                                                        title: "Reply",
                                                        options: .authenticationRequired,
                                                        textInputButtonTitle: "Send",
                                                        textInputPlaceholder: "Enter Message")
        
        let category = UNNotificationCategory(identifier: NotificationCategoryID.reply.rawValue,
                                              actions: [replyAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        unCenter.setNotificationCategories([category])
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    
    // triggers when app is in backgaround, and user taps on the notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("un did receive")
        
        if let message = Message(userInfo: response.notification.request.content.userInfo) {
            print(message)
            post(message)
        }
        
        // check to see if the user try to reply using the .reply action.
        // note: .reply is our only action at this point.
        if NotificaitonActionID(rawValue: response.actionIdentifier) == .reply {
            self.postReply(from: response)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("un will present")
        
        // if the message is sent from ourself, don't present anything
        let userInfo = notification.request.content.userInfo
        if let message = Message(userInfo: userInfo), message.sender != User.current.username {
            print(message)
            post(message)
        }
        
        completionHandler([])
    }
    
    //'Post' a message using our internal notification system, so we can handle it later and insert in into our tableView.
    func post(_ message: Message) {
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.newMessage"), object: message)
    }
    
    //from our reply action, also 'Post' a message using an internal notification (same as the post method above)
    func postReply(from response: UNNotificationResponse) {
        guard let textResponse = response as? UNTextInputNotificationResponse else { return }
        let reply = textResponse.userText
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.reply"), object: reply)
    }
}
