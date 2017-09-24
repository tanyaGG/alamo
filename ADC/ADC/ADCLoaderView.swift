//
//  LoaderView.swift
//  ADC
//
//  Created by TANYA GYGI on 9/23/17.
//  Copyright © 2017 TANYA GYGI. All rights reserved.
//

import UIKit

class ADCLoaderView: UIView {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    class func instanceFromNib() -> ADCLoaderView {
        return UINib(nibName: "ADCLoaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ADCLoaderView
    }
    
    override func awakeFromNib(){
        setupView()
    }
    
    func setupView() {
        self.message.text = NSLocalizedString("Hold on tight.", comment: "loading message")
        self.activityIndicator.isHidden = false;
        self.alpha = 1.0
    }
    
    func showError() {
        self.message.text = NSLocalizedString("We couldn't find the resource.", comment: "error message")
        self.activityIndicator.isHidden = true;
    }
    
    func fade() {

        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
         },
         completion: { success in
            self.removeFromSuperview()
         })
        
    }
    
}
