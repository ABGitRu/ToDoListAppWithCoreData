//
//  Contact+CoreDataProperties.swift
//  ToDoListAppWithCoreData
//
//  Created by Mac on 07.05.2021.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?

}

extension Contact : Identifiable {

}
