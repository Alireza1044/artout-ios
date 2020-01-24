//
//  NewEventViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 11/8/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import Foundation
import RxSwift

class NewEventViewController:UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var newEventImage: UIImageView!
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
    
    var viewModel = NewEventViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newEventImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        newEventImage.addGestureRecognizer(tapGestureRecognizer)
        newEventImage.layer.cornerRadius = 6
        prepareDatePickers()
        prepareTextView()
        prepareBindings()
        self.activityIndicatorView.isHidden = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        // Your action
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message:
                    "Camera not found!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        newEventImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        viewModel.AddEvent()
    }
    
    func prepareBindings(){
        _ = titleTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.titleText)
        _ = startDateTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.startDateText)
        _ = endDateTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.endDateText)
        _ = startTimeTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.startTimeText)
        _ = endTimeTextField.rx.text.map{ $0 ?? ""}.bind(to: viewModel.endTimeText)
        _ = descriptionTextView.rx.text.map{ $0 ?? ""}.bind(to: viewModel.descriptionText)
        _ = categoryTextField.rx.text.map{$0 ?? ""}.bind(to: viewModel.categoryText)
        
        Observable.combineLatest(viewModel.isEmpty,viewModel.descriptionIsEmpty).map{ !$0 && $1}.subscribe{
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
        
        _ = viewModel.addEventStatus.subscribe({ status in
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
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        

        if updatedText.isEmpty {
            
            textView.text = "Write a description..."
            textView.textColor = UIColor.systemGray3
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
        else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            if(traitCollection.userInterfaceStyle == .dark){
                textView.textColor = UIColor.white
            } else if (traitCollection.userInterfaceStyle == .light){
                textView.textColor = UIColor.black
            }
            textView.text = text
        }

        else {
            return true
        }
        

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
