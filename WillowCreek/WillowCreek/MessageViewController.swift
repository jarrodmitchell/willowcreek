//
//  MessageViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/18/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase


protocol MessageViewControllerDelegate {
    func getTenant(tenant: Tenant)
}

class MessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, MessageViewControllerDelegate {
    
    func getTenant(tenant: Tenant) {
        self.recipient = tenant.id
        self.selectTenantButton.titleLabel?.text = tenant.name
    }
    
    
    @IBOutlet weak var tenatLabel: UILabel!
    @IBOutlet weak var selectTenantButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var uId: String!
    var uType: String!
    var uAddress: String!
    var recipient: String!
    var sender: String!
    var index: Int!
    var vcTitle: String!
    var workOrderId: String?
    var dashDelegate: DashboardViewControllerDelegate!
    var updateDelegate: UpdateViewControllerDelegate!
    var tenants: [Tenant]?
    var replyTitle: String!
    var replying: Bool?
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = replying {
            titleTextField.text = replyTitle
            titleTextField.isEnabled = false
        }

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        messageTextView.delegate = self
        messageTextView.textColor = UIColor.lightGray
        messageTextView.text = "Type Here"
        title = vcTitle
        
        selectTenantButton.isHidden = true
        
        if uType == "management" && index == 0 {
            titleTextField.isHidden = true
            titleLabel.isHidden = true
        }else{
            titleTextField.isHidden = false
            titleLabel.isHidden = false
        }
        
        if index == 2 {
            selectTenantButton.isHidden = false
            tenatLabel.isHidden = false
        }else{tenatLabel.isHidden = true}
        print("nav controller count: " + String(navigationController!.viewControllers.count))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    
    
    func getTenants(completionHandler: @escaping () -> Void) {
        Firestore.firestore().collection("tenants").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting tenants: " + error.localizedDescription)
            }else{
                print("Successfully retrieved tenants")
                self.tenants = [Tenant]()
                print("doc count: " + snapshot!.count.description)
                for doc in snapshot!.documents {
                    guard let first = doc.data()["first"] as? String, let last = doc.data()["last"] as? String else {return}
                    let name = first + " " + last
                    guard let address = doc.data()["address"] as? String else {return}
                    let id = doc.documentID
                    let tenant = Tenant(_name: name, _address: address, _id: id)
                    self.tenants!.append(tenant)
                    if self.tenants!.count == snapshot?.documents.count {
                        print("tenats: " + self.tenants!.count.description)
                        completionHandler()
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func selectTenantButtonTapped(_ sender: Any) {
        getTenants {
            self.performSegue(withIdentifier: "searchSegue", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SearchViewController
        
        if let tenants = tenants {
            destination.tenants = tenants
            destination.messageDelegate = self
        }
        
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = "Type Here"
        }
        enableSendButton()
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableSendButton()
    }
    
    
    
    func enableSendButton() {
        if titleTextField.isHidden == false {
            if !(titleTextField.text == "" || messageTextView.text == "Type Here") {
                sendButton.isEnabled = true
            }else{sendButton.isEnabled = false}
        }else if messageTextView.text != "Type here"{
            sendButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let uid = uId else{print("nope"); return}
        print("uid success")
        let message = messageTextView.text!
        print("message success")
        let title = titleTextField.text!
        print("title success")
        print("update")
        
        if uType == "tenants" && index == 0 {
            self.sender = uid
            db.collection("messages").addDocument(data: ["sender" : self.sender!, "recipient": "management", "title" : title, "message" : message, "timeStamp": Date.init(), "viewed": false]) { (error) in
                if let error = error {
                    print("Error adding message from tenant: " + error.localizedDescription)
                }else{
                    print("Successfuly added message from tenant")
                    self.pop()
                }
            }
            
        }else if uType == "maintenance" && index == 0 {
            if let woId = workOrderId {
                db.collection("updates").addDocument(data: ["workOrderId" : woId, "title": title, "message": message, "timeStamp": Date.init()]).addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Error adding update: "  + error.localizedDescription)
                    }else{
                        print("Successfully added update")
                        self.updateDelegate.reload()
                        self.pop()
                    }
                }
            }
            
        }else if index == 0 {
            db.collection("announcements").addDocument(data: ["sender": uid, "message": message, "timeStamp": Date.init()]).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error adding announcement: "  + error.localizedDescription)
                }else{
                    print("Successfully added announcement")
                    self.pop()
                }
            }
            
        }else if uType == "tenants" && index == 1 {
            guard let address = uAddress else{return}
            
            self.db.collection("workOrders").addDocument(data: ["tenant" : uid, "title" : title, "message" : message, "address": address, "reviewed": false, "active": true, "timeStamp": Date.init()]) { (error) in
                if let error = error {
                    print("Error adding work order from tenant: " + error.localizedDescription)
                }else{
                    print("Successfuly added work order from tenant")
                    self.dashDelegate.workOrderAdded()
                    self.pop()
                }
            }
            
        }else if index == 1 {
            
        }else{
            self.sender = uid
            db.collection("messages").addDocument(data: ["sender" : self.sender!, "recipient": recipient!, "title" : title, "message" : message, "timeStamp": Date.init(), "viewed": false]) { (error) in
                if let error = error {
                    print("Error adding added message from management: " + error.localizedDescription)
                }else{
                    print("Successfuly added message from management")
                    self.pop()
                }
            }
            
        }
        
    }
    
    
    
    func pop() {
        DispatchQueue.main.async {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
