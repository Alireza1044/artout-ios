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

class OtherEventDetailViewController: UIViewController{
    
    @IBOutlet weak var checkMeInButton: UIButton!
    @IBOutlet weak var checkinListButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var startDate = ""
    var endDate = ""
    var eventDetailViewModel = EventDetailViewModel()
    var checkinViewModel = CheckinViewModel()
    var disposeBag = DisposeBag()
    var eventId = 0
    var IsCheckedIn: Bool = false
    
    @IBAction func checkinListAction(_ sender: Any) {
        
    }
    @IBAction func checkMeInAction(_ sender: Any) {
        switch self.IsCheckedIn {
            case false:
                self.checkMeInButton.setTitle("Already Checked-In", for: .normal)
                self.checkMeInButton.backgroundColor = .white
                self.checkMeInButton.setTitleColor(.systemBlue, for: .normal)
                self.checkMeInButton.layer.borderWidth = 3
                self.checkMeInButton.layer.borderColor = UIColor.systemBlue.cgColor
                checkinViewModel.Checkin(for: self.eventId)
                self.IsCheckedIn.toggle()
            default:
                self.checkMeInButton.setTitle("Check Me In !", for: .normal)
                self.checkMeInButton.backgroundColor = .systemBlue
                self.checkMeInButton.setTitleColor(.white, for: .normal)
                checkinViewModel.Checkout(for: self.eventId)
                self.IsCheckedIn.toggle()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetailViewModel.isLoading.subscribe {
            switch($0){
                case .next(true):
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                default:
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        eventDetailViewModel.RequestEventDetail(id: eventId)
        self.checkMeInButton.layer.cornerRadius = 6
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
                
                if let eventEntity = event.element {
                    self.IsCheckedIn = eventEntity.IsCheckedIn
                    if eventEntity.IsCheckedIn {
                        self.checkMeInButton.setTitle("Already Checked-In", for: .normal)
                        self.checkMeInButton.backgroundColor = .white
                        self.checkMeInButton.setTitleColor(.systemBlue, for: .normal)
                        self.checkMeInButton.layer.borderWidth = 3
                        self.checkMeInButton.layer.borderColor = UIColor.systemBlue.cgColor
                    } else {
                        self.checkMeInButton.setTitle("Check Me In !", for: .normal)
                        self.checkMeInButton.backgroundColor = .systemBlue
                        self.checkMeInButton.setTitleColor(.white, for: .normal)
                        
                    }
                }
                
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
        } else if segue.identifier == "CheckinUserListSegue" {
            let vc = segue.destination as! CheckinUserTableViewController
            vc.eventId = self.eventId
        }
    }
}
