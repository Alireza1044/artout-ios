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
    override func viewDidLoad() {
    }
}
