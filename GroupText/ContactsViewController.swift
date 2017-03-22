//
//  ContactsViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 14..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    var contactInfo:[Contacts] = [Contacts]()
    var groupInfo = GroupInfo()
    
    override func viewDidLoad() {
        getContacts()
        self.tableView.allowsMultipleSelection = true
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getContacts() {
        let contactStore = CNContactStore()
        //fetchRequest.unifyResults = true //True should be the default option
        do {
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                (contact, cursor) -> Void in
                if (!contact.familyName.isEmpty) || (!contact.familyName.isEmpty) {
                    //print(contact.familyName)
                    print(contact.identifier)
                    let identifier = contact.identifier
                    let familyName = contact.familyName
                    let givenName = contact.givenName
                    let phone = contact.phoneNumbers
                    let contacts = Contacts.init(identifier: identifier, familyName: familyName, givenName: givenName, phone: phone)
                   self.contactInfo.append(contacts)
                }
            }
            //contactInfo = contactInfo.sorted(by: { $0.givenName < $1.givenName })
        }
        catch{
            print("Handle the error please")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "contactsCell") as! CustomCell
        let info = contactInfo[indexPath.item]
        //cell.textLabel?.text = "\(info.givenName) \(info.familyName)"
        
        var phoneNum:String = ""
        for phone in info.phone {
            if (phone.label?.contains("Mobile"))! || (phone.label?.contains("iPhone"))!{
                var digits = "\(phone.value.value(forKey: "digits")!)"
                if digits.characters.count == 10 {
                    digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
                    digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 7))
                }else if digits.characters.count == 11 {
                    digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 3))
                    digits.insert("-", at: digits.index(digits.startIndex, offsetBy: 8))
                }else{
                    
                }
                phoneNum = digits
                break
            }else{
                phoneNum = "\(phone.value.value(forKey: "digits")!)"
            }
        }
        if matches(text: info.familyName) {
            cell.name.text = "\(info.familyName) \(info.givenName)"
        }else{
            cell.name.text = "\(info.givenName) \(info.familyName)"
        }
        cell.phone.text = phoneNum
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.imageView?.image == UIImage(named: "test"){
            cell?.imageView?.image = UIImage.init()
        }else{
            cell?.imageView?.image = UIImage(named: "test")
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func saveContactsInfo(_ sender: Any) {
        if self.tableView.numberOfSections > 0 {
            for i in 0...contactInfo.count-1 {
                let entity = NSEntityDescription.entity(forEntityName: "Identifier", in: self.context)
                let identifierInfo = Identifier(entity: entity!, insertInto: self.context)
                let cell = self.tableView.cellForRow(at: [0,i])
                if cell?.imageView?.image == UIImage(named: "test") {
                    let info = contactInfo[i]
                    print("image : \(i)")
                    identifierInfo.groupNo = groupInfo.groupNo
                    identifierInfo.identifier = info.identifier
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func matches(text: String) -> Bool{
        do {
            let regex = try NSRegularExpression(pattern: "\\b([가-힣]+)\\b")
            let nsString = text as NSString
            _ = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return true
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}

class CustomCell:UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
}
