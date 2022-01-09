//
//  PostDetailsVC.swift
//  FinalProject
//
//  Created by salha asyri on 15/05/1443 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PostDetailsVC: UIViewController {
    
    var post:Post!
    var comments: [Comment] = []
    
    // MARK: OUTLETS
    
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var commentsTabelView: UITableView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var newCommentSV: UIStackView!
    
    
    // MARK: LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserManager.loggedInUser == nil{
            newCommentSV.isHidden = true 
        }
        commentsTabelView.delegate = self
        commentsTabelView.dataSource = self
        
        
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        postTextLabel.text = post.text
        numberOfLikesLabel.text = String(post.likes)
        if let image = post.owner.picture{
            userImageView.setImageFromStringUrl(stringUrl: image)

        }
        //هذا الكود عشان اطلع صورت البوست في صفحة التفاصيل
        
        postImageView.setImageFromStringUrl(stringUrl: post.image)
        userImageView.makeCircularImage()
        //////////////
        //getting the comments of the post from the API
//        let url = "https://dummyapi.io/data/v1/post/60d21af267d0d8992e610b8d/comment"
        
        getPostComments()
    }
    
    func getPostComments(){
        loaderView.startAnimating()
        PostAPI.getPostComments(id: post.id) { commentsResponse in
            self.comments = commentsResponse
            self.commentsTabelView.reloadData()
            self.loaderView.stopAnimating()
        }
        
    }
    
    // MARK: ACTIONS
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        let message = commentTextField.text!
        
        if let user = UserManager.loggedInUser{
            loaderView.startAnimating()
            PostAPI.addNewCommentToPost(postId: post.id, userId: user.id, message: message) {
                self.getPostComments()
                self.commentTextField.text = ""
                   }
               }
        }
       
    
}

extension PostDetailsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let currentComment = comments[indexPath.row]
        cell.userNameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.lastName
        
        cell.commentMessageLabel.text = currentComment.message
        
        
        
        if let userImage = currentComment.owner.picture{
            cell.userImageView.setImageFromStringUrl(stringUrl: userImage )
        }
        cell.userImageView.makeCircularImage()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
        
    }
    
}


