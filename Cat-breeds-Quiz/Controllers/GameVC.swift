//
//  ViewController.swift
//  Cat-breeds-Quiz
//
//  Created by Alex Mosunov on 02.05.2020.
//  Copyright © 2020 Alex Mosunov. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    let dataManager = DataManager()
    var spinnerView: UIView?
    
    var arrayOfBreeds: [BreedModel] = []
    var arrayOfBreedNames: [String] = []
    var num = 0
    var score = 0
    var correctAnswer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        dataManager.performRequest()
        
        self.navigationItem.title = "Score: \(score)"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        answerButton1.layer.cornerRadius = answerButton1.frame.height / 2
        answerButton2.layer.cornerRadius = answerButton2.frame.height / 2
        answerButton3.layer.cornerRadius = answerButton3.frame.height / 2
        answerButton4.layer.cornerRadius = answerButton4.frame.height / 2
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
        
        self.activityIndicator(isEnabled: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameToCorrectAnswer" {
            let destinationVC = segue.destination as! CorrectAnswerVC
            
            destinationVC.image = self.setImage(from: self.arrayOfBreeds[self.num].url)
            destinationVC.descriptionText = arrayOfBreeds[num].description
            destinationVC.name = arrayOfBreeds[num].name
            destinationVC.temperamentText = arrayOfBreeds[num].temperament
            destinationVC.webUrl = arrayOfBreeds[num].wikipedia_url
            
        }
    }
    
    
    @IBAction func answerButtonIsTapped(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!
        let answeredCorrectly = checkAnswer(userAnswer)
        
        if answeredCorrectly {
            
            performSegue(withIdentifier: "GameToCorrectAnswer", sender: self)
            num += 1
            score += 1
            updateUI()
            
        } else {
            sender.alpha = 0.0
        }
    }
    
    
    func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == arrayOfBreeds[num].name {
            return true
        } else {
            return false
        }
    }
    
    func setImage(from url: String) -> UIImage? {
        guard let imageURL = URL(string: url) else { return nil }
        guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
        let image = UIImage(data: imageData)
        return image
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.catImage.image = self.setImage(from: self.arrayOfBreeds[self.num].url)
        }
        updateGame(correctAnswer: arrayOfBreeds[num].name)
        
        answerButton1.alpha = 1.0
        answerButton2.alpha = 1.0
        answerButton3.alpha = 1.0
        answerButton4.alpha = 1.0
        
        self.navigationItem.title = "Score: \(score)"
    }
    
    func updateGame(correctAnswer: String) {
        
        let randomName1 = (0..<arrayOfBreedNames.count).randomElement()!
        let randomName2 = (0..<arrayOfBreedNames.count).randomElement()!
        let randomName3 = (0..<arrayOfBreedNames.count).randomElement()!
        let answerChoices = [arrayOfBreedNames[randomName1], arrayOfBreedNames[randomName2], arrayOfBreedNames[randomName3], correctAnswer].shuffled()
        
        DispatchQueue.main.async {
            self.answerButton1.setTitle(answerChoices[0], for: .normal)
            self.answerButton2.setTitle(answerChoices[1], for: .normal)
            self.answerButton3.setTitle(answerChoices[2], for: .normal)
            self.answerButton4.setTitle(answerChoices[3], for: .normal)
            
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.answerButton3.isEnabled = true
            self.answerButton4.isEnabled = true
            
        }
    }
    
    
    // func to show or hide activity indicator
    func activityIndicator(isEnabled: Bool) {
        if isEnabled {
            spinnerView = UIView(frame: self.view.bounds)
            spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView(style: .large)
            ai.center = spinnerView!.center
            spinnerView?.addSubview(ai)
            self.view.addSubview(spinnerView!)
            ai.startAnimating()
        } else {
            spinnerView?.removeFromSuperview()
            spinnerView = nil
        }
    }
    
}

//MARK: - DataManagerDelegate

extension GameVC: DataManagerDelegate {
    
    func didReceiveBreedNames(breedNames: [String]) {
        arrayOfBreedNames = breedNames
    }
    
    
    func didReceiveBreedsData(breed: BreedModel) {
        
        DispatchQueue.main.async {
            
            self.arrayOfBreeds.append(breed)
            DispatchQueue.main.async {
                self.catImage.image = self.setImage(from: self.arrayOfBreeds[self.num].url)
            }
            self.correctAnswer = self.arrayOfBreeds[self.num].name
            self.updateGame(correctAnswer: self.arrayOfBreeds[self.num].name)
            self.activityIndicator(isEnabled: false)
            
        }
        
    }
    
}

