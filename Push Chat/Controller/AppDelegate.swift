//
//  AppDelegate.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
        // ask the user to allow us to use push notifications.
        UNService.shared.authorize()
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("did register for notifications")
    }


}

