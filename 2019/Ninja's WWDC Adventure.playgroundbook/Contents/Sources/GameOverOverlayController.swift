//
//  GameOverOverlayController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/18/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit

class GameOverOverlayController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Congratulations!"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You got Ninja to WWDC19!"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = UIStackView.Alignment.center
        stackView.distribution = .fillEqually
        stackView.spacing = 100.0
        return stackView
    }()
    
    let moreInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thank you so much for checking out my WWDC19 Scholarship Submission!"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let playAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play Again", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    let onTime: Bool
    let carrotFed: Bool
    
    let playAgainCompletionHandler: (() -> Void)
    
    init(onTime: Bool = false, carrotFed: Bool = false, playAgainCompletionHandler: @escaping (() -> Void)) {
        self.onTime = onTime
        self.carrotFed = carrotFed
        self.playAgainCompletionHandler = playAgainCompletionHandler
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.accessibilityViewIsModal = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subtitleLabel)
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.moreInfoLabel)
        self.view.addSubview(self.playAgainButton)
        
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
       
        self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.subtitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        self.subtitleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
        
        self.stackView.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.moreInfoLabel.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        self.moreInfoLabel.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        self.moreInfoLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 50).isActive = true
        
        self.playAgainButton.topAnchor.constraint(equalTo: self.moreInfoLabel.bottomAnchor, constant: 25).isActive = true
        self.playAgainButton.centerXAnchor.constraint(equalTo: self.moreInfoLabel.centerXAnchor).isActive = true
        self.playAgainButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.playAgainButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.playAgainButton.addTarget(self, action: #selector(didTapPlayAgainButton), for: .touchUpInside)
        
        for x in 0...2 {
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.spacing = 10
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.alpha = 0.5
            imageView.contentMode = .scaleAspectFit
            imageView.setHeight(equalTo: 150)
            imageView.setWidth(equalTo: 150)
            imageView.accessibilityElementsHidden = true
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.textAlignment = .center
            
            if x == 0 {
                imageView.image = UIImage(named: "TicketSuccessIcon")
                imageView.alpha = 1
                label.text = "You retrieved all of the ticket pieces!"
            } else if x == 1 {
                imageView.image = UIImage(named: "TimerSuccessIcon")
                
                if self.onTime {
                    label.text = "You made it to WWDC on time!"
                    imageView.alpha = 1.0
                } else {
                    label.text = "You didn't make it to WWDC on time."
                }
            } else if x == 2 {
                imageView.image = UIImage(named: "CarrotSuccessIcon")
                
                if self.carrotFed {
                    label.text = "You fed Forester a carrot!"
                    imageView.alpha = 1.0
                } else {
                    label.text = "You didn't feed Forester a carrot."
                }
            }
            
            subStackView.addArrangedSubview(imageView)
            subStackView.addArrangedSubview(label)
            
            self.stackView.addArrangedSubview(subStackView)
        }
    }
    
    @objc func didTapPlayAgainButton() {
        self.dismiss(animated: true, completion: nil)
        self.playAgainCompletionHandler()
    }
    
}
