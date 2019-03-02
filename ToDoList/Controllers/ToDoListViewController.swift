//
//  ToDoListViewController.swift
//  ToDoList
//

protocol ToDoListDelegate : class {
    
    func update()
}

import UIKit
import RealmSwift


class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var taskList : Results<Task>? {
        
        get {
            guard let realm = LocalDatabaseManager.realm else {
                return nil
            }
            return realm.objects(Task.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init("com.todolistapp.addTask"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: true)
    }

    @objc func addTapped() {
        
        performSegue(withIdentifier: "goToAddTask", sender: nil)
        
    }
    
    @objc func addNewTask(_ notification : NSNotification) {
        
//        var toDoItem : toDoItem!
//
//        if let task = notificati on.object as? toDoItem {
//
//            toDoItem = task
//        }
//        else if let taskDict = notification.userInfo as NSDictionary? {
//
//            guard let task = taskDict["Task"] as? toDoItem else {return}
//
//            toDoItem = task
//
//        }
//        else {
//            return
//        }
//
//        toDoItemsList.append(toDoItem)
//
//        toDoItemsList.sort(by: {$0.completionDate < $1.completionDate})
        
        //Task is added directly from AddTaskViewController
        
        
        
        tableView.reloadData()
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
            
//           self.toDoItemsList.remove(at: indexPath.row)
            
            guard let realm = LocalDatabaseManager.realm else {
                return
            }
            do{
                try realm.write {
                    realm.delete(self.taskList![indexPath.row])
                }
            }
            catch let error as NSError{
                print(error.localizedDescription)
                return
            }
            
            self.tableView.deleteRows(at: [IndexPath], with: UITableView.RowAnimation.automatic)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return toDoItemsList.count
        return taskList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = taskList![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = taskList![indexPath.row]
        
        let toDoTuple = (selectedItem , indexPath.row)
        
                                                //**Sent items available as sender.attribute**
        performSegue(withIdentifier: "goToTask", sender: toDoTuple)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTask" {
            
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {return}
            
            guard let toDoTuple = sender as? (Task, Int) else { return }
            
            destinationVC.toDoItem = toDoTuple.0
            
            destinationVC.toDoIndex = toDoTuple.1
            
            destinationVC.delegate = self
            
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.addTask"), object: nil)
    }
    
}

extension ToDoListViewController: ToDoListDelegate {
    
    func update() {
        //todoList[index] = task
        
        tableView.reloadData()
    }
}
