//
//  PopupController.swift
//  familiarize
//
//  Created by Alex Oh on 6/3/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

// Popup -- https://www.youtube.com/watch?v=DmWv-JtQH4Q
// Color -- R: 214 - G: 237 - B: 255


import UIKit

class PopupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    let questionLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 2
        
        let attributedText = NSMutableAttributedString(string: "Would you like", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\nAdded 2 days ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popup-image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    func setupView() {
        view.addSubview(visualEffectView)
        view.addSubview(popupImageView)
        
        
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        popupImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        
        
    }
}
