//
//  NoticeViewController.swift
//  Notice
//
//  Created by HwangByungJo  on 2022/06/17.
//

import UIKit

class NoticeViewController: UIViewController {
    
  @IBOutlet weak var noticeView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var datelabel: UILabel!
  
  var noticeContents: (title: String, detail: String, date: String)?
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    noticeView.layer.cornerRadius = 6
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    guard let noticeContents = noticeContents else {
      return
    }
    
    titleLabel.text = noticeContents.title
    detailLabel.text = noticeContents.detail
    datelabel.text = noticeContents.detail
  }
  
  @IBAction func doneButtonTapped(_ sender: UIButton) {
    self.dismiss(animated: true)
  }  
}
