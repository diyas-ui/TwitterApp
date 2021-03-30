//
//  MainViewController.swift
//  TwitterDemo
//
//  Created by mac on 11/30/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var currentUser : User?
    var handle : DatabaseHandle?
    var tweets : [Tweet] = []
    
    var keyArray: [String] = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomCell
        cell?.tweetLabel.text = tweets[indexPath.row].content
        cell?.userLabel.text = tweets[indexPath.row].author
        cell?.timeLabel.text = tweets[indexPath.row].date
        cell?.hashtagLabel.text = tweets[indexPath.row].hastag
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete{
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                Database.database().reference().child("tweets").child(self.keyArray[indexPath.row]).removeValue()
                self.tweets.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                self.keyArray = []
                
                
            })
            
            
            
            
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [weak self](snapshot) in
            self?.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot{
                    let tweet = Tweet(snapshot: snap)
                    self?.tweets.append(tweet)
                }
            }
            self?.tweets.reverse()
            self?.myTableView.reloadData()
           
        }
    }
    

    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do{
        try Auth.auth().signOut()
        } catch {
            print("Error message")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
   
    
    @IBAction func composePressed(_ sender: UIBarButtonItem) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Tweet", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "What's up?"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "#hastag"
        }
        
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy-HH:mm"
        let result = formatter.string(from: date)
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Tweet", style: .default, handler: { [ weak alert] (_) in
            let textField1 = alert?.textFields![0] // Force unwrapping because we know it exists.
            let textField2 = alert?.textFields![1]
            let tweet = Tweet(textField1!.text!, (self.currentUser?.email)!,result,(textField2?.text)!)
            
            
            Database.database().reference().child("tweets").childByAutoId().setValue(tweet.dict)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {  (_) in
             // Force unwrapping because we know it exists.
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func getAllKeys(){
        Database.database().reference().child("tweets").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
                self.keyArray.reverse()
                self.myTableView.reloadData()
                print(self.keyArray[0])
                print(self.tweets[0])
            }
        }
    }

}
