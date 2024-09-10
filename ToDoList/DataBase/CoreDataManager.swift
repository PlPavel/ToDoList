//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Pavel Plyago on 19.06.2024.
//

import UIKit
import CoreData

//MARK: - CRUD

public final class CoreDataManager: NSObject {
    
    //реализация Синглтона
    
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func createTask(title: String, info: String){
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let task = Tasks(entity: taskEntityDescription, insertInto: context)
        task.title = title
        task.info = info
        
        appDelegate.saveContext()
        
    }
    
    public func fetchTasks() -> [Tasks] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            return (try? context.fetch(fetchRequest) as? [Tasks]) ?? []
        }
    }
    
    public func fetchTask(title: String, info: String) -> Tasks? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Tasks] else { return nil }
            return tasks.first(where: { $0.title == title && $0.info == info })
        }
    }
    
    public func updateTask(task: Tasks, newTitle: String, newInfo: String) {
            task.title = newTitle
            task.info = newInfo
        
        appDelegate.saveContext()
    }
    
    public func deleteTask(title: String, info: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            guard let tasks = try? context.fetch(fetchRequest) as? [Tasks],
                  let task = tasks.first(where: { $0.title == title && $0.info == info }) else { return }
            context.delete(task)
        }
        
        appDelegate.saveContext()
    }
    
}
