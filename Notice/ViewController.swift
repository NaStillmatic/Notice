//
//  ViewController.swift
//  Notice
//
//  Created by HwangByungJo  on 2022/06/15.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {

  var remoteContig: RemoteConfig?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    remoteContig = RemoteConfig.remoteConfig()
    let setting = RemoteConfigSettings()
    setting.minimumFetchInterval = 0
    remoteContig?.configSettings = setting
    
    remoteContig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getNotice()
  }
}

// RemoteConfig
extension ViewController {
  
  func getNotice() {
    guard let remoteConfig = remoteContig else { return }
    
    remoteConfig.fetch { [weak self] status, _ in
      if status == .success {
        remoteConfig.activate(completion: nil)
      } else {
        print("Error: Cinfig not fetched")
      }
      
      guard let self = self else { return }
      
      if !self.isNoticeHidden(remoteConfig) {
        let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
        
        noticeVC.modalPresentationStyle = .custom
        noticeVC.modalTransitionStyle = .crossDissolve
        
        let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
        let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
        let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
        
        noticeVC.noticeContents = (title: title, detail: detail, date: date)
        self.present(noticeVC, animated: true)
      } else {
    
        self.showEventAlert()
      }
    }
  }
  
  func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
    return remoteConfig["isHidden"].boolValue
  }
}


// A/B Testing
extension ViewController {
  
  func showEventAlert() {
    guard let remoteConfig = remoteContig else { return }
    
    remoteConfig.fetch { [weak self] status, _ in
      
      if status == .success {
        remoteConfig.activate(completion: nil)
      } else {
        print("Config not fetched")
      }
      
      let message = remoteConfig["message"].stringValue ?? ""
      let confirmAction = UIAlertAction(title: "확인하기", style: .default) { _ in
        // Googl Analytics
        Analytics.logEvent("promotion_alert", parameters: nil)
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel)
      
      let alertController = UIAlertController(title: "이벤트", message: message, preferredStyle: .alert)
      alertController.addAction(confirmAction)
      alertController.addAction(cancelAction)
      self?.present(alertController, animated: true)
    }
  }
  
}
