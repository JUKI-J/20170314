//
//  SecondViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 8..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import MessageUI

class ProcessMessages : UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var processCountLabel: UILabel!
    let selectedPhoneNumber:[String] = [String]()
    let message:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("gaga")
        print("text : \(message)")
        print("phone count : \(selectedPhoneNumber.count)")
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn(_ sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            
            let controller = MFMessageComposeViewController()
            controller.body = message
            var phoneNumbers:[String] = [String]()
            for count in 0...selectedPhoneNumber.count-1 {
                if count > 20 && count%20>0 {
                    controller.recipients = phoneNumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    phoneNumbers.removeAll()
                }
                phoneNumbers.append(selectedPhoneNumber[count])
                if count == selectedPhoneNumber.count-1 {
                    controller.recipients = phoneNumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
                print("count : \(count)")
            }
            
        }else{
            print("occured error")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
}
