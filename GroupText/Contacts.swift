//
//  Contacts.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 15..
//  Copyright © 2017년 setlog. All rights reserved.
//

import Foundation
import Contacts

class Contacts {
    private var _identifier:String = ""
    private var _familyName:String = ""
    private var _givenName:String = ""
    private var _phone:[CNLabeledValue<CNPhoneNumber>] = [CNLabeledValue<CNPhoneNumber>]()
    
    init(identifier:String,familyName:String,givenName:String,phone:[CNLabeledValue<CNPhoneNumber>]){
        _identifier = identifier
        _familyName = familyName
        _givenName = givenName
        _phone = phone
    }
    
    var identifier:String {
        get {
            return _identifier
        }
    }
    var familyName:String {
        get {
            return _familyName
        }
    }
    var givenName:String {
        get {
            return _givenName
        }
    }
    var phone:[CNLabeledValue<CNPhoneNumber>] {
        get {
            return _phone
        }
    }
}
