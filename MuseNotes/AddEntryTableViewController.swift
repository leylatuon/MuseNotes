//
//  AddEntryTableViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 11/30/22.
//

import UIKit
import CoreData
protocol AddEntryViewControllerDelegate: AnyObject {
    func addEntryTableViewControllerDidCancel(
        _ controller: AddEntryTableViewController)
    func addEntryTableViewController(
        _ controller: AddEntryTableViewController,
        didFinishAdding entry: Entry
    )
    func addEntryTableViewController(
        _ controller: AddEntryTableViewController,
        didFinishEditing entry: Entry
    )
}

class AddEntryTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, SearchViewControllerDelegate {
    @IBOutlet weak var searchTrack: UITableViewCell!
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryBody: UITextView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var managedObjectContext: NSManagedObjectContext!
    var entryToEdit: Entry?
    var gotTrack = trackInfo()
    @IBAction func cancel() {
        delegate?.addEntryTableViewControllerDidCancel(self)    }
    @IBAction func done() {
        guard let mainView = navigationController?.self.view
        else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        let delayInSeconds = 0.6
        
        if let entry = entryToEdit {
            entry.title = entryTitle.text!
            entry.body = entryBody.text!
            entry.trackName = gotTrack.trackName
            entry.artistName = gotTrack.trackArtist
            entry.albumImg = gotTrack.trackImg
            hudView.text = "Edited Entry"
            hudView.imgName = "EditFile"
            do {
                try managedObjectContext.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds)
                {
                    hudView.hide()
                    self.delegate?.addEntryTableViewController(self, didFinishEditing: entry)
                }
            } catch {
                fatalCoreDataError(error)
            }
        } else {
            let newItem = Entry(context: managedObjectContext)
            newItem.title = entryTitle.text!
            newItem.body = entryBody.text!
            newItem.date = Date()
            newItem.trackName = gotTrack.trackName
            newItem.artistName = gotTrack.trackArtist
            newItem.albumImg = gotTrack.trackImg
            hudView.text = "Added Entry"
            hudView.imgName = "AddFile"
            do {
                try managedObjectContext.save()
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds)
                {
                    hudView.hide()
                    self.delegate?.addEntryTableViewController(self, didFinishAdding: newItem)
                }
            }
            catch {
                fatalCoreDataError(error)
            }
        }
        
    }

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if ((entryBody == textView) && (entryBody.textColor == UIColor.lightGray)) {
//            entryBody.text = nil
//            entryBody.textColor = UIColor.black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if ((entryBody == textView) && entryBody.text.isEmpty) {
//            entryBody.text = "Placeholder"
//            entryBody.textColor = UIColor.lightGray
//        }
//    }
    weak var delegate: AddEntryViewControllerDelegate?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        entryBody.text = "Placeholder"
//        entryBody.textColor = UIColor.lightGray
        if let item = entryToEdit {
            title = "Edit Entry"
            entryTitle.text = item.title
            entryBody.text = item.body
            if (item.trackName != "" && item.artistName != ""){
                trackTitle.text = "\(item.trackName) by \(item.artistName)"
            }
            doneButton.isEnabled = true
        }
    }
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "SearchTrack" {
            let controller = segue.destination as! SearchTableViewController
            controller.delegate = self
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SearchTrack", sender: self)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        if (textField == entryTitle) {
            let oldText = textField.text!
            let stringRange = Range(range, in: oldText)!
            let newText = oldText.replacingCharacters(in: stringRange, with: string)
            doneButton.isEnabled = !newText.isEmpty
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    func searchTableViewControllerDidCancel(_ controller: SearchTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func searchTableViewController(_ controller: SearchTableViewController, didFinishAdding track: trackInfo) {
        navigationController?.popViewController(animated: true)
        gotTrack = track
        if (track.trackName != "" && track.trackArtist != ""){
            trackTitle.text = "\(track.trackName) by \(track.trackArtist)"
        }
    }
    
}
