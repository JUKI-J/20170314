
//
//  ViewController.swift
//  GroupText
//
//  Created by 정주기 on 2017. 3. 8..
//  Copyright © 2017년 setlog. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groupName : String = ""
    var groupInfoResults = [GroupInfo]()
    var groupNo:String = String()
    
    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("first22")
        self.groupCollectionView.delegate = self
        self.groupCollectionView.dataSource = self
        let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
        do {
            //go get the results
            let searchResults = try context.fetch(fetchRequest)
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            groupInfoResults = searchResults
            //You need to convert to NSManagedObject to use 'for' loops
            for vo in searchResults {
                print("\(vo.groupName!) // \(vo.groupNo!)")
            }
        } catch {
            print("Error with request: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addGroupBtn(_ sender: Any) {
         alertGroupWindow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
        do {
            let searchResults = try context.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            return searchResults.count
        } catch {
            print("Error with request: \(error)")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "groupCollection_cell", for: indexPath) as! GroupCollectionViewCell
        cell.groupImage.image = UIImage(named: "test")
        cell.groupName.text = groupInfoResults[indexPath.item].groupName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath.item
        let groupInfo = groupInfoResults[selectedIndex]
        if let addGroupView = self.storyboard?.instantiateViewController(withIdentifier: "addGroupView"){
            addGroupView.title = groupInfo.groupName
            addGroupView.setValue(groupInfo, forKey: "groupInfo")
            self.navigationController?.pushViewController(addGroupView, animated: true)
        }
    }
    

    
    
    
    //alert group window to input group name
    func alertGroupWindow() {
        let alert = UIAlertController(title: "새 그룹", message: "새 그룹명을 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            //입력받은 텍스트 중복체크 후 텍스트값 넘겨받아 GroupInfo 코어데이터 입력
            if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                print("And the text is... \(alertTextField.text!)!")
                self.groupName = alertTextField.text!
                print(self.groupName)
                
                let entity = NSEntityDescription.entity(forEntityName: "GroupInfo", in: self.context)
                let groupInfo = GroupInfo(entity: entity!, insertInto: self.context)
                groupInfo.groupName = self.groupName
                let groupNo = self.getGroupNoCount()
                if groupNo != "error" {
                    groupInfo.groupNo = groupNo
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }else{
                    print("ocurred error")
                }
                let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
                do {
                    //go get the results
                    let searchResults = try self.context.fetch(fetchRequest)
                    //I like to check the size of the returned results!
                    print ("num of results = \(searchResults.count)")
                    self.groupInfoResults = searchResults
                    //You need to convert to NSManagedObject to use 'for' loops
                    for vo in searchResults {
                        print("\(vo.groupName!) // \(vo.groupNo!)")
                    }
                } catch {
                    print("Error with request: \(error)")
                }
                self.groupCollectionView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
//            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "새 그룹명을 입력하세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //increase groupNo automaticaly
    func getGroupNoCount() -> String{
        let fetchRequest: NSFetchRequest<GroupInfo> = GroupInfo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "groupNo", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let searchResults = try context.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            print(searchResults)
            var maxGroupNo:String = String()
            if searchResults.last?.groupNo != nil {
                maxGroupNo = (searchResults.last?.groupNo)!
            }else{
                maxGroupNo = "0"
            }
            
            let addOne = "\(Int(maxGroupNo)! + 1)"
            return addOne
        } catch {
            print("Error with request: \(error)")
            return "error"
        }
    }
    
}


//초기화면
//그룹 리스트 보여줄것(코어데이터 이용)
//그룹 추가된것 리로드 해올것
//그룹은 컬러 및 그룹명으로 구분
