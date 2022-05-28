//
//  UserTask.swift
//  Powertask
//
//  Created by Daniel Torres on 18/1/22.
//  Updated by Javier de Castro on 28/05/2022
//

import Foundation
import UIKit

struct PTTask: Codable {
    var id: Int?
    var google_id: String?
    var name: String
    var date_start: Int?
    var date_handover: Int?
    var mark: Float?
    var description: String?
    var completed: Int
    var subject: PTSubject?
    var studentId: Int?
    var subtasks: [PTSubtask]?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case googleId = "google_id"
//        case name
//        case serverStartDate = "date_start"
//        case serverHandoverDate = "date_handover"
//        case mark
//        case description
//        case completed
//        case subject
//        case studendId = "student_id"
//        case subtasks
//    }
}
