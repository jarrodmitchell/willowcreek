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
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var uId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        messageTextView.delegate = self
        messageTextView.textColor = UIColor.lightGray
        messageTextView.text = "Type Here"
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
        if !(titleTextField.text == "" && messageTextView.text.isEmpty) {
            sendButton.isEnabled = true
        }else{sendButton.isEnabled = false}
    }
    
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        
        guard let uid = uId else{return}
        guard let message = messageTextView.text else{return}
        guard let title = titleTextField.text else {return}
        
        db.collection("workOrders").addDocument(data: ["tenant" : uid, "title" : title, "message" : message]) { (error) in
            if let error = error {
                print("Error adding work order: " + error.localizedDescription)
            }
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
