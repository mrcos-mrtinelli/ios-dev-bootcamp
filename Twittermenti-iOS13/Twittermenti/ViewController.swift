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
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration.init())
    
    let swifter = Swifter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        guard let searchText = textField.text else { return }
        
        let negativeEmojis = ["🤨", "🤮", "🖕🏼"]
        let neutralEmojis = ["🤔", "😐", "😴"]
        let positiveEmojis = ["🤩", "🥰", "🥳"]
        
        swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
            
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    
                    tweets.append(tweetForClassification)
                }
            }
            
            do {
                let sentiments = try self.sentimentClassifier.predictions(inputs: tweets)
                var sentimentScore = 0
                
                for s in sentiments {
                    if s.label == "Pos" {
                        sentimentScore += 1
                    } else if s.label == "Neg" {
                        sentimentScore -= 1
                    }
                }
                
                if sentimentScore > 0 {
                    self.sentimentLabel.text = positiveEmojis.randomElement()
                } else if sentimentScore < 0 {
                    self.sentimentLabel.text = negativeEmojis.randomElement()
                } else {
                    self.sentimentLabel.text = neutralEmojis.randomElement()
                }
                
            } catch {
                print("an error has occurred.")
            }
            
        } failure: { (error) in
            print("error: \(error)")
        }
        
    }
    
}

