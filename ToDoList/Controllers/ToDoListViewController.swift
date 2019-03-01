//
//  ToDoListViewController.swift
//  ToDoList
//

protocol ToDoListDelegate : class {
    
    func update(task: toDoItem, index: Int)
}

import UIKit



class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var toDoItemsList : [toDoItem] = [toDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))

        
        let testItem = toDoItem(name: "Gym", details: "Friday am w/ Philippe", completionDate: Date())
        
        self.toDoItemsList.append(testItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: true)
    }

    @objc func addTapped() {
        
        performSegue(withIdentifier: "goToAddTask", sender: nil)
        
    }
    
    @objc func editTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
        }
        else {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, IndexPath) in
            
            self.toDoItemsList.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [IndexPath], with: UITableView.RowAnimation.automatic)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItemsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = toDoItemsList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItemsList[indexPath.row]
        
        let toDoTuple = (indexPath.row, selectedItem)
        
                                                //**Sent items available as sender.attribute**
        performSegue(withIdentifier: "goToTask", sender: toDoTuple)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTask" {
            
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {return}
            
            guard let toDoTuple = sender as? (Int, toDoItem) else { return }
            
            destinationVC.toDoIndex = toDoTuple.0
            
            destinationVC.toDoItem = toDoTuple.1
            
            destinationVC.delegate = self
            
        }
        
    }
}

extension ToDoListViewController: ToDoListDelegate {
    
    func update(task: toDoItem, index: Int) {
        
        toDoItemsList[index] = task
        
        tableView.reloadData()
    }
}
