//
//  SessionsViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 14/1/22.
//

import UIKit
import SwiftUI
class SessionsViewController: UIViewController, transferTasksProtocol{
    
    func transferTasks(_ view: SesionsTasks, taskTitle: String) {
        selectTask.titleLabel?.text = taskTitle
        UserDefaults.standard.set(true, forKey: "taskSelected")
    }
    

    @IBOutlet weak var selectTask: UIButton!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var countdownDesactive: UIView!
    @IBOutlet weak var countdownActive: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskControllerButton: UIButton!
    
    var sessionTime : Int = 0
    var sessionNumber: Int = 0
    var sessionShortBreak: Int = 0
    var sessionLongBreak: Int = 0
    
    var taskSelected: Bool?
    public var timeSession: CGFloat?
    override func viewDidLoad() {
        timerActivity()
        super.viewDidLoad()
        
        selectTask?.layer.cornerRadius = 20
        selectTask?.layer.cornerCurve = .circular
        
        //timerActivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timerActivity()
        super.viewDidAppear(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConfiguration" {
                let controller = segue.destination as? SessionsConfiguration
            }
        }
    
    
    @IBAction func configurationButton(_ sender: Any) {
        performSegue(withIdentifier: "showConfiguration", sender: self)
    }
    
    @IBAction func showConfiguration(_ sender: Any) {
        performSegue(withIdentifier: "showConfiguration", sender: self)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    func timerActivity(){
        
        taskSelected = UserDefaults.standard.value(forKey: "taskSelected") as? Bool
        if(UserDefaults.standard.value(forKey: "sessionTime") == nil){
            let ses = SessionsConfiguration()
            ses.initializeDefaultConfig()
        }
        sessionTime = UserDefaults.standard.value(forKey: "sessionTime") as! Int
        sessionNumber = UserDefaults.standard.value(forKey: "sessionNumber") as! Int
        sessionShortBreak = UserDefaults.standard.value(forKey: "sessionShortBreak") as! Int
        sessionLongBreak = UserDefaults.standard.value(forKey: "sessionLongBreak") as! Int

        if taskSelected == true{
            //let test  = CGFloat(sessionTime * 60)
            //timeRemainingActive = test
            countdownActive.isHidden = false
            countdownDesactive.isHidden = true
            
        }else{
            countdownActive.isHidden = true
            countdownDesactive.isHidden = false
            //taskLabel.isHidden = true
            //taskControllerButton.isHidden = true
        }
    }
    @IBAction func playPauseButton(_ sender: Any) {
        
    }
}
