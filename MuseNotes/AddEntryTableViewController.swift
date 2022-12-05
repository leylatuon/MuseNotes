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
}

class AddEntryTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entryBody: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var managedObjectContext: NSManagedObjectContext!
    @IBAction func cancel() {
        delegate?.addEntryTableViewControllerDidCancel(self)    }
    @IBAction func done() {
        let newItem = Entry(context: managedObjectContext)
        newItem.title = entryTitle.text!
        newItem.body = entryBody.text!
        newItem.date = Date()
        do {
            try managedObjectContext.save()
            delegate?.addEntryTableViewController(self, didFinishAdding: newItem)
        }
        catch {
            // error
        }
    }
    weak var delegate: AddEntryViewControllerDelegate?
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      entryTitle.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(
        in: stringRange,
        with: string)
        doneButton.isEnabled = !newText.isEmpty
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
}
