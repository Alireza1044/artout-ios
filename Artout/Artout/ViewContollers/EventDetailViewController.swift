//
//  EventDetailViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 11/10/19.
//  Copyright © 2019 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventDetailViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var categoryLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var startDate = ""
    var endDate = ""
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.layer.borderColor = UIColor.darkGray.cgColor
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.cornerRadius = 4
        //        titleLabel.layer.masksToBounds = true
        
        
        dateLabel.layer.borderColor = UIColor.darkGray.cgColor
        dateLabel.layer.borderWidth = 1
        dateLabel.layer.cornerRadius = 4
        //        dateLabel.layer.masksToBounds = true
        
        categoryLabel.layer.borderColor = UIColor.darkGray.cgColor
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.cornerRadius = 4
        //        categoryLabel.layer.masksToBounds = true
        
        self.descriptionTextView.textContainerInset = .init(top: 2, left: 4, bottom: 0, right: 4)
        
        descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 4
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        eventDetailViewModel.isLoading.subscribe {
            switch($0){
            case .next(true):
                self.editButton.isEnabled = false
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
            default:
                self.editButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        eventDetailViewModel.RequestEventDetail(id: eventId)
        
        self.eventDetailViewModel.event.subscribe { event in
            DispatchQueue.main.async {
                self.titleLabel.text = event.element!.Title
                self.categoryLabel.text = event.element!.Category
                self.startDate = event.element!.StartDate
                self.endDate = event.element!.EndDate
                self.dateLabel.text = "From: \(self.startDate) To: \(self.endDate)"
                self.descriptionTextView.text = event.element!.Description
            }
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEventSegue" {
            let editEventVC = segue.destination as! EditEventViewController
            editEventVC.eventId = self.eventId
            editEventVC.titleText = self.titleLabel.text!
            editEventVC.descriptionText = self.descriptionTextView.text
            editEventVC.startDateText = editEventVC.convertDate(date: self.startDate)
            editEventVC.endDateText = editEventVC.convertDate(date: self.endDate)
            editEventVC.categoryText = self.categoryLabel.text!
        }
    }
}

class CustomLabel: UILabel{
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 2, left: 4, bottom: 2, right: 4)))
    }
}
