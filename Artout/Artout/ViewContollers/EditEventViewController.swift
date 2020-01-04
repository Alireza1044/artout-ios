//
//  EditEventViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 11/26/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EditEventViewController:UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var datePicker: UIDatePicker? = UIDatePicker()
    private var timePicker: UIDatePicker? = UIDatePicker()
    
    var titleText = ""
    var categoryText = ""
    var descriptionText = ""
    var startDateText = ""
    var endDateText = ""
    var startTimeText = ""
    var endTimeText = ""

    
    var eventId = 0
    
    var disposeBag = DisposeBag()
    var viewModel = EditEventViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatePickers()
        prepareTextView()
        
        titleTextField.text = titleText
        categoryTextField.text = categoryText
        _ = self.textView(self.descriptionTextView, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: descriptionText)
        startDateTextField.text = startDateText
        endDateTextField.text = endDateText
        startTimeTextField.text = startTimeText
        endTimeTextField.text = endTimeText
        
        _ = titleTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.titleText)
        _ = startDateTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.startDateText)
        _ = endDateTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.endDateText)
        _ = descriptionTextView.rx.text.map{ $0 ?? ""}.bind(to: viewModel.descriptionText)
        _ = categoryTextField.rx.text.map{$0 ?? ""}.bind(to: viewModel.categoryText)
        _ = startTimeTextField.rx.text.map{$0 ?? ""}.bind(to: viewModel.startTimeText)
        _ = endTimeTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.endTimeText)
        
        self.activityIndicatorView.isHidden = true
        
        var a = Observable.combineLatest(titleTextField.rx.text.asObservable(),
                                 descriptionTextView.rx.text.asObservable(),
                                 categoryTextField.rx.text.asObservable(),
                                 startDateTextField.rx.text.asObservable(),
                                 endDateTextField.rx.text.asObservable()).map{ $0 != self.titleText ||
                                    $1 != self.descriptionText ||
                                    $2 != self.categoryText ||
                                    $3 != self.startDateText ||
                                    $4 != self.endDateText
        }
        
        var b = Observable.combineLatest(startTimeTextField.rx.text.asObservable(),
                                 endTimeTextField.rx.text.asObservable()).map{ $0 != self.startTimeText ||
                                    $1 != self.endTimeText
        }
        
        Observable.combineLatest(a.asObservable(),
                                 b.asObservable()).map{ $0 || $1}.subscribe{
            self.doneButton.isEnabled = $0.element!
            }.disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe({ loading in
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
        
        self.viewModel.addEventStatus.subscribe {
            switch($0){
            case .next(true):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .next(false):
                let alertController = UIAlertController(title: "Edit Failed", message: "Could not edit event"
                    , preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        viewModel.EditEvent(id: self.eventId)
    }
    
    func convertDate(date: String) -> String{
        if !date.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let adate = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                return dateFormatter.string(from: adate)
            }
        }
        return ""
    }
    
    func convertTime(time: String) -> String{
        if !time.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let adate = dateFormatter.date(from: time) {
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: adate)
            }
        }
        return ""
    }
    
    func prepareTextView(){
        descriptionTextView.layer.borderWidth = 0.2
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.delegate = self
        descriptionTextView.text = "Write a description..."
        descriptionTextView.textColor = UIColor.systemGray3
        
        descriptionTextView.selectedTextRange = descriptionTextView.textRange(from: descriptionTextView.beginningOfDocument, to: descriptionTextView.beginningOfDocument)
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
