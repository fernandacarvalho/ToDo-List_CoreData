//
//  DAOItem.swift
//  Todo-List
//
//  Created by Fernanda Carvalho on 27/03/19.
//  Copyright © 2019 Fernanda Carvalho. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let data = DAOItem()

class DAOItem: NSObject {
    
    // App Delegate
    let delegate = (UIApplication.shared.delegate as! AppDelegate)
    
    weak var contextMain : NSManagedObjectContext!
    
    class var sharedInstance : DAOItem {
        return data
    }
    
    override init()
    {
        super.init()
        self.contextMain = self.delegate.persistentContainer.viewContext
    }
    
    func createItem(title: String, done: Bool) -> Item?{
        let newItem = Item(context: self.contextMain)
        newItem.title = title
        newItem.done = done
        
        self.saveItems()
        return newItem
    }
    
    func deleteItem(item: NSManagedObject){
        self.contextMain.delete(item)
        self.saveItems()
    }
    
    func updateItem(item: NSManagedObject){
        self.saveItems()
    }
    
    // MARK : FETCH REQUESTS
    
    func getItems() -> [Item]
    {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           return try self.contextMain.fetch(request)
        } catch {
            print("Error")
            return [Item]()
        }
    }
    
    func saveItems(){
        do {
            try self.contextMain.save()
        } catch {
            print("Error")
        }
    }
}
