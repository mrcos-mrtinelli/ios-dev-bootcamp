//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration.init())
    
    let swifter = Swifter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sentiment = try! sentimentClassifier.prediction(text: "I love you!")
        
        print(sentiment.label)
        
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
            print("results: \(results)")
            print("metadata: \(metadata)")
            
        } failure: { (error) in
            print("error: \(error)")
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

