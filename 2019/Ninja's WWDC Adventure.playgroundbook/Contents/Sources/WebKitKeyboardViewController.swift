//
//  WebKitKeyboardViewController.swift
//  WWDC19
//
//  Created by Jordan Osterberg on 3/14/19.
//  Copyright © 2019 Jordan Osterberg. All rights reserved.
//

import UIKit
import WebKit

// This doesn't seem to work in Playgrounds for some reason... maybe it's a focus issue? Who knows. I certianly don't 😅

class WebKitKeyboardViewController: UIViewController {
    
    let webView: WKWebView = {
        let view = WKWebView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let controlInteractionDelegate: ControlInteractionDelegate
    
    init(controlInteractionDelegate: ControlInteractionDelegate) {
        self.controlInteractionDelegate = controlInteractionDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.addSubview(self.webView)
        
        self.webView.configuration.userContentController.add(self, name: "jsHandler")
        
        if let bundleUrl = Bundle.main.resourceURL?.absoluteURL {
            let file = bundleUrl.appendingPathComponent("keyboardControls.html")
            webView.loadFileURL(file, allowingReadAccessTo: bundleUrl)
        }
        
        self.webView.becomeFirstResponder()
    }
    
}

extension WebKitKeyboardViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "jsHandler", let body = message.body as? String else {
            return
        }
        
        if body == "rightKeyDown" {
            self.controlInteractionDelegate.didMoveControl(in: .right)
        } else if body == "leftKeyDown" {
            self.controlInteractionDelegate.didMoveControl(in: .left)
        } else if body == "spaceKeyDown" {
            self.controlInteractionDelegate.didJump()
        } else if body == "leftKeyUp" || body == "rightKeyUp" {
            self.controlInteractionDelegate.didReleaseControl()
        }
    }
    
}
