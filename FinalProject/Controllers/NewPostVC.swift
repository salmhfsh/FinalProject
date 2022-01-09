//
//  NewPostVC.swift
//  FinalProject
//
//  Created by salha asyri on 06/06/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class NewPostVC: UIViewController {

    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postTextTextField: UITextField!
    
    @IBOutlet weak var postImageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPostButtonClicked(_ sender: Any) {
        if let user = UserManager.loggedInUser{
            addButton.setTitle(" ", for: .normal)
            loaderView.startAnimating()
            PostAPI.addNewPost(text: postTextTextField.text!, userId: user.id) {
                self.loaderView.stopAnimating()
                self.addButton.setTitle("Add", for: .normal)
                NotificationCenter.default.post(name: NSNotification.Name("NewPostAdded"), object: nil, userInfo: nil)
                //المشكلة هنا انه يرجع للصفحه السابقة لكن ما يضيف البوست الجديد
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
  
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
