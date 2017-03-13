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

class AddGroupViewController: UIViewController  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var paramLabel: UILabel!
    var groupInfo = GroupInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(groupInfo)
        getContactsInfoByGroupNo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //get selected group contacts info
    func getContactsInfoByGroupNo() {
        let fetchRequest: NSFetchRequest<Identifier> = Identifier.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let searchResults = try context.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func getContacts() {
        let contactStore = CNContactStore()
        //fetchRequest.unifyResults = true //True should be the default option
        do {
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])) {
                (contact, cursor) -> Void in
                //                if (!contact.emailAddresses.isEmpty){
                //                    //    print(contact.givenName)
                //                }
                if (!contact.familyName.isEmpty) || (!contact.familyName.isEmpty) {
                    //print(contact.familyName)
                    print(contact.identifier)
                }
                //print("\(contact.nickname) / \(contact.)")
                
            }
        }
        catch{
            print("Handle the error please")
        }
    }
    
    //get contacts view
    @IBAction func getContactsView(_ sender: Any) {
        
    }
    
}
