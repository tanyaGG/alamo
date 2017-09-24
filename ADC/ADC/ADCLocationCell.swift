//
//  LocationCell.swift
//  
//
//  Created by TANYA GYGI on 9/22/17.
//
//

import UIKit

class ADCLocationCell: UITableViewCell {

    static let cellIdentifier : String = "locationCell"
    @IBOutlet weak var addressLabel: UILabel!
    
    static var nib : UINib = {
        return UINib(nibName: "ADCLocationCell", bundle: Bundle(for: ADCLocationCell.self))
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.addressLabel.text = ""
    }
    
    func setup(withLocation location: ADCLocation) {
        self.addressLabel.text = location.address
    }
    
}
