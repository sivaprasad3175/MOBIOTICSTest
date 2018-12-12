//
//  ViewController.swift
//  ContactTest
//
//  Created by Raja on 12/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit
import CoreData

class ContactListVc: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AddContactVCDelagte {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactTabelView: UITableView!
    
    var contactList = CoreDataHelper.shared.retrieveData()
    var fiterList = [User]()
    var searchActive = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    //MARK:-Table view delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive{
            return fiterList.count
        }
        return contactList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_identifier") as! customCell
        var person : User?
        if searchActive{
            person = fiterList[indexPath.row]
        } else{
            person = contactList![indexPath.row]
        }
        cell.profileLbl.text = person?.firstName
        if let image = person?.image{
            cell.profilePic.image = (image as! UIImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user : User?
        if searchActive{
            user = fiterList[indexPath.row]
        } else{
            user = contactList![indexPath.row]
        }
        navigateVc("add_controller_vc", 101, user)
    }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CoreDataHelper.shared.deleteUser(contactList![indexPath.row])
            self.contactList?.remove(at: indexPath.row)
            self.contactTabelView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //Mark:-SearchBar delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fiterList = (contactList?.filter({$0.firstName?.lowercased() == searchText.lowercased()}))!
        if fiterList.count > 0{
            searchActive = true
            self.contactTabelView.reloadData()
        } else{
            searchActive = false
            contactTabelView.reloadData()
        }
    }
    
    fileprivate func navigateVc(_ identifier:String , _ tag: Int, _ user:User?){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addContactVc = storyBoard.instantiateViewController(withIdentifier: identifier) as! AddContactVC
        addContactVc.delegate = self
        addContactVc.tag = tag
        addContactVc.user = user
        self.navigationController?.pushViewController(addContactVc, animated: true)

    }
    
    func reloadTable() {
        contactList = CoreDataHelper.shared.retrieveData()
        self.contactTabelView.reloadData()
    }
    
    // actions
    @IBAction func contactAddBtn(_ sender: UIBarButtonItem) {
        navigateVc("add_controller_vc", 201, nil)
    }
}

