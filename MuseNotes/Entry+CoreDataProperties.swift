//
//  Entry+CoreDataProperties.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 11/30/22.
//
//

import Foundation
import CoreData
import UIKit

extension Entry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var date: Date
    @NSManaged public var trackName: String
    @NSManaged public var artistName: String
    @NSManaged public var albumImg: String
}

extension Entry : Identifiable {

}
