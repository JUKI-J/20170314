//
//  AddGroupViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 9..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import Contacts
import CoreData

class AddGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paramLabel: UILabel!
    var groupInfo = GroupInfo()
    var contactInfo:[CNContact] = [CNContact]()
    @IBOutlet weak var countLabel: UILabel!
    var selectedCount:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("addGroupView")
        //getContactsInfoByGroupNo()
        let rightNavBarButton = UIBarButtonItem.init(title: "add", style: .plain, target: self, action: #selector(AddGroupViewController.showCntactsView))
        self.navigationItem.setRightBarButton(rightNavBarButton, animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will will will")
        getContactsInfoByGroupNo()
        tableView.reloadData()
        
        for i in 0...contactInfo.count-1 {
            let cell = self.tableView.cellForRow(at: [0,i])
            cell?.imageView?.image = UIImage.init()
            if cell?.imageView?.image == UIImage(named: "test"){
                selectedCount+=1
            }
        }
        countLabel.text = "\(selectedCount)/\(contactInfo.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectAllRows(_ sender: Any) {
        for i in 0...contactInfo.count-1 {
            let cell = self.tableView.cellForRow(at: [0,i])
            cell?.imageView?.image = UIImage(named: "test")
        }
        tableView.reloadData()
        selectedCount = contactInfo.count
        countLabel.text = "\(selectedCount)/\(contactInfo.count)"
    }
    
    @IBAction func deselectAll(_ sender: Any) {
        for i in 0...contactInfo.count-1 {
            let cell = self.tableView.cellForRow(at: [0,i])
            cell?.imageView?.image = UIImage.init()
        }
        tableView.reloadData()
        selectedCount = 0
        countLabel.text = "\(selectedCount)/\(contactInfo.count)"
    }
    
    //get selected group contacts info
    func getContactsInfoByGroupNo() {
        contactInfo.removeAll()
        let fetchRequest: NSFetchRequest<Identifier> = Identifier.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupNo == %@", groupInfo.groupNo!)
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        var identifiers:[String] = [String]()
        do {
            let searchResults = try context.fetch(fetchRequest)
            for item in searchResults {
                identifiers.append(item.identifier!)
            }
            getContacts(identifiers: identifiers)
            contactInfo = contactInfo.sorted(by: { $0.familyName < $1.familyName })
           
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func getContacts(identifiers:[String]) {
        let store = CNContactStore()
        let predicate = CNContact.predicateForContacts(withIdentifiers: identifiers)
        let toFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactIdentifierKey, CNContactPhoneNumbersKey]
        do{
            let contacts = try store.unifiedContacts(
                matching: predicate, keysToFetch: toFetch as [CNKeyDescriptor])
            
            for contact in contacts{
                contactInfo.append(contact)
            }
        } catch let err{
            print(err)
        }
    }
    
    func showCntactsView() {
        if let contactsView = self.storyboard?.instantiateViewController(withIdentifier: "contactsView"){
            contactsView.title = "Contacts"
            contactsView.setValue(groupInfo, forKey: "groupInfo")
            self.present(contactsView, animated: true, completion: nil)
        }
    }
    
    @IBAction func messageView(_ sender: Any) {
        let messageView = self.storyboard!.instantiateViewController(withIdentifier: "messageView")
        
        //
        //선처리 그룹내에서 선택된 이름과 번호 객체 배열 만든후 넘겨줄것
        //
        //
        var selectedPhoneNumber:[String] = [String]()
        
        for i in 0...contactInfo.count-1 {
            let cellRow = self.tableView.cellForRow(at: [0,i])
            if cellRow?.imageView?.image == UIImage(named: "test"){
                var stringPhoneNumber:String = String()
                
                let customCell = self.tableView.cellForRow(at: [0,i]) as! AddGroupCustomCell
                stringPhoneNumber = customCell.phoneCell.text!
                print("stringPhoneNumber : \(stringPhoneNumber)")
                selectedPhoneNumber.append(stringPhoneNumber)
            }
        }
        messageView.setValue(selectedPhoneNumber, forKey: "selectedPhoneNumber")
        messageView.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(messageView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "addGroupCell") as! AddGroupCustomCell
        let info = contactInfo[indexPath.item]
        var phoneNum:String = ""
        for phone in info.phoneNumbers {
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
            cell.nameCell.text = "\(info.familyName) \(info.givenName)"
        }else{
            cell.nameCell.text = "\(info.givenName) \(info.familyName)"
        }
        
        cell.phoneCell.text = phoneNum
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.imageView?.image == UIImage(named: "test"){
            cell?.imageView?.image = UIImage.init()
        }else{
            cell?.imageView?.image = UIImage(named: "test")
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCount = 0
        for i in 0...contactInfo.count-1 {
            let cellRow = self.tableView.cellForRow(at: [0,i])
            if cellRow?.imageView?.image == UIImage(named: "test"){
                selectedCount+=1
            }
        }
        countLabel.text = "\(selectedCount)/\(contactInfo.count)"
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

class AddGroupCustomCell:UITableViewCell{
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var phoneCell: UILabel!
}
