//
//  MockRequestViewController.swift
//  Powertask
//
//  Created by Daniel Torres on 18/2/22.
//

import UIKit
import GoogleSignIn

class MockRequestViewController: UIViewController {
    let signInConfig = GIDConfiguration.init(clientID: "443913123362-7m0oo4dn1qocas3sdn0ih74l2mremnor.apps.googleusercontent.com")
    var superUser: GIDGoogleUser? = GIDGoogleUser()
    let apiToken: String = "$2y$10$gyMzuSL41tG/9u/ToCRWWepV4AYsB5VmpoWiwi5iRXvslNzf4kN9e"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Supporting functions
    func signIn() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootScreen")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true) {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            }
            //self.present(vc, animated: true, completion: nil)
//            self.requestScopes()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    func requestScopes() {
        let additionalScopes = ["https://www.googleapis.com/auth/classroom.announcements.readonly",
                                "https://www.googleapis.com/auth/classroom.courses.readonly",
                                "https://www.googleapis.com/auth/classroom.coursework.me.readonly",
                                "https://www.googleapis.com/auth/classroom.courseworkmaterials.readonly"]
        GIDSignIn.sharedInstance.addScopes(additionalScopes, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            self.superUser = user
            let driveScope = "https://www.googleapis.com/auth/classroom.courses.readonly"
            let grantedScopes = user.grantedScopes
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
              print("request again")
            }
        }
        
    }
    
    func requestTest(user: GIDGoogleUser) {
        user.authentication.do { authentication, error in
               guard error == nil else { return }
               guard let authentication = authentication else { return }
            NetworkingProvider.shared.listTasks(success: { tasks in
                print(tasks)
            }, failure: { msg in
                print(msg)
            })
           }
    }

    // MARK: - Navigation
    @IBAction func signIn(_ sender: Any) {
        signIn()
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOut()
    }
    @IBAction func getTaskList(_ sender: Any) {
        if let user = superUser {
            requestTest(user: user)

        }
    }
    @IBAction func getSubjects(_ sender: Any) {
       
    }
    
    
}
