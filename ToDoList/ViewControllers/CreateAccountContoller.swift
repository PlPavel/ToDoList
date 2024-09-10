//
//  CreatAccountContoller.swift
//  ToDoList
//
//  Created by Pavel Plyago on 17.06.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class CreateAccountContoller: UIViewController{
    
    //Обработчик пароля
    let emptyDataHandler = EmptyInputValidation()
    let minimumLengthHandler = MinimumLengthHandler(minLength: 8)
    let specialSymbols = SpecialCharacterHandler()
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let togglePasswordButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        SetUpView()
    }
    
    func SetUpView(){
        let titleSignUp = UILabel()
        titleSignUp.text = "Sign Up"
        titleSignUp.font = .systemFont(ofSize: 30, weight: .heavy)
        titleSignUp.textColor = UIColor.label
        titleSignUp.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleSignUp)
        
        NSLayoutConstraint.activate([
            titleSignUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleSignUp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 5)
        ])
        
        let usernameTitle = UILabel()
        usernameTitle.text = "Email"
        usernameTitle.font = .systemFont(ofSize: 16)
        usernameTitle.textColor = UIColor.label
        usernameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameTitle)
        
        NSLayoutConstraint.activate([
            usernameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            usernameTitle.topAnchor.constraint(equalTo: titleSignUp.bottomAnchor, constant: 20)
        ])
        
        emailField.placeholder = "Enter Your Username"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
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
        
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign In", for: .normal)
        signUpButton.tintColor = .systemBackground
        signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius = 15
        signUpButton.alpha = 0.8
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
        
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func createNewAccount(){
        emptyDataHandler.nextHandler = minimumLengthHandler
        minimumLengthHandler.nextHandler = specialSymbols
        let inputPassword = passwordField.text ?? ""
        if let answerOfHandler = emptyDataHandler.validate(input: inputPassword){
            let alertController = UIAlertController(title: "Password Handler", message: answerOfHandler, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            guard let email = emailField.text else {
                return
            }
            Auth.auth().createUser(withEmail: email, password: inputPassword) { (result, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Email Handler",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                print("Result is\(String(describing: result?.user.email))")
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func togglePasswordVisible(){
        passwordField.isSecureTextEntry.toggle()
        let buttonText = passwordField.isSecureTextEntry ? "Показать" : "Скрыть"
        togglePasswordButton.setTitle(buttonText, for: .normal)
    }
    
}
