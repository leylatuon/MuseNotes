//
//  SearchViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/8/22.
//

import UIKit
import CoreData

struct trackInfo {
var trackName: String = ""
var trackArtist: String = ""
var trackImg: String = ""
}

protocol SearchViewControllerDelegate: AnyObject {
    func searchTableViewControllerDidCancel(
        _ controller: SearchTableViewController)
    func searchTableViewController(
        _ controller: SearchTableViewController,
        didFinishAdding track: trackInfo
    )
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    private var results: [SearchResults] = []
    weak var delegate: SearchViewControllerDelegate?
    var entryTrack: Entry?
    var saveTrack = trackInfo()
    var managedObjectContext : NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
              !searchText.isEmpty else {
            return
        }
        APICaller.shared.search(with: searchText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let resultsResponse):
                    self.results = [resultsResponse]
                    self.update(with: self.results)
                case .failure(let error):
                    print (error.localizedDescription)
                }
            }
        }
    }
    
    func update(with results: [SearchResults]) {
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return results.first?.tracks.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchItem",
            for: indexPath) as! SearchCell
        guard let item = results.first?.tracks.items[indexPath.row] else {return cell}
        cell.configureTrack(for: item)
        cell.configureArtist(for: item)
        cell.configureImg(for: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! SearchCell
            saveTrack.trackName = currentCell.trackLabel.text!
            saveTrack.trackArtist = currentCell.artistLabel.text!
            saveTrack.trackImg = currentCell.imgUrl
            delegate?.searchTableViewController(self, didFinishAdding: saveTrack)
    }
}
