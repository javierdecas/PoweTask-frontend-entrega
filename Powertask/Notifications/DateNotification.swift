//
//  DateNotification.swift
//  Powertask
//
//  Created by David Vicente on 29/5/22.
//

import Foundation
import UIKit
import UserNotifications

class DateNotification {
    
    static let shared = DateNotification()
    private init() {}
    
    
    /**
     * Planifica una notificación para la fecha indicada como parámetro dejando editar el título y el cuerpo de la misma. Sólo se ejecuta una única vez
     * - Parameter dateSince1970 fecha con formato int-fecha desde 1970 cuando queremos que se planifique
     * - parameter dateOfEvent fecha del evento en cuestión para incluirla en el título
     * - parameter name título de la notificación
     * - parameter description cuerpo de la notificación
     * - parameter type cadena para identificar el objeto del que se trata
     * - parameter id id del item para no repetir notificaciones
     */
    public func scheduleSingleNotification(dateToAlert: Int, dateOfEvent: Int, name: String, description: String?, type: ItemType, id: Int){
        
        let trigger = obtainCalendarTrigger(dateToAlert: dateToAlert)
        
        
        let content = obtainNotificationContent(dateOfEvent: dateOfEvent, name: name, description: description, type: type, id: id)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(String(id))\(name)\(String(dateToAlert))"])
        let request = UNNotificationRequest(identifier: "\(String(id))\(name)\(String(dateToAlert))", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){
            (error) in
            if let error = error {
                print("Se ha produccido un error: \(error)")
            }
        }
    }
    
    /**
     * Función para crear un Trigger que activa la notificación a cierta hora de cierto día.
     * - parameter dateToAlert fecha en la que debe activarse en formato Int(Interval(From1970))
     * - returns UNCalendarNotificationTrigger con fecha configurada
     */
    public func obtainCalendarTrigger(dateToAlert: Int) -> UNCalendarNotificationTrigger {
        let datePicker = UIDatePicker()
        
        datePicker.setDate(Date(timeIntervalSince1970: TimeInterval(dateToAlert)), animated: false)
        let dateComponents = datePicker.calendar.dateComponents([.day,.month,.year,.hour,.minute], from: datePicker.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    /**
     * Función para crear un cuerpo de la notificación según el tipo que debamos emplear.
     * - parameter dateOfEvent fecha del evento en cuestión para incluirla en el título
     * - parameter name título de la notificación
     * - parameter description cuerpo de la notificación
     * - parameter type cadena para identificar el objeto del que se trata
     * - parameter id id del item para no repetir notificaciones
     * - returns UNMutableNotificationContent con contenido relleno
     */
    public func obtainNotificationContent(dateOfEvent: Int, name: String, description: String?, type: ItemType, id: Int) -> UNMutableNotificationContent{
        
        let content = UNMutableNotificationContent()
        let datePicker = (Date(timeIntervalSince1970: TimeInterval(dateOfEvent)))
        switch type {
        case .task :
            content.title = name
            content.subtitle = datePicker.formatted(date: .long, time: .shortened)
            content.body = description ?? "Ánimo!"
            content.sound = UNNotificationSound.default
            content.badge = 1
            
        case .exam :
            content.title = "Examen: "+name
            content.subtitle = datePicker.formatted(date: .long, time: .shortened)
            content.body = description ?? "Ánimo!"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 2
        
        case .holliday :
            content.title = "Vacaciones: "+name
            content.subtitle = datePicker.formatted(date: .long, time: .shortened)
            content.body = description ?? "Disfruta!"
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 1
            
        case .note :
            content.title = "Nota: "+name
            content.subtitle = datePicker.formatted(date: .long, time: .shortened)
            content.body = description ?? ""
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 1
            
        case .personal :
            content.title = name
            content.subtitle = datePicker.formatted(date: .long, time: .shortened)
            content.body = description ?? ""
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 1
            
        default:
            print("Wrong type")
        }
        
        return content
    }
    
}
