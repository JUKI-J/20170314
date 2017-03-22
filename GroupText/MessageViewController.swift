//
//  MessageViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 16..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class MessageViewController: UIViewController {
    
    var selectedPhoneNumber:[String] = [String]()
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        print("count : \(selectedPhoneNumber.count)")
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSendBtn(_ sender: Any) {
        let message:String = textView.text
        if let processView = self.storyboard?.instantiateViewController(withIdentifier: "processView"){
            processView.setValue(message, forKey: "message")
            processView.setValue(selectedPhoneNumber, forKey: "selectedPhoneNumber")
            self.present(processView, animated: true, completion: nil)
        }
    }
    
}
