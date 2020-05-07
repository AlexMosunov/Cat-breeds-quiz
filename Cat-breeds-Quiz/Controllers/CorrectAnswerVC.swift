//
//  CorrectAnswerVC.swift
//  Cat-breeds-Quiz
//
//  Created by Alex Mosunov on 02.05.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit
import WebKit

class CorrectAnswerVC: UIViewController, WKUIDelegate {

    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var catDescritptionLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var image: UIImage?
    var name: String?
    var temperamentText: String?
    var descriptionText: String?
    var webUrl: String?
    
    var webTapped = false
    
    var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let catImage = image,
            let nameLabel = name,
            let descrLabel = descriptionText,
            let temperament = temperamentText {
            
            catImageView.image = catImage
            catNameLabel.text = nameLabel
            catDescritptionLabel.text = descrLabel
            temperamentLabel.text = temperament
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        
    }

    
    @IBAction func moreInfoTapped(_ sender: UIBarButtonItem) {
        
 
        webView = WKWebView(frame: view.frame)
        
        view.addSubview(webView!)
        if let url = webUrl {
            
            let myURL = URL(string: url)!
            let request = URLRequest(url: myURL)
            webView!.load(request)
        }
        
        
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

