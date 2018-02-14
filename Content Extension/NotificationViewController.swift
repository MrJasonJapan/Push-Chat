//
//  NotificationViewController.swift
//  Content Extension
//
//  Created by SpaGettys on 2018/02/14.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let message = Message(userInfo: userInfo) else { return }
        messages.append(message)
        tableView.reloadData()
    }

}

extension NotificationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}
