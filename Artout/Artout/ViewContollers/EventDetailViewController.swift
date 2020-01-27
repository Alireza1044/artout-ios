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
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var checkinListButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func checkinListButtonAction(_ sender: Any) {
        let s = UIStoryboard(name: "Events", bundle: nil)
        let vc = s.instantiateViewController(identifier: "CheckinUserListTable") as? CheckinUserTableViewController
        vc?.eventId = self.eventId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
//    @IBAction func checkinListButtonAction(_ sender: Any) {
//        
//    }
    var startDate = ""
    var endDate = ""
    var eventDetailViewModel = EventDetailViewModel()
    var disposeBag = DisposeBag()
    var eventId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                if let checkinCount = event.element?.CheckinCount {
                    self.checkinListButton.setTitle("\(checkinCount) People have Checked-In", for: .normal)
                }
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
            editEventVC.startTimeText = editEventVC.convertTime(time: self.startDate)
            editEventVC.endTimeText = editEventVC.convertTime(time: self.endDate)
            editEventVC.categoryText = self.categoryLabel.text!
        }
    }
}
