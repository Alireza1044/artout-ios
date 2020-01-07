//
//  TimelineDetailViewController.swift
//  Artout
//
//  Created by Alireza Moradi on 1/5/20.
//  Copyright © 2020 Pooya Kabiri. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimelineDetailViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
            default:
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
}
