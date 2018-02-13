//
//  MessageCellTableViewCell.swift
//  Push Chat
//
//  Created by SpaGettys on 2018/02/12.
//  Copyright © 2018 spagettys. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func configure(with message: Message) {
        usernameLabel.text = message.sender
        bodyLabel.text = message.body
    }

}
