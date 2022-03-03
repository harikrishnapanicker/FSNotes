//
//  ViewController.swift
//  FSNotes
//
//  Created by HariPanicker on 25/02/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet private weak var emailField: UITextField!
    
    @IBOutlet private weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else {
            emailField.text = ""
            passwordField.text = ""
            return
        }
        loginWith(email: email, password: password)
    }
    
    func loginWith(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if error == nil {
                self?.updateLoginStatus()
                self?.moveToNotes()
            } else if error?._code == 17011 {
                self?.signupWith(email: email, password: password)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func signupWith(email: String, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if error == nil {
                self?.updateLoginStatus()
                self?.moveToNotes()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func updateLoginStatus() {
        CoredataManager.shared.saveUser()
    }
    
    func moveToNotes() {
        guard let notesController =  self.storyboard?.instantiateViewController(identifier: "NotesController") else {
            return
        }
        self.navigationController?.pushViewController(notesController, animated: true)
    }
}

