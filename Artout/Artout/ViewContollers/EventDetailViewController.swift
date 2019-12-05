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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var startDate = ""
    var endDate = ""
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
