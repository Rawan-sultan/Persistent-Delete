//
//  ViewController.swift
//  Bucketlist
//
//  Created by Kevin Lagat on 22/11/2022.
//BucketListItem
//  Completed by Rawan on 22/11/2022

import UIKit
import CoreData

class BucketListTableViewController: UITableViewController {
    
    //
    var items = [BucketListItem]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let thing = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
//    thing.BucketListItem = "Some Totally Cool Text"





    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bucket list items"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addItem(_:)))
        fetchAllItems()
        // Do any additional setup after loading the view.
    }
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do {
            let result = try managedObjectContext.fetch(request)
             items = result as! [BucketListItem]
        }catch{
            print("\(error)")
        }
    }
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField! ) -> Void in
            textField.placeholder = "Enter your item"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let itemTextField = alertController.textFields![0] as UITextField
            
            if let name = itemTextField.text {
                if name != "" {
                    let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: self.managedObjectContext) as! BucketListItem
                    item.text = name
                    do {
                        try self.managedObjectContext.save()
                    }catch{
                        print("\(error)")
                    }
                    self.items.append(item)
                }
            }
            
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    //MARK: Edit & Delete
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "Edit", message: "Edit item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.items[indexPath.row].text!
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                self.items[indexPath.row].text! = alert.textFields!.first!.text!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                do {
                    try self.managedObjectContext.save()
                }catch{
                    print("\(error)")
                }
               
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [self]  (contextualAction, view, boolValue) in
            let item = items[indexPath.row]
            managedObjectContext.delete(item)
            do {
                try managedObjectContext.save()
            }catch{
                print("\(error)")
            }
            self.items.remove(at: indexPath.row)
                tableView.reloadData()
            }
        contextItem.backgroundColor = .blue
        deleteAction.backgroundColor = .red
       let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, deleteAction])

       return swipeActions
   }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row].text
            return cell
            
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
   
    

}

