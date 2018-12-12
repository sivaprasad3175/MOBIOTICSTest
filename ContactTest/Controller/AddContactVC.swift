//
//  AddContactVC.swift
//  ContactTest
//
//  Created by Raja on 12/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit
import Photos


protocol AddContactVCDelagte {
    func reloadTable()
}

class AddContactVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var tag = Int()
    var countryPickerList = [String]()
    var imagePicker = UIImagePickerController()
    var user : User?
    var delegate : AddContactVCDelagte?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataSet()
        assignDelegates()
        updateView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // upadte ui
    fileprivate func updateView(){
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.masksToBounds = true
        firstName.text = user?.firstName
        lastName.text = user?.lastName
        email.text = user?.emailId
        countryTxtField.text = user?.countryPicker
        if let numebr = user?.phoneNumber{
            phoneNumber.text = "\(numebr)"
        }
        if let image = user?.image{
            profileImage.image = (image as! UIImage)
        }
        if tag == 101{
            addBtn.setTitle("Update Contact", for: .normal)
            addBtn.tag = tag
            return
        }
        addBtn.setTitle("Add Contact", for: .normal)
        addBtn.tag = tag

    }

    //Mark:- APi call to get country code
    func getHttpData(completion:@escaping(CountryCode) -> ())   {
        guard let url = URL(string: "https://restcountries.eu/rest/v1/all") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(CountryCode.self, from: data)
                    completion(response)
                } catch {
                    print(error)
                }
                
            }
            }.resume()
    }
    
    // picker delagte methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryPickerList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryPickerList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryPicker.isHidden = true
        countryTxtField.text = countryPickerList[row]
    }

    //Mark:-textfiled delagte methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 201{
            countryPicker.isHidden = false
            return false
        }
        countryPicker.isHidden = true
        return true
    }
    
    fileprivate func prepareDataSet(){
        getHttpData { (response) in
            for name in response{
                self.countryPickerList.append(name.alpha2Code)
            }
            DispatchQueue.main.async {
                self.countryPicker.reloadAllComponents()
            }
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder()
        countryTxtField.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        email.resignFirstResponder()
    }
    fileprivate func assignDelegates(){
        countryTxtField.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        countryPicker.isHidden = true
        imagePicker.delegate = self
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
   
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have perission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        guard let name = firstName.text else {return}
        guard let lastName = lastName.text else {return}
        guard let email = email.text else {return}
        guard let phoneNumber = phoneNumber.text else {return}
        guard let image = profileImage.image else {return}
        guard let countryCode = countryTxtField.text else {return}
        
        if !email.isValidEmail{
            self.showToast(message: "Enter Proper Email")
            return
        }
        
        if !phoneNumber.isPhoneNumber{
            self.showToast(message: "Enter Proper PhoneNumber")
            return
        }
        if name.isEmptyAndContainsNoWhitespace() || lastName.isEmptyAndContainsNoWhitespace() || phoneNumber.isEmptyAndContainsNoWhitespace() || countryCode.isEmptyAndContainsNoWhitespace(){
            return
        }
        if user == nil {
            user = User(context: CoreDataHelper.shared.fetchedResultsController.managedObjectContext)
        }
        user?.firstName = name
        user?.lastName = lastName
        user?.image = image
        user?.phoneNumber = Int64(Int(phoneNumber) ?? 0)
        user?.emailId = email
        user?.countryPicker = countryCode
        if addBtn.tag == 101{
            CoreDataHelper.shared.updateData(user!)
        }
        CoreDataHelper.shared.saveData()
        delegate?.reloadTable()
        navigationController?.popViewController(animated: true)
    }
}


extension String {
    func isEmptyAndContainsNoWhitespace() -> Bool {
        guard self.isEmpty, self.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return false
        }
        return true
    }
}
