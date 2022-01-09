//
//  ViewController.swift
//  FinalProject
//
//  Created by salha asyri on 12/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView


class PostsVC: UIViewController {

    
    @IBOutlet weak var newPostButtonContainerView: ShadowView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    
    var page = 0
    var total = 0
    var posts: [Post] = []
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostAdded), name: NSNotification.Name(rawValue: "NewPostAdd"), object: nil)
        
        tagContainerView.layer.cornerRadius = 10
        //check if user is logged in or it's only a guest
        
        if let user = UserManager.loggedInUser {
            hiLabel.text = "Hi, \(user.firstName)"
        }else{
            hiLabel.isHidden = true
            newPostButtonContainerView.isHidden = true
        }
        
        //check if there is  a tag
        if let myTag = tag {
            
            tagNameLabel.text = myTag
        }else{
            closeButton.isHidden = true
            tagContainerView.isHidden = true
        }
        
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        //subscribing to the notification
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name("userStackViewTapped"), object: nil)
        
        getPosts()
//        loaderView.startAnimating()
//        PostAPI.getAllPosts(page: page, tag: tag) { postsResponse in
//            self.posts = postsResponse
//            self.postsTableView.reloadData()
//            self.loaderView.stopAnimating()
//        }
    }
    
    func getPosts(){
        
        loaderView.startAnimating()
        PostAPI.getAllPosts(page: page, tag: tag) { postsResponse, total in
            self.total = total
            self.posts.append(contentsOf: postsResponse)
            self.postsTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    @objc func newPostAdded(){
        self.posts = []
        self.page = 0
        getPosts()
    }
    
    // MARK: ACTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue"{
            UserManager.loggedInUser = nil
        }
            
    }
    @objc func userProfileTapped(notification: Notification){
        if let cell = notification.userInfo?["cell"] as? UITableViewCell{
            if let indexPath = postsTableView.indexPath(for: cell){
            let post = posts[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                vc.user = post.owner
                     present(vc, animated: true, completion: nil)
                
        }
        }
     
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PostsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        cell.postTextLabel.text = post.text
        
        // the logic of filling the post's image from the url
        
        let imageStringUrl = post.image
        cell.postImageView.setImageFromStringUrl(stringUrl: imageStringUrl)
        //the logic of filling the user's image from the url
        
        
        let userImageStringUrl = post.owner.picture
        cell.userImageView.makeCircularImage()
        if let image = userImageStringUrl{
        cell.userImageView.setImageFromStringUrl(stringUrl: image)
        }
        
        //filling the user data
        
        cell.userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        cell.likesNumberLabel.text = String(post.likes)
        
        cell.tags = post.tags ?? []
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 602
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsVC") as! PostDetailsVC
        vc.post = selectedPost
        
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 && posts.count < total {
            page = page + 1
            getPosts()
        }
    }
}

