//
//  LoginButton.swift
//  FacebookPirata
//
//  Created by Vanessa on 07/11/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    override func awakeFromNib() {
        layer.backgroundColor = UIColor(red: 213/255, green: 78/255, blue: 55/255, alpha: 1).cgColor
        layer.cornerRadius = 5
        layer.shadowColor = SHADOW_COLOR.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        tintColor = UIColor.white
    }

}
