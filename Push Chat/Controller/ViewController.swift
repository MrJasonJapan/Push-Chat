//
//  ViewController.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //atempt to sign in
        User.current.signIn()
        
        //configure the SNS service (necessary for sending messages via SNS)
        SNSService.shared.configure()
       
        PersistenceService.shared.getMessages { (messages) in
            self.messages = messages
            self.tableView.reloadData()
        }
        
        //observe for 'internal' notifications.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewMessage(_:)),
                                               name: NSNotification.Name("internalNotification.newMessage"),
                                               object: nil)
        
        //observe for our reply 'internal' notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReply(_:)),
                                               name: NSNotification.Name("internalNotification.reply"),
                                               object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.current.isSignedIn() {
            AlertService.signIn(in: self) {
                print("SIGNED IN")
                //after loggin in, register for the SNS service (necessary for sending messages via SNS)
                SNSService.shared.register()
            }
        }
    }
    
    
    @IBAction func onComposeTapped() {
        AlertService.composeAlert(in: self) { (message) in
            print(message)
            self.insert(message)
            
            // publish our message to AWS and send to all devices subscribed to the topic.
            SNSService.shared.publish(message)
        }
    }
    
    //Insert message to our model (messages) and tableView, then persist the entire model (messages).
    func insert(_ message: Message) {
        messages.append(message)
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        PersistenceService.shared.save(messages)
    }
    
    @objc
    func handleNewMessage(_ sender: Notification) {
        guard let message = sender.object as? Message else { return }
        insert(message)
    }
    
    @objc
    func handleReply(_ sender: Notification) {
        guard let reply = sender.object as? String else { return }
        let message = Message(body: reply)
        insert(message)
        
        // publish our message to AWS and send to all devices subscribed to the topic.
        SNSService.shared.publish(message)
    }
}

extension ViewController: UITableViewDataSource {
    
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

