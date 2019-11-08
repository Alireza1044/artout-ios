//
//  NewEventViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class NewEventViewController:UIViewController{
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    private var datePicker: UIDatePicker? = UIDatePicker()
    private var timePicker: UIDatePicker? = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatePickers()
    }
    
    func prepareDatePickers(){
        timePicker?.datePickerMode = .time
        timePicker?.minuteInterval = 15
        datePicker?.datePickerMode = .date
        
        timePicker?.addTarget(self, action: #selector(NewEventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
         datePicker?.addTarget(self, action: #selector(NewEventViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        startDateTextField.inputView = datePicker
        endDateTextField.inputView = datePicker
        startTimeTextField.inputView = timePicker
        endTimeTextField.inputView = timePicker

        let toolBar = UIToolbar().ToolbarPicker(mySelect: #selector(NewEventViewController.dismissPicker))
        
        startDateTextField.inputAccessoryView = toolBar
        endDateTextField.inputAccessoryView = toolBar
        startTimeTextField.inputAccessoryView = toolBar
        endTimeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        if (datePicker.datePickerMode == .date){
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        else if (datePicker.datePickerMode == .time){
            dateFormatter.dateFormat = "HH:mm"
        }
        if(startDateTextField.isEditing){
            startDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        else if(endDateTextField.isEditing){
            endDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        else if(startTimeTextField.isEditing){
            startTimeTextField.text = dateFormatter.string(from: datePicker.date)
        }
        else if(endTimeTextField.isEditing){
            endTimeTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}


extension UIToolbar {
    
    func ToolbarPicker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
