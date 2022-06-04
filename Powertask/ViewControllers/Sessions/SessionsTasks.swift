//
//  SessionsTasks.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 24/3/22.
//  Updated by Javier de Castro on 02/05/2022
//

import UIKit
import Alamofire

protocol transferTasksProtocol: AnyObject{
    func transferTasks(_ view: SesionsTasks, taskTitle: String)
}

class SesionsTasks: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: transferTasksProtocol?
    var userTasks: [PTTask]?
    var selectedTask: PTTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTasks = PTUser.shared.tasks
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        NetworkingProvider.shared.listTasks { tasks in
            PTUser.shared.tasks = tasks
            self.userTasks = PTUser.shared.tasks
            PTUser.shared.savePTUser()
            self.tableView.reloadData()
            print(tasks)
        } failure: { msg in
            print("ERROR-tasks")
        }
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let task = userTasks{
            return task.count
        }
        
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.transferTasks(self, taskTitle: userTasks?[indexPath.row].name ?? "ok")
        UserDefaults.standard.set(true, forKey: "taskSelected")
        UserDefaults.standard.set(true, forKey: "taskRunning")
        UserDefaults.standard.set(userTasks?[indexPath.row].name, forKey: "taskSelectedInfo")
        stepsLeft = CGFloat(UserDefaults.standard.value(forKey: "sessionNumber") as! Int)
        numSessions = CGFloat(UserDefaults.standard.value(forKey: "sessionNumber") as! Int)
        actualStatus = .study
        isRunning = true
        self.navigationController?.popViewController(animated: true)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksSessionsCell", for: indexPath) as! SessionsTasksTableViewCell
        
        if let task = userTasks?[indexPath.row]{
            cell.taskPT = task
            cell.titleTask.text = task.name
            return cell
        }
        
        return cell
        
    }
}

extension SesionsTasks: CellButtonTaskDelegate {
    
    func taskSelected(_ task: PTTask) {
        selectedTask = task
        if selectedTask != nil {
            UserDefaults.standard.set(true, forKey: "taskSelected")
            UserDefaults.standard.set(true, forKey: "taskRunning")
        }
    }
}
