//
//  InfoAboutTaskViewController.swift
//  ToDoList
//
//  Created by Pavel Plyago on 18.06.2024.
//

import UIKit

class InfoAboutTaskViewController: UIViewController {
    
    var titleTask: String?
    var infoTask: String?
    var newElement: Bool = true
    
    let taskInfo = UITextView()
    let titleField = UITextField()
    let coreDataManager = CoreDataManager.shared
    let saveTaskButton = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
    }
    
    func setUpView(){
        titleField.text = titleTask
        titleField.textColor = UIColor.label
        titleField.placeholder = "Enter Title"
        titleField.font = .systemFont(ofSize: 26, weight: .heavy)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleField)
        
        NSLayoutConstraint.activate([
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        

        taskInfo.font = .systemFont(ofSize: 16, weight: .regular)
        taskInfo.layer.borderWidth = 0.4
        taskInfo.layer.borderColor = UIColor.lightGray.cgColor
        taskInfo.layer.cornerRadius = 8
        taskInfo.text = infoTask
        
        taskInfo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskInfo)
        
        NSLayoutConstraint.activate([
            taskInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            taskInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            taskInfo.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
            taskInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        saveTaskButton.setTitle("Save", for: .normal)
        saveTaskButton.tintColor = .systemBackground
        saveTaskButton.backgroundColor = .systemBlue
        saveTaskButton.layer.cornerRadius = 16
        saveTaskButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        saveTaskButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        saveTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveTaskButton)
        
        NSLayoutConstraint.activate([
            saveTaskButton.centerYAnchor.constraint(equalTo: titleField.centerYAnchor),
            saveTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveTaskButton.leadingAnchor.constraint(equalTo: titleField.trailingAnchor, constant: 10)
        ])
    }
    
    @objc func saveTask(){
        if newElement{
            let title = titleField.text ?? ""
            let info = taskInfo.text ?? ""
            coreDataManager.createTask(title: title, info: info)
        } else {
            guard let oldTask = coreDataManager.fetchTask(title: titleTask ?? "", info: infoTask ?? "") else { return }
            coreDataManager.updateTask(task: oldTask, newTitle: titleField.text ?? "", newInfo: taskInfo.text ?? "")
        }
        navigationController?.popViewController(animated: true)
    }

}
