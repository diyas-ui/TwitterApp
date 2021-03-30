//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by mac on 11/30/20.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    
    var currentUser: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.center.x = self.view.frame.width + 50
        UIView.animate(withDuration: 1.5, delay: 00, usingSpringWithDamping: 1.0 , initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            self.emailTextField.center.x = self.view.frame.width / 2 - 100
        }, completion: nil)
        passwordTextField.center.x = self.view.frame.width - 500
        UIView.animate(withDuration: 1.5, delay: 00, usingSpringWithDamping: 1.0 , initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            self.passwordTextField.center.x = self.view.frame.width / 2 - 100
        }, completion: nil)
        loginButton.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.loginButton.alpha = 1
        }, completion: nil)

    }
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified{
            goToMainPage()
        }
        
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        indicator.startAnimating()
        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                if error == nil {
                    if Auth.auth().currentUser!.isEmailVerified {
                        
                        self?.goToMainPage()
                        
                    }else{
                        self?.showMessage(title: "Warnings", message: "Your email is not verified")
                    }
                    
                }else{
                    
                }
            }
        }
    }
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
        }
        alert.addAction(ok)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToMainPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mainPage = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController{
            mainPage.modalPresentationStyle = .fullScreen
            present(mainPage, animated: true, completion: nil)
        }
        
    }
        
}
