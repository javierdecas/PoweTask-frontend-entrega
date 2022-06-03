//
//  SessionsTasksCell.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 24/3/22.
//  Updated by Javier de Castro on 01/06/2022
//

import UIKit

protocol CellButtonTaskDelegate: AnyObject {
    func taskSelected(_ task: PTTask)
}

class SessionsTasksTableViewCell: UITableViewCell {
    
    var buttonDelegate: CellButtonTaskDelegate?
    @IBOutlet weak var titleTask: UILabel!
    var taskPT : PTTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Probablemente aquí pasemos la info a la sesión
        super.setSelected(selected, animated: animated)
        buttonDelegate?.taskSelected(taskPT!)
    }
    
    @objc func taskSelected(_ sender: UILabel!) {
        buttonDelegate?.taskSelected(taskPT!)
    }
    
    
}
