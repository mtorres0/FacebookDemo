//
//  ViewController.swift
//  FacebookPirata
//
//  Created by Vanessa on 04/11/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func inicioSesion(_ sender:UIButton) {
        if let email = txtUsuario.text, let psw = txtPassword.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: psw, completion: { (user, error) in
                if error != nil, let err = error as? NSError {
                    print("Ocurrió un error al ingresar con Firebase")
                    
                    if ERROR_PASWWORD_NOT_LONG == err.code {
                        print("Favor de ingresar una contraseña de más de 6 caracteres")
                    }
                } else {
                    print("Usuario: \(user?.displayName)")
                }
            })
        } else {
            print("Favor de introducir su usuario y contraseña")
        }
    }
    
    @IBAction func faceBookBtnPressed(_ sender:UIButton) {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            print(result)
            
            if error != nil {
                print("No se pudo conectar con Facebook")
            } else if result?.isCancelled == true {
                print("El usuario ha cancelado el Login por Facebook")
            } else {
                print("Login exitoso con Facebook")
                
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.fireBaseAuth(credentials)
            }
        }
    }
    
    
    func fireBaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("No se pudo autenticar con Firebase: Error: \(error.debugDescription)")
            } else {
                print("Se autenticó con exito con Firebase")
            }
        })
    }
}

