//
//  CustomCell.swift
//  HowToBuildTableViewCellsCorrectly
//
//  Created by Eric Dockery on 6/1/18.
//  Copyright © 2018 Eric Dockery. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!

    static let reuseID = "\(CustomCell.self)"
    static let nibName = reuseID

    override var isUserInteractionEnabled: Bool {
        didSet {
            title.textColor = isUserInteractionEnabled ? .green : .blue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 3
    }

}
