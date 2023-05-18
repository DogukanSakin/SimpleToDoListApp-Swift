//
//  ViewController.swift
//  ToDoListApp
//
//  Created by DOGUKAN on 18.05.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    
    var todos = [String]()
    
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        cell.textLabel?.text = todos[indexPath.row]
        return cell
    }
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem){
        
        presentAlert(title: "Add a new item",
                     message: "Please write your to do item content.",
                     defaultButtonTitle:"Add",defaultButtonAction: { _ in
            let text = self.alertController.textFields?.first?.text
            
            if(text != ""){
                self.todos.append(text!)
                self.tableView.reloadData()
            }
            else{
                self.presentAlert(title: "Error",
                                  message: "Please enter a valid to do.")
            }
            
            
        }, isEnabledInputArea: true
        )
        
        
        
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
    
    
    
    
    
    
}

