//
//  AddEventViewController.swift
//  eventPlanner
//
//  Created by Rich Ruais on 7/25/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    var timeFormatter = DateFormatter()
    var eventPrice: String!
    var selectedDate: String!
    var selectedImageFromPicker: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTxtField.delegate = self
        eventImageView.image = #imageLiteral(resourceName: "emptyPhoto")
        errorLabel.isHidden = true
        setDateAndTime()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let price = NSDecimalNumber(string: self.priceTxtField.text) as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.string(from: price)
        eventPrice = formatter.string(from: price)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceTxtField.resignFirstResponder()
        return true
    }
    
    @IBAction func dateChangedAction(_ sender: UIDatePicker) {
        setDateAndTime()
    }
    
    func setDateAndTime() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        timeFormatter.timeStyle = DateFormatter.Style.short
        selectedDate = dateFormatter.string(from: dateTime.date) + " " + timeFormatter.string(from: dateTime.date)
    }
    
    @IBAction func addEventAction(_ sender: UIButton) {
        
        if (nameTxtField.text?.isEmpty)! || (addressTxtField.text?.isEmpty)! || (priceTxtField.text?.isEmpty)! {
            errorLabel.isHidden = false
        } else {
            let newEvent = Event.init(name: nameTxtField.text, image: selectedImageFromPicker, price: eventPrice, address: addressTxtField.text, dateTime: selectedDate, imageUrl: "empty", title: "empty")
            let ed = EventDatabase()
            ed.saveEvent(newEvent: newEvent)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Handle Image Picker
    @IBAction func selectPhotoAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            eventImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}

