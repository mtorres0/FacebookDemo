//
//  LoginHeaderView.swift
//  FacebookPirata
//
//  Created by Vanessa on 07/11/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {

    override func awakeFromNib() {
        layer.shadowColor = SHADOW_COLOR.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 1.0
    }
}
