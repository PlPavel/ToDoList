//
//  Tasks+CoreDataProperties.swift
//  ToDoList
//
//  Created by Pavel Plyago on 18.06.2024.
//
//

import Foundation
import CoreData

@objc(Tasks)
public class Tasks: NSManagedObject {}

extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var title: String?
    @NSManaged public var info: String?

}

extension Tasks : Identifiable {}
