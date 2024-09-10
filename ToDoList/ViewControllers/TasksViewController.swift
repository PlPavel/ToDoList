//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Pavel Plyago on 17.06.2024.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    
    private lazy var tasksTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    let taskTitle = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setUpView()
        view.addSubview(tasksTableView)

        NSLayoutConstraint.activate([
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.topAnchor.constraint(equalTo: taskTitle.bottomAnchor, constant: 20),
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        tasksTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func setUpView(){
        taskTitle.text = "Your Tasks"
        taskTitle.font = .systemFont(ofSize: 26, weight: .heavy)
        taskTitle.textColor = UIColor.label
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskTitle)
        
        NSLayoutConstraint.activate([
            taskTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            taskTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        
        let addTaskButton = UIButton(type: .system)
        addTaskButton.setTitle("+", for: .normal)
        addTaskButton.tintColor = UIColor.label
        addTaskButton.titleLabel?.font = .systemFont(ofSize: 23, weight: .bold)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        view.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addTaskButton.centerYAnchor.constraint(equalTo: taskTitle.centerYAnchor, constant: -3),
        ])
    }
    
    @objc func addNewTask(){
        let vc = InfoAboutTaskViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataManager.fetchTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        let task = coreDataManager.fetchTasks()[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,completionHandler  in
            let task = self?.coreDataManager.fetchTasks()[indexPath.row]
            let title = task?.title ?? ""
            let info = task?.info ?? ""
            self?.coreDataManager.deleteTask(title: title, info: info )
            self?.tasksTableView.reloadData()
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = InfoAboutTaskViewController()
        vc.modalPresentationStyle = .fullScreen
        let task = coreDataManager.fetchTasks()[indexPath.row]
        vc.titleTask = task.title
        vc.infoTask = task.info
        vc.newElement = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
