//
//  InfoViewController.swift
//  TwitterDemo
//
//  Created by mac on 12/1/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class InfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editLabel: UIButton!
    @IBOutlet weak var dateBirthLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    var current_user : User?
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    
    var tweet : Tweet?
    var mainVC = MainViewController()
    
    @IBOutlet weak var myTableView: UITableView!
    
    var hastagArray = [NSDictionary?]()
    var filteredHastag = [NSDictionary?]()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredHastag.count
        }
        return self.hastagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as? InfoCell
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredHastag[indexPath.row]
            
        }else{
            user = self.hastagArray[indexPath.row]
        }
        
        cell?.authorLabel.text = user?["author"] as? String
        cell?.tweetLabel.text = user?["tweet"] as? String
        cell?.hashtaglabel.text = user?["hashtag"] as? String
        cell?.dateLabel.text = user?["date"] as? String
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = (myTableView.indexPathForSelectedRow?.row)!
        let  = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.image = user[index].image
        detailVC.name_surname = user[index].name_surname
        detailVC.number_phone = user[index].number
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editLabel.layer.cornerRadius = 10
        editLabel.layer.borderWidth = 1.5
        editLabel.layer.borderColor = UIColor.white.cgColor
        editLabel.clipsToBounds = true
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("tweets").queryOrdered(byChild: "hashtag").observe(.childAdded) { (snapshot) in
            self.hastagArray.append(snapshot.value as? NSDictionary)
            
            //insert rows
            self.myTableView.insertRows(at: [IndexPath(row: self.hastagArray.count - 1, section: 0)], with: .automatic)
            
        }
        
        
        self.current_user = Auth.auth().currentUser
        
        databaseRef.child("user_profile").child(self.current_user!.uid).observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            let value = snapshot.value as? NSDictionary
            
            self?.nameLabel.text = value?["name"] as? String ?? ""
            self?.surnameLabel.text = value?["surname"] as? String ?? ""
            self?.dateBirthLabel.text = value?["dateBirth"] as? String ?? ""
        }
        
        mainVC.currentUser = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [weak self](snapshot) in
            self?.mainVC.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot{
                    let tweet = Tweet(snapshot: snap)
                    self?.mainVC.tweets.append(tweet)
                }
            }
            self?.mainVC.tweets.reverse()
            self?.myTableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func replyPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    
    func filterContent(searchText: String){
        self.filteredHastag = self.hastagArray.filter{ user in
            let username = user!["hashtag"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
        }
        myTableView.reloadData()
    }

}
