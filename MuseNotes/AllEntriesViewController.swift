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
    lazy var fetchedResultsController:
    NSFetchedResultsController<Entry> = {
        let fetchRequest = NSFetchRequest<Entry>()
        let entity = Entry.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(
            key: "date",
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Entries")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func addEntryTableViewControllerDidCancel(_ controller: AddEntryTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEntryTableViewController(_ controller: AddEntryTableViewController, didFinishAdding entry: Entry) {
        navigationController?.popViewController(animated: true)
    }
    func addEntryTableViewController(_ controller: AddEntryTableViewController, didFinishEditing entry: Entry) {
//        if let index = items.firstIndex(of: entry) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//              configureText(for: cell, with: entry)
//            }
//        }
        navigationController?.popViewController(animated: true)
    }
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EntryItem",
            for: indexPath) as! EntryCell
        let entry = fetchedResultsController.object(at: indexPath)
        cell.configure(for: entry)
        return cell
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ){
        if segue.identifier == "AddEntry" {
            let controller = segue.destination as! AddEntryTableViewController
            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
        }
        else if segue.identifier == "EditEntry" {
            let controller = segue.destination as! AddEntryTableViewController
            controller.delegate = self
            controller.managedObjectContext = managedObjectContext
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                let entry = fetchedResultsController.object(at: indexPath)
                controller.entryToEdit = entry
                controller.gotTrack = trackInfo(trackName: entry.trackName, trackArtist: entry.artistName, trackImg: entry.albumImg)
            }
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ){
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(
                at: indexPath)
            managedObjectContext.delete(entry)
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    func updateItem(item: Entry, newName: String){
        item.title = newName
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalCoreDataError(error)
        }
    }
    deinit {
        fetchedResultsController.delegate = nil
    }
}
// MARK: - NSFetchedResultsController Delegate Extension
extension AllEntriesViewController:
    NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(
        _ controller:
        NSFetchedResultsController<NSFetchRequestResult> ){
            print("*** controllerWillChangeContent")
            tableView.beginUpdates()
        }
    func controller(
        _ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ){
        switch type { case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(
                at: indexPath!) as? EntryCell {
                let entry = controller.object(
                    at: indexPath!) as! Entry
                cell.configure(for: entry)
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        @unknown default:
            print("*** NSFetchedResults unknown type")
        }
    }
    func controller(
        _ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ){
        switch type { case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(
                IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(
                IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        @unknown default:
            print("*** NSFetchedResults unknown type")
        }
    }
    func controllerDidChangeContent(
        _ controller:
        NSFetchedResultsController<NSFetchRequestResult> ){
            print("*** controllerDidChangeContent")
            tableView.endUpdates()
        }
}
