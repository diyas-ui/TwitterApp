//
//  RegistrationViewController.swift
//  TwitterDemo
//
//  Created by mac on 11/30/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController {
    
    
    
    var databaseRef = Database.database().reference()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerPressed(_ sender: UIButton) {
        let email = emailTextField.text
        let password = PasswordTextField.text
        let name = nameTextField.text
        let surname = surnameTextField.text
        let date = dateOfBirthPicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let format = formatter.string(from: date)
        
       
        
        if email != "" && password != ""  {
            indicator.startAnimating()
            Auth.auth().createUser(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                
                if error == nil {
                    //let user = Auth.auth().currentUser?.uid
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("email").setValue(email)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("name").setValue(name)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("surname").setValue(surname)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("dateBirth").setValue(format)
                    self?.showMessage(title: "Success", message: "Please verify your email")
                } else {
                    self?.showMessage(title: "Error", message: "Opps some problems ocurred")
                    self?.indicator.stopAnimating()
                }
            }
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
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if title != "Error" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}
