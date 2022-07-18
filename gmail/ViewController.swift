//
//  ViewController.swift
//  gmail
//
//  Created by Ammad on 16/07/2022.
//

import UIKit
import Firebase
import GoogleSignIn
class ViewController: UIViewController {

    @IBOutlet weak var mybut: GIDSignInButton!
  
    @IBOutlet weak var mylabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      //  signin()
    }
    func signin(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
            // ...
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                print(authResult)
                if let error = error {
                  let authError = error as NSError
                  if  authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError
                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in resolver.hints {
                      displayNameString += tmpFactorInfo.displayName ?? ""
                      displayNameString += " "
                    }
                   
                  } else {
                   // self.showMessagePrompt(error.localizedDescription)
                    return
                  }
                  // ...
                  return
                }
                print("user logged in")
                mylabel.text="Sign in"
                // User is signed in
                // ...
            }
          // ...
        }
        
    }
    

    @IBAction func signout(_ sender: Any) {
    
    print("user signing out")
    signout1()
        mylabel.text="Sign out"

        
    }
    
    @IBAction func signout2(_ sender: Any) {
   signout1()
        mylabel.text="Sign out"
    }
    func signout1(){
        
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        print("sign out done")
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    
    @IBAction func call(_ sender: Any) {
    print("touched")
        signin()
    }
    
    
}

