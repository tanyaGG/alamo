//
//  ADCLocationMapController.swift
//  ADC
//
//  Created by TANYA GYGI on 9/22/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import Foundation
import UIKit

class ADCLocationMapController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var location : ADCLocation!
    let loaderView = ADCLoaderView.instanceFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Details", comment: "map screen title")
        
        if location != nil {
            if let url = URL(string: location.mapUrl) {
                self.addLoader()
                webView.loadRequest(URLRequest(url: url))
            }
        
            self.addressLabel.text = location.address
        }
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
        //remove white space a the top
        self.webView.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func addLoader () {
        self.view.addSubview(self.loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self.loaderView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self.topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.loaderView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self.addressLabel,
                                              attribute:.top,
                                              multiplier: 1,
                                              constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: self.loaderView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self.loaderView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .trailing,
                                              multiplier: 1, constant: 0))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loaderView.fade()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loaderView.showError()
    }

}

