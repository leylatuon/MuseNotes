//
//  EntryCell.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/5/22.
//

import UIKit

class EntryCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(for entry: Entry) {
        titleLabel.text = entry.title
        if (entry.body.isEmpty) {
            bodyLabel.text = "(No body)"
        } else {
            bodyLabel.text = entry.body
        }
    }
}
