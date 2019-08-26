//
//  MessageViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/18/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tenantLabel: UILabel!
    @IBOutlet weak var tenantTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var uId: String!
    var uType: String!
    var index: Int!
    var vcTitle: String!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        messageTextView.delegate = self
        messageTextView.textColor = UIColor.lightGray
        messageTextView.text = "Type Here"
        title = vcTitle
        if uType == "tenants" && index == 0 {
            tenantLabel.isHidden = false
            tenantTextField.isHidden = false
        }
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
        if !(titleTextField.text == "" || messageTextView.text == "Type Here") {
            sendButton.isEnabled = true
        }else{sendButton.isEnabled = false}
    }
    
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let uid = uId else{return}
        print("uid success")
        guard let message = messageTextView.text else{return}
        print("message success")
        guard let title = titleTextField.text else {return}
        print("title success")
        
        if uType == "tenants" && index == 0 {
            
            db.collection("messages").addDocument(data: ["sender" : uid, "recipient": tenantTextField.text ?? "management", "title" : title, "message" : message]) { (error) in
                if let error = error {
                    print("Error adding work order: " + error.localizedDescription)
                }else{
                    print("Successfuly added work order")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        }else if index == 0 {
            
        }else if uType == "tenants" && index == 1 {
            db.collection("workOrders").addDocument(data: ["tenant" : uid, "title" : title, "message" : message, "reviewed": false, "active": false]) { (error) in
                if let error = error {
                    print("Error adding work order: " + error.localizedDescription)
                }else{
                    print("Successfuly added work order")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }else if index == 1 {
            
        }else{
            
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
