//
//  ToDoList.swift
//  Todo-List
//
//  Created by Fernanda Carvalho on 26/03/19.
//  Copyright © 2019 Fernanda Carvalho. All rights reserved.
//

import UIKit

class ToDoList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataPath)
        
        self.items = DAOItem.sharedInstance.getItems()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "ToDoListCell", bundle: nil), forCellReuseIdentifier: "ToDoListCell")
        
        self.addButton.layer.cornerRadius = 25

        // Do any additional setup after loading the view.
    }


    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        
        let item = self.items[indexPath.row]
        cell.title.text = item.title
        if(item.done == true){
            cell.checkButton.setBackgroundImage(UIImage(named: "done"), for: .normal)
        } else {
            cell.checkButton.setBackgroundImage(UIImage(named: "not_done"), for: .normal)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DAOItem.sharedInstance.deleteItem(item: self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        item.done = !item.done
        DAOItem.sharedInstance.updateItem(item: item)
        self.tableView.reloadData()
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add item", message: "Create a new item in the list", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            
            if textField.text != ""{
                if let item = DAOItem.sharedInstance.createItem(title: textField.text!, done: false) {
                    self.items.append(item)
                    self.tableView.reloadData()
                }
            }
            
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
}
