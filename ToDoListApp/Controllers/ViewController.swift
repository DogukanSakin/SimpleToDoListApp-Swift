//
//  ViewController.swift
//  ToDoListApp
//
//  Created by DOGUKAN on 18.05.2023.
//

import UIKit
import CoreData
class ViewController: UIViewController  {
    
    @IBOutlet weak var tableView : UITableView!
    
    var todos = [NSManagedObject]()
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchTodoData()
        
    }
    

    @IBAction func didTapAddButton(_ sender: UIBarButtonItem){
        
        presentAlert(title: "Add a new item",
                     message: "Please write your to do item content.",
                     defaultButtonTitle:"Add",
                     defaultButtonAction: { _ in
            let text = self.alertController.textFields?.first?.text
            
            if(text != ""){
               
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let content = NSManagedObject(entity: entity!, insertInto: managedObjectContext!)
                
                content.setValue(text, forKey: "content")
                
                self.fetchTodoData()
              
            }
            else{
                self.presentAlert(title: "Error",
                                  message: "Please enter a valid to do.")
            }
            
            
        }, isEnabledInputArea: true
        )
        
        
        
    }
    
    @IBAction func didTapDeleteAllButton(_ sender: UIBarButtonItem){
        presentAlert(title: "Are you sure?",
                     message: "Your all items will delete. Are you sure?",
                     defaultButtonTitle: "Delete All") { _ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListItem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do{
                try managedObjectContext!.execute(deleteRequest)
                try managedObjectContext!.save()
                self.todos.removeAll()
                self.tableView.reloadData()
            }
            catch{
                print(error)
            }
            
        }
    }
    
    func presentAlert(title: String?, message: String?, defaultButtonTitle: String? = nil, defaultButtonAction: ((UIAlertAction) -> Void)? = nil, isEnabledInputArea: Bool? = false){
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle:  UIAlertController.Style.alert)
        
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel)
        
        alertController.addAction(cancelButton)
        
        if(defaultButtonTitle != nil){
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: UIAlertAction.Style.default,
                                              handler: defaultButtonAction)
            
            alertController.addAction(defaultButton)
        }
        
        if isEnabledInputArea! {
            alertController.addTextField()
            
        }
        
        
        
        present(alertController, animated: true)
        
    }
    
    
    func fetchTodoData(){
        print("fetch data...")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        do{
            todos = try managedObjectContext!.fetch(fetchRequest)
            self.tableView.reloadData()
        }
        catch{
            print(error)
        }
    }
    
    
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let listItem = todos[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "content") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Delete") { _, _, _ in
            managedObjectContext?.delete(self.todos[indexPath.row])
            try? managedObjectContext?.save()
            self.fetchTodoData()
        }
        let editAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Edit") { _, _, _ in
            self.presentAlert(title: "Edit the item",
                         message: nil,
                         defaultButtonTitle:"Save",
                         defaultButtonAction: { _ in
          
                let text = self.alertController.textFields?.first?.text
                
                if(text != ""){
                    self.todos[indexPath.row].setValue(text, forKey: "content")
                    if managedObjectContext!.hasChanges {
                        try? managedObjectContext?.save()
                    }
                    self.tableView.reloadData()
                }
                else{
                    self.presentAlert(title: "Error",
                                      message: "Please enter a valid to do.")
                }
                
                
            }, isEnabledInputArea: true
            )
            
        }
        deleteAction.backgroundColor = .systemRed
        editAction.backgroundColor = .systemBlue
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return config
    }
}

