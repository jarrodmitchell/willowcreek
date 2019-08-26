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
    @IBOutlet weak var loginButton: UIButton!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        loginButton.layer.cornerRadius = 4
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
                
                self.db.collection("users").document(uid).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        print("Error retrieving account type" + error.localizedDescription)
                    }else{
                        print("Successfully retrieved account type")
                        guard let data = snapshot?.data(), let type = data["type"] as? String else{return}
                        
                        self.db.collection(type).document(uid).getDocument(completion: { (snapshot, error) in
                            if let error = error {
                                print("Error retrieving data" + error.localizedDescription)
                            }else{
                                print("Successfully retrieved data")
                                guard let data = snapshot?.data(), let first = data["first"] as? String, let last = data["last"] as? String else{return}
                                
                                dashboardVC.uId = uid
                                dashboardVC.uName = "\(first) \(last)"
                                dashboardVC.uType = type
                                
                                if type == "tenants" {
                                    self.db.collection("tenants").document(uid).addSnapshotListener({ (snapshot, error) in
                                        if let error = error {
                                            print("Error retrieving tenant address: " + error.localizedDescription)
                                        }else{
                                            print("Success getting tenant address")
                                            let address = snapshot?.data()!["address"] as! String
                                            self.db.collection("workOrders").whereField("address", isEqualTo: address).addSnapshotListener { (snapshot, error) in
                                                if let error = error {
                                                    print("Error getting work order count: " + error.localizedDescription)
                                                }else{
                                                    print("Successfully retrieved work order count")
                                                    dashboardVC.workOrderCount = snapshot?.count
                                                    print(dashboardVC.workOrderCount.debugDescription)
                                                    let navController = UINavigationController(rootViewController: dashboardVC)
                                                    navController.navigationBar.backgroundColor = UIColor.white
                                                    self.present(navController, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    })
                                }else if type == "management" {
                                    self.db.collection("workOrders").whereField("reviewed", isEqualTo: false).addSnapshotListener({ (snapshot, error) in
                                        if let error = error {
                                            print("Error getting pending work orders: " + error.localizedDescription)
                                        }else{
                                            print("Successfuly retrieved pending work orders")
                                            dashboardVC.requestCount = snapshot?.count
                                            self.db.collection("workOrders").whereField("active", isEqualTo: true).addSnapshotListener({ (snapshot, error) in
                                                if let error = error {
                                                    print("Error getting active work orders: " + error.localizedDescription)
                                                }else{
                                                    print("Successfuly retrieved pending work orders")
                                                    dashboardVC.workOrderCount = snapshot?.count
                                                }
                                            })
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
                
            }
        }
    }


}

