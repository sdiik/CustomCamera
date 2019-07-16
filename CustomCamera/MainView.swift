//
//  MainView.swift
//  CustomCamera
//
//  Created by ahmad shiddiq on 14/07/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import Foundation
import UIKit

protocol mainView {
    func setupView()
    func setupAction()
}

extension UIColor{
     static func zrgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

