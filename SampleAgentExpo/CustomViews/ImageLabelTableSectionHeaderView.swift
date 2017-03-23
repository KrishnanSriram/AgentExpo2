//
//  ImageLabelTableSectionHeaderView.swift
//  SampleAgentExpo
//
//  Created by Sriram, Krishnan on 3/22/17.
//  Copyright © 2017 Sriram, Krishnan. All rights reserved.
//

import UIKit

class ImageLabelTableSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override var contentView: UIView {
//        get {
//            return self.subviews[0]
//        }
//    }

}
