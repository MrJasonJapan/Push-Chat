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
       
        PersistenceService.shared.getMessages { (messages) in
            self.messages = messages
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.current.isSignedIn() {
            AlertService.signIn(in: self) {
                print("SIGNED IN")
            }
        }
    }
    
    
    @IBAction func onComposeTapped() {
        AlertService.composeAlert(in: self) { (message) in
            print(message)
            self.insert(message)
        }
    }
    
    func insert(_ message: Message) {
        messages.append(message)
        
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        PersistenceService.shared.save(messages)
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

