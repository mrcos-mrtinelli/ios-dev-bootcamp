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
    let tweetCount = 100
    
    let swifter = Swifter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    func fetchTweets() {
        guard let searchText = textField.text else { return }
        
        swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
            
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<self.tweetCount {
                if let tweet = results[i]["full_text"].string {
                    
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    
                    tweets.append(tweetForClassification)
                }
            }
            
            self.analyzeSentiment(tweets: tweets)
            
        } failure: { (error) in
            print("error: \(error)")
        }
    }
    func analyzeSentiment(tweets: [TweetSentimentClassifierInput]) {
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
            
            updateUI(score: sentimentScore)
            
        } catch {
            print("an error has occurred.")
        }
    }
    func updateUI(score: Int) {
        let negativeEmojis = ["🤨", "🤮", "🖕🏼"]
        let neutralEmojis = ["🤔", "😐", "😴"]
        let positiveEmojis = ["🤩", "🥰", "🥳"]
        
        if score > 0 {
            self.sentimentLabel.text = positiveEmojis.randomElement()
        } else if score < 0 {
            self.sentimentLabel.text = negativeEmojis.randomElement()
        } else {
            self.sentimentLabel.text = neutralEmojis.randomElement()
        }
    }
    
}

