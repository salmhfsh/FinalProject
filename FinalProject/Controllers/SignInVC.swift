//
//  SignInVC.swift
//  FinalProject
//
//  Created by salha asyri on 21/05/1443 AH.
//

import UIKit

class SignInVC: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var fistNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    // MARK: LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fistNameTextField.text = "salhahom"
        self.lastNameTextField.text = "Mohammed"
        // Do any additional setup after loading the view.
    }
    
    //MARK: ACTIONS
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        UserAPI.signInUser(firstName: fistNameTextField.text!, lastName: lastNameTextField.text!) { user, errorMessage in
            if let message = errorMessage{
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else{
                if let loggedInUser = user{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
                    UserManager.loggedInUser = loggedInUser
                    self.present(vc!, animated: true, completion: nil)
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

}
