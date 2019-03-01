//
//  ToDoDetailsViewController.swift
//  ToDoList
//
/*
 MIT License
 
 Copyright (c) 2018 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionButton: UIButton!
    
    @IBOutlet weak var taskCompletionDate: UILabel!

    var toDoItem : toDoItem!
    var toDoIndex : Int!
    
    //Delegates must be optional!
    weak var delegate : ToDoListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitleLabel.text = toDoItem.name
        
        taskDetailsTextView.text = toDoItem.details

        if toDoItem.isComplete {
            disableButton()
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        
        let taskDate = formatter.string(from: toDoItem.completionDate)
        
        taskCompletionDate.text = taskDate
    }
    

    
    @IBAction func taskDidComplete(_ sender: Any) {
        
        toDoItem.isComplete = true
        
        delegate?.update(task: toDoItem, index: toDoIndex)
        
        disableButton()
    }
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        taskCompletionButton.isEnabled = true
    }

}
