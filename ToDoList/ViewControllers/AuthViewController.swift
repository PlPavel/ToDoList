//
//  ViewController.swift
//  ToDoList
//
//  Created by Pavel Plyago on 17.06.2024.
//

import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics
import FirebaseAuth

class AuthViewController: UIViewController {
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let togglePasswordButton = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        SetUpView()
    }
    
    func SetUpView(){
        let titleSignIn = UILabel()
        titleSignIn.text = "Sign In"
        titleSignIn.font = .systemFont(ofSize: 30, weight: .heavy)
        titleSignIn.textColor = UIColor.label
        titleSignIn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleSignIn)
        
        NSLayoutConstraint.activate([
            titleSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleSignIn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 5)
        ])
        
        let usernameTitle = UILabel()
        usernameTitle.text = "Username"
        usernameTitle.font = .systemFont(ofSize: 16)
        usernameTitle.textColor = UIColor.label
        usernameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameTitle)
        
        NSLayoutConstraint.activate([
            usernameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            usernameTitle.topAnchor.constraint(equalTo: titleSignIn.bottomAnchor, constant: 20)
        ])
        
        
        emailField.placeholder = "Enter Your Username"
        emailField.autocapitalizationType = .none
        emailField.borderStyle = .roundedRect
        emailField.layer.borderColor = UIColor.darkGray.cgColor
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailField)
        
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            emailField.topAnchor.constraint(equalTo: usernameTitle.bottomAnchor, constant: 10)
        ])
        
        let passwordTitle = UILabel()
        passwordTitle.text = "Password"
        passwordTitle.font = .systemFont(ofSize: 16)
        passwordTitle.textColor = UIColor.label
        passwordTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTitle)
        
        NSLayoutConstraint.activate([
            passwordTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            passwordTitle.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20)
        ])
        
        passwordField.placeholder = "Enter Your Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        togglePasswordButton.setTitle("Показать", for: .normal)
        togglePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisible), for: .touchUpInside)
        
        view.addSubview(passwordField)
        view.addSubview(togglePasswordButton)
        
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            passwordField.topAnchor.constraint(equalTo: passwordTitle.bottomAnchor, constant: 10),
            
            togglePasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -10),
            togglePasswordButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor)
        ])
        
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.tintColor = .systemBackground
        signInButton.backgroundColor = .systemGreen
        signInButton.layer.cornerRadius = 15
        signInButton.alpha = 0.8
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.addTarget(self, action: #selector(showTask), for: .touchUpInside)
        
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let signUpText = UILabel()
        signUpText.text = "Don't Have An Account?"
        signUpText.font = .systemFont(ofSize: 16)
        signUpText.textColor = .gray
        signUpText.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(signUpText)
        
        NSLayoutConstraint.activate([
            signUpText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            signUpText.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 60)
        ])
        
        let goToSignUpScreenButton = UIButton(type: .system)
        goToSignUpScreenButton.setTitle("Sign Up", for: .normal)
        goToSignUpScreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        goToSignUpScreenButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        
        view.addSubview(goToSignUpScreenButton)
        
        NSLayoutConstraint.activate([
            goToSignUpScreenButton.leadingAnchor.constraint(equalTo: signUpText.trailingAnchor, constant: 10),
//            goToSignUpScreenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            goToSignUpScreenButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 60),
            goToSignUpScreenButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    //MARK: - Firebase Аналитика
    @objc func showSignUp(){
        Analytics.logEvent("User doesn't have account", parameters: [
            "id": 1,
            "button-name": "Sign Up",
            "timestamp": Int(Date().timeIntervalSince1970)
        ])
        let vc2 = CreateAccountContoller()
        vc2.modalPresentationStyle = .formSheet
        present(vc2, animated: true)
    }
    
    @objc func togglePasswordVisible(){
        passwordField.isSecureTextEntry.toggle()
        let buttonTitle = passwordField.isSecureTextEntry ? "Показать" : "Скрыть"
        togglePasswordButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func showTask(){
        Analytics.logEvent("User sign in", parameters: [
            "id": 1,
            "button-name": "Sign In",
            "timestamp": Int(Date().timeIntervalSince1970)
        ])
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            let alertController = UIAlertController(title: "Error Handler", message: "Email or password is empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error Handler", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let navVC = UINavigationController(rootViewController: TasksViewController())
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
    }
}

