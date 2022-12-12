//
//  SearchCell.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/8/22.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumImg: UIImageView!
    var imgUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureTrack(for item: Track){
        trackLabel.text = item.name
    }
    func configureArtist(for item: Track){
        artistLabel.text = item.artists.first?.name
    }
    func configureImg(for item: Track){
        imgUrl = item.album.images.first!.url
        if let url = URL(string: item.album.images.first!.url) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let imageData = data else { return }
            
          DispatchQueue.main.async {
              self.albumImg.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }
}
