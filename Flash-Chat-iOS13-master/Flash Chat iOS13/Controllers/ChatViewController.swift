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
    
    var messages = [Message]() /* = [
        Message(sender: "1@2.com", body: "Hey! lreomfklds afy8 fhjksdlf ahsd oahgweajkh adlghdka jfh8we tywer8ofy gdkaghdiauo ghrethyudagyt 7e49t6 y43ithydf ua;g yre9a78ty 34oy rduafgyhadjkhfdsakl gy64 iyt4838 hfgdjkalfgy  7aw7ty4ou3 fhjkasd fy47waty 47iutweulyr kasdftgi7w4a yulst yiwf yuasty wryu yftw4eiyafr seytfgelsdfdkhgsg."),
        Message(sender: "a@b.com", body: "Wasssssssuuup!"),
        Message(sender: "1@2.com", body: "Stop that"),
        Message(sender: "a@b.com", body: "Ooooookaaaaayyyyyy!")
    ] */
    
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
                        self.tableView.reloadData()
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
        
        cell.label.text = messages[indexPath.row].body
        
        return cell
    }
}
