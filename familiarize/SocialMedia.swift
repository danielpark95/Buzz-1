//
//  SocialMediaClass.swift
//  familiarize
//
//  Created by Alex Oh on 7/7/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMedia: NSObject {
    var imageName: String?
    var name: String?
    init(nameOfSocialMediaImage imageName: String,nameOfSocialMedia name: String) {
        self.imageName = imageName
        self.name = name
    }
}
