//
//  NewEventViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class NewEventViewController:UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var datePicker: UIDatePicker? = UIDatePicker()
    private var timePicker: UIDatePicker? = UIDatePicker()
    
    var newEventViewModel = NewEventViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatePickers()
        prepareTextView()
        prepareBindings()
        self.activityIndicatorView.isHidden = true
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        newEventViewModel.AddEvent()
    }
    
    func prepareBindings(){
        _ = titleTextField.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.titleText)
        _ = startDateTextField.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.startDateText)
        _ = endDateTextField.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.endDateText)
        _ = startTimeTextField.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.startTimeText)
        _ = endTimeTextField.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.endTimeText)
        _ = descriptionTextView.rx.text.map{ $0 ?? ""}.bind(to: newEventViewModel.descriptionText)
        _ = categoryTextField.rx.text.map{$0 ?? ""}.bind(to: newEventViewModel.categoryText)
        
        Observable.combineLatest(newEventViewModel.isEmpty,newEventViewModel.descriptionIsEmpty).map{ !$0 && $1}.subscribe{
            self.doneButton.isEnabled = $0.element!
        }.disposed(by: disposeBag)
    }
    
    func prepareTextView(){
        descriptionTextView.layer.borderWidth = 0.2
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.delegate = self
        descriptionTextView.text = "Write a description..."
        descriptionTextView.textColor = UIColor.systemGray3
        
        descriptionTextView.selectedTextRange = descriptionTextView.textRange(from: descriptionTextView.beginningOfDocument, to: descriptionTextView.beginningOfDocument)
        
        newEventViewModel.isLoading.subscribe({ loading in
            switch (loading){
            case .next(true):
                self.activityIndicatorView.startAnimating()
                self.activityIndicatorView.isHidden = false
            case .next(false):
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            case .error(_):
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            case .completed:
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        _ = newEventViewModel.addEventStatus.subscribe({ status in
            switch(status){
            case .next(true):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .next(false):
                print("fuck")
            default:
                print("shit")
            }
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Write a description..."
            textView.textColor = UIColor.systemGray3
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            if(traitCollection.userInterfaceStyle == .dark){
                textView.textColor = UIColor.white
            } else if (traitCollection.userInterfaceStyle == .light){
                textView.textColor = UIColor.black
            }
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.systemGray3 {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func prepareDatePickers(){
        timePicker?.datePickerMode = .time
        timePicker?.minuteInterval = 15
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date()
        
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
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
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
