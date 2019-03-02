//
//  AddTaskViewController.swift
//  ToDoList
//
/*
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var touchView : UIView = {
        
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor.lightGray
        _touchView.alpha = CGFloat(0.2)
        
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        
        _touchView.addGestureRecognizer(touchViewTapped)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        return _touchView
    }()

    var activeTextField : UITextField?
    
    var activeTextView : UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        taskNameTextField.delegate = self
        taskDetailsTextView.delegate = self
        
        let navigationItem = UINavigationItem(title: "Add Task")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        
        navigationBar.items = [navigationItem]
        
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskDetailsTextView.layer.borderWidth = CGFloat(1)
        taskDetailsTextView.layer.cornerRadius = CGFloat(3)
        
        let toolBarDone = UIToolbar.init()
        toolBarDone.barTintColor = UIColor.red
        toolBarDone.isTranslucent = false
        toolBarDone.sizeToFit()

        //TOOLBAR FUNCTIONALITY
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//
//        let barButtonDone = (UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed)))
//
//        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
//
//        toolBarDone.items = [flexSpace, barButtonDone, flexSpace]
//
//        taskNameTextField.inputAccessoryView = toolBarDone
//
//        taskDetailsTextView.inputAccessoryView = toolBarDone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterFromKeyboardNotication()
    }
    
    //Listeners:
    
    @objc func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification: )), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: UIWindow.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func deregisterFromKeyboardNotication() {
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(notification : NSNotification) {
        
        view.addSubview(touchView)

        let info : NSDictionary = notification.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize!.height + 10.0), right: 0)
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = UIScreen.main.bounds
        
        aRect.size.height -= keyboardSize!.height
        
        if activeTextField != nil {
            
            if (!aRect.contains(activeTextField!.frame.origin)) {
                
                self.scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        }
        else if activeTextView != nil {
            
            let textViewPoint : CGPoint = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.size.height + activeTextView!.frame.size.height)
            
            if (aRect.contains(textViewPoint)) {
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        
        touchView.removeFromSuperview()
        
        let contentInsets : UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollView.contentInset = contentInsets
        
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
    }
    
    @objc func endEditing() {
        
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        guard let newTaskName = taskNameTextField.text, !newTaskName.isEmpty else {
            
            reportError(title: "Invalid task name", message: "Task name is required")
            
            return
        }
        
        if newTaskName.count > 50 {
            reportError(title: "Invalid task name", message: "Cannot be longer than 50 characters")
            return
        }

        if taskDetailsTextView.text.isEmpty {
            
            reportError(title: "Invalid task details", message: "Task details are required")
            
            return
        }
        
        let completionDate : Date = taskCompletionDatePicker.date
        
        if completionDate < Date() {
            
            reportError(title: "Invalid completion date", message: "You cannot complete a task in the past... \nOr can you?")
            
            return
        }
        
        guard let realm = LocalDatabaseManager.realm else {
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        let nextTaskId = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        let newTask = Task()
        
        newTask.id = nextTaskId
        newTask.name = newTaskName
        newTask.details = taskDetailsTextView.text
        
        newTask.completionDate = completionDate as NSDate
        
        newTask.isComplete = false
        
        do {
            
            try realm.write {
                realm.add(newTask)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            
            reportError(title: "Error", message: "New task could not be created")
        }
        
//        let newTask = toDoItem(name: newTaskName, details: taskDetailsTextView.text, completionDate: taskCompletionDatePicker.date)
//
//        let toDoDict : [String : toDoItem] = ["Task" : newTask]

//      NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addTask"), object: newTask)
        
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addTask"), object: nil, userInfo: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    func reportError(title : String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}


extension AddTaskViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

extension AddTaskViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        activeTextView = nil
    }
}
