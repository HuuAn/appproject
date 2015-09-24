//
//  ViewController.swift
//  Multibrowser-31
//
//  Created by Test on 29.08.15.
//  Copyright © 2015 Test. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    //class ViewController: UIViewController {

    
    @IBOutlet weak var addressBar: UITextField!

    @IBOutlet weak var stackView: UIStackView!
    
    
    weak var activeWebView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addWebView")
        let delete = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteWebView")
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func addWebView() {
        let webView = UIWebView()
        webView.delegate = self
        
        stackView.addArrangedSubview(webView)
        //only work with https!
        let url = NSURL(string: "https://www.google.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.layer.borderColor = UIColor.blueColor().CGColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: "webViewTapped:")
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
    }
    
    func selectWebView(webView: UIWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        updateUIUsingWebView(webView)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let webView = activeWebView, address = addressBar.text {
            if let url = NSURL(string: address) {
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }

    
    func webViewTapped(recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? UIWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func deleteWebView() {
        // safely unwrap our webview
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.indexOf(webView) {
                // we found the current webview in the stack view! Remove it from the stack view
                stackView.removeArrangedSubview(webView)
                
                // now remove it from the view hierarchy – this is important!
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    // go back to our default UI
                    setDefaultTitle()
                } else {
                    // convert the Index value into an integer
                    var currentIndex = Int(index)
                    
                    // if that was the last web view in the stack, go back one
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    // find the web view at the new index and select it
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? UIWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    func updateUIUsingWebView(webView: UIWebView) {
        title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        addressBar.text = webView.request?.URL?.absoluteString ?? ""
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView == activeWebView {
            updateUIUsingWebView(webView)
        }
    }
    
    //mulitasking
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.horizontalSizeClass == .Compact {
            stackView.axis = .Vertical
        } else {
            stackView.axis = .Horizontal
        }
    }

}

