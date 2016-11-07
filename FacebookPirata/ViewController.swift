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
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        navigationController?.navigationBar.isHidden = true
        
        if KeychainWrapper.standard.string(forKey: "FB_UID") != nil || KeychainWrapper.standard.string(forKey: "EMAIL_UID") != nil {
            print("El usuario ya había ingresado anteriormente")
        }
    }

    @IBAction func inicioSesion(_ sender:UIButton) {
        if let email = txtUsuario.text, let psw = txtPassword.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: psw, completion: { (user, error) in
                if error != nil, let err = error as? NSError {
                    print("Ocurrió un error al ingresar con Firebase")
                    
                    if err.code == ERROR_PASWWORD_NOT_LONG {
                        print("Favor de ingresar una contraseña de más de 6 caracteres")
                    } else if err.code == ERROR_ACCOUNT_ALREADY_USER {
                        print("La cuenta de correo ya está siendo usada.")
                        
                        FIRAuth.auth()?.signIn(withEmail: email, password: psw, completion: { (user, error) in
                            if error != nil, let err = error as? NSError {
                                if err.code == ERROR_INVALID_PASSWORD {
                                    print("La contraseña ingresada no es valida.")
                                }
                            } else {
                                // Ir al siguiente VC
                                print("Login Email Exitoso")
                                KeychainWrapper.standard.set(user!.uid, forKey: "EMAIL_UID")
                            }
                            
                        })
                    }
                } else {
                    
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
                print("Usuario: \(user?.displayName)")
                KeychainWrapper.standard.set(user!.uid, forKey: "FB_UID")
            }
        })
    }
}

