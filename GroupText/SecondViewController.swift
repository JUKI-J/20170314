//
//  SecondViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 8..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import MessageUI

class SecondViewController : UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = message.text
            controller.recipients = [phoneNumber.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            print("occured error")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
}
