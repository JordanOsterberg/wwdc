//
//  CoinCounterViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit
import SpriteKit
import PlaygroundSupport

/// Displays the player's current items
/// Also handles animations and sound when items are collected
public class ItemOverlayViewController: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = .layerMaxXMaxYCorner
        }
        view.layer.cornerRadius = 25
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = UIStackView.Alignment.center
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        return stackView
    }()
    
    var fragmentOneView: UIImageView?
    var fragmentTwoView: UIImageView?
    var fragmentThreeView: UIImageView?
    var carrotView: UIImageView?
    
    let animatableItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override public func viewDidLoad() {
        self.view.addSubview(self.backgroundView)
        
        self.backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.backgroundView.setHeight(equalTo: 160)
        self.backgroundView.setWidth(equalTo: 270)
        
        self.backgroundView.addSubview(self.stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 10).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -10).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 10).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -10).isActive = true
        
        self.animatableItemImageView.alpha = 0
        self.view.addSubview(self.animatableItemImageView)
        
        self.animatableItemImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        self.animatableItemImageView.centerHorizontally(in: self.view)
        
        self.setupStackView()
    }
    
    func setupStackView() {
        for x in 0...3 {
            let imageView = UIImageView()
            imageView.alpha = 0.3
            imageView.contentMode = .scaleAspectFit
            
            if x == 0 {
                imageView.image = UIImage(named: "CarrotLarge")
                self.carrotView = imageView
            } else if x == 1 {
                imageView.image = UIImage(named: "TicketFragment1")
                self.fragmentOneView = imageView
            } else if x == 2 {
                imageView.image = UIImage(named: "TicketFragment2")
                self.fragmentTwoView = imageView
            } else if x == 3 {
                imageView.image = UIImage(named: "TicketFragment3")
                self.fragmentThreeView = imageView
            }
            
            self.stackView.addArrangedSubview(imageView)
        }
    }
    
}

extension ItemOverlayViewController: ItemCollectionDelegate {
    
    func didCollect(item: Item, on scene: SKScene?) {
        let imageName: String
        let center: CGPoint
        let view: UIView?
        
        switch item {
        case .carrot:
            imageName = "CarrotLarge"
            center = self.carrotView?.center ?? self.view.center
            view = self.carrotView
            break
        case .ticketOne:
            imageName = "TicketFragment1"
            center = self.fragmentOneView?.center ?? self.view.center
            view = self.fragmentOneView
            break
        case .ticketTwo:
            imageName = "TicketFragment2"
            center = self.fragmentTwoView?.center ?? self.view.center
            view = self.fragmentTwoView
            break
        case .ticketThree:
            imageName = "TicketFragment3"
            center = self.fragmentThreeView?.center ?? self.view.center
            view = self.fragmentThreeView
            break
        }
        
        self.animatableItemImageView.image = UIImage(named: imageName)
        
        self.animatableItemImageView.transform = self.animatableItemImageView.transform.translatedBy(x: 0, y: -450)
        self.animatableItemImageView.transform = self.animatableItemImageView.transform.scaledBy(x: 0.4, y: 0.4)
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            self.animatableItemImageView.alpha = 1
            self.animatableItemImageView.transform = .identity
        }) { _ in
            
            UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseInOut, animations: {
                self.animatableItemImageView.center = center
                self.animatableItemImageView.transform = self.animatableItemImageView.transform.scaledBy(x: 0.48, y: 0.48)
            }, completion: { _ in
                self.animatableItemImageView.alpha = 0
                self.animatableItemImageView.center = self.view.center
            })
            
            UIView.animate(withDuration: 0.3, delay: 1.5, animations: {
                self.animatableItemImageView.alpha = 0
                view?.alpha = 1
            }, completion: nil)
        }
    }
    
    func reset() {
        self.stackView.arrangedSubviews.forEach(self.stackView.removeArrangedSubview)
        
        self.fragmentOneView?.removeFromSuperview()
        self.fragmentTwoView?.removeFromSuperview()
        self.fragmentThreeView?.removeFromSuperview()
        self.carrotView?.removeFromSuperview()
        
        self.fragmentOneView = nil
        self.fragmentTwoView = nil
        self.fragmentThreeView = nil
        self.carrotView = nil
        
        self.setupStackView()
    }
    
}
