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
    @IBOutlet var albumImg: UIImageView!
    @IBOutlet var dateLabel: UILabel!
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: entry.date)
//        dateLabel.text = entry.date
        if (entry.body.isEmpty) {
            bodyLabel.text = "(No body)"
        } else {
            bodyLabel.text = entry.body
        }
        if let url = URL(string: entry.albumImg) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let imageData = data else { return }
            
          DispatchQueue.main.async {
              self.albumImg.image = UIImage(data: imageData)
          }
        }.resume()
      }    }
}
