//
//  ViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/17/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else{return}
        
        login(email: email, password: password)
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error logging in: " + error.localizedDescription)
            }
            else{
                print("Successfully logged in")
                guard let uid = result?.user.uid else{return}
                guard let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboard") as? DashboardViewController else {return}
                
                let db = Firestore.firestore()
                db.collection("tenants").document(uid).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        print("Error retrieving data" + error.localizedDescription)
                    }else{
                        print("Successfully retrieved data")
                        guard let data = snapshot?.data(), let first = data["first"] as? String, let last = data["last"] as? String else{return}
                        
                        dashboardVC.uId = uid
                        dashboardVC.uName = "\(first) \(last)"
                        let navController = UINavigationController(rootViewController: dashboardVC)
                        self.present(navController, animated: true, completion: nil)
                    }
                })
                
            }
        }
    }


}

