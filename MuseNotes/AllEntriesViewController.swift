//
//  AllEntriesViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 11/14/22.
//

import Foundation
import UIKit
import CoreData

class AllEntriesViewController: UITableViewController, AddEntryViewControllerDelegate {
    func addEntryTableViewControllerDidCancel(_ controller: AddEntryTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEntryTableViewController(_ controller: AddEntryTableViewController, didFinishAdding entry: Entry) {
        navigationController?.popViewController(animated: true)
        getAllItems()
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    var managedObjectContext: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
    }
    private var models = [Entry]()
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EntryItem",
            for: indexPath)
        let titleLabel = cell.viewWithTag(1000) as! UILabel
        titleLabel.text = model.title
        let bodyLabel = cell.viewWithTag(1001) as! UILabel
        bodyLabel.text = model.title
        return cell
    }
    
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "AddEntry" {
            // New code
            let controller = segue.destination as! AddEntryTableViewController
            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    func getAllItems() {
        do {
            models = try managedObjectContext.fetch(Entry.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // error
        }
    }
    override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath
    ){
        managedObjectContext.delete(models[indexPath.row])
        do {
            try managedObjectContext.save()
        }
        catch {
            // error
        }
      models.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func deleteItem(item: Entry) {
        
        
    }
    
    func updateItem(item: Entry, newName: String){
        item.title = newName
        do {
            try managedObjectContext.save()
        }
        catch {
            // error
        }
    }
}
