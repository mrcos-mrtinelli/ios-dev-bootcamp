//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email,
           let messageBody = messageTextfield.text {
            
            db.collection(K.FStore.collectionName).addDocument(
                data:[
                    K.FStore.senderField: messageSender,
                    K.FStore.dateField: Date().timeIntervalSince1970,
                    K.FStore.bodyField: messageBody
                ]) { (e) in
                if let error = e {
                    print("There was an error saving: \(error)")
                } else {
                    print("Message saved.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("There was an error getting documents: \(error)")
                } else {
                    guard let snapshotDocuments = snapshot else { return }
                    
                    self.messages.removeAll(keepingCapacity: true)
                    
                    for doc in snapshotDocuments.documents {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageDate = data[K.FStore.dateField] as? TimeInterval,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            self.messages.append(Message(sender: messageSender, date: messageDate, body: messageBody))
                        }
                    }
                    
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: (self.messages.count - 1), section: 0)
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
    }
}
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
}
