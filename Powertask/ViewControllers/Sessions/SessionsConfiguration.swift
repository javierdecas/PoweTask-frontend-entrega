//
//  SessionsConfiguration.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 23/3/22.
//

import UIKit
import Alamofire
class SessionsConfiguration: UIViewController, UITableViewDataSource, UITableViewDelegate, SessionStepperProtocol{

    @IBOutlet weak var tableView: UITableView!
    var sessionTime: Int = 0
    var sessionNumber: Int = 0
    var sessionShortBreak: Int = 0
    var sessionLongBreak: Int = 0
    
    override func viewDidLoad() {
        loadConfig()
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    /**
     * Carga la configuración conservada en la app
     */
    func loadConfig(){
        
        if UserDefaults.standard.value(forKey: "sessionTime") == nil {
            initializeDefaultConfig()
        }
        
        sessionTime = UserDefaults.standard.value(forKey: "sessionTime") as! Int
        sessionNumber = UserDefaults.standard.value(forKey: "sessionNumber") as! Int
        sessionShortBreak = UserDefaults.standard.value(forKey: "sessionShortBreak") as! Int
        sessionLongBreak = UserDefaults.standard.value(forKey: "sessionLongBreak") as! Int
    }
    
    /**
     * Si la configuración no está establecida en la app, carga unos defaults
     */
    func initializeDefaultConfig() {
        UserDefaults.standard.set(Int(25), forKey: "sessionTime") //25 minutos la sesión
        UserDefaults.standard.set(Int(5), forKey: "sessionNumber") // 5 sesiones
        UserDefaults.standard.set(Int(5), forKey: "sessionShortBreak") // 5 Minutos de pausa corta
        UserDefaults.standard.set(Int(20), forKey: "sessionLongBreak") // 20 minutos de descanso largo
    }
    
    /**
     * Función para gestionar el cambio de los parámetros de configuración (Subidas y bajadas de los tiempos de la sesión)
     * - parameter cell Celda de la tabla a modificar, correspondiente al parámetro a cambiar
     * - parameter sessionTimeNew nuevo valor de tiempo
     */
    func stepperTimeChanged(_ cell: SessionsConfigurationTableViewCell, sessionTimeNew: Int?) {
        let indexPath = tableView.indexPath(for: cell)
        
        if let index = indexPath?.row{
            if index == 0{
                sessionTime = sessionTimeNew!
                UserDefaults.standard.set(sessionTime, forKey: "sessionTime")
                UserDefaults.standard.set(Int(sessionTime * 60), forKey: "sessionTimeSecs")
            }else if index == 1{
                sessionNumber = sessionTimeNew!
                UserDefaults.standard.set(sessionNumber, forKey: "sessionNumber")
            }else if index == 2{
                sessionShortBreak = sessionTimeNew!
                UserDefaults.standard.set(sessionShortBreak, forKey: "sessionShortBreak")
                UserDefaults.standard.set(Int(sessionShortBreak * 60), forKey: "sessionShortBreakSecs")
            }else if index == 3{
                sessionLongBreak = sessionTimeNew!
                UserDefaults.standard.set(sessionLongBreak, forKey: "sessionLongBreak")
                UserDefaults.standard.set(Int(sessionLongBreak * 60), forKey: "sessionLongBreakSecs")
            }
        }
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name = ""
        switch (section){
        case 0:
            name = "Sesiones"
            break
        default:
            name = ""
            break
        }
        
        return name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    /**
     * Función para cargar todos los parámetros de configuración de la tabla
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "configurationCell", for: indexPath) as! SessionsConfigurationTableViewCell
        
        if indexPath.row == 0{
            cell.titleConfiguration.text = "Tiempo de sesion (mins)"
            cell.showAmount.text = "\(String(sessionTime))"
            cell.selectAmount.value = Double(sessionTime)
            cell.delegate = self
            return cell
        }else if indexPath.row == 1{
            cell.titleConfiguration.text = "Numero de sesiones"
            cell.showAmount.text = (String(sessionNumber))
            cell.selectAmount.value = Double(sessionNumber)
            cell.delegate = self
            return cell
        }else if indexPath.row == 2{
            cell.titleConfiguration.text = "Descanso corto (mins)"
            cell.showAmount.text = (String(sessionShortBreak))
            cell.selectAmount.value = Double(sessionShortBreak)
            cell.delegate = self
            return cell
        }else if indexPath.row == 3{
            cell.titleConfiguration.text = "Descanso largo (mins)"
            cell.showAmount.text = (String(sessionLongBreak))
            cell.selectAmount.value = Double(sessionLongBreak)
            cell.delegate = self
            return cell
        }
        
        return cell
        
    }
}
