//
//  customCell.swift
//  ContactTest
//
//  Created by Raja on 12/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
    }

}
