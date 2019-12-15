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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var startDate: CustomLabel!
    @IBOutlet weak var endDate: CustomLabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var startDateStr = ""
    var endDateStr = ""
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        titleLabel.layer.masksToBounds = true
        
        
        startDate.layer.borderColor = UIColor.darkGray.cgColor
        startDate.layer.borderWidth = 1
        startDate.layer.cornerRadius = 4
        //        dateLabel.layer.masksToBounds = true
        
        endDate.layer.borderColor = UIColor.darkGray.cgColor
        endDate.layer.borderWidth = 1
        endDate.layer.cornerRadius = 4
        
        
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
                self.startDate.text = event.element!.StartDate
                self.endDate.text = event.element!.EndDate
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
            editEventVC.startDateText = editEventVC.convertDate(date: self.startDate.text!)
            editEventVC.endDateText = editEventVC.convertDate(date: self.endDate.text!)
            editEventVC.categoryText = self.categoryLabel.text!
        }
    }
}

class CustomLabel: UILabel{
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 2, left: 4, bottom: 2, right: 4)))
    }
}
