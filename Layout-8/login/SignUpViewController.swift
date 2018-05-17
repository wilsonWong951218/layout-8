//
//  SignUpViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/16.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var photoUploadButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var userPasswordText: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        userNameText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        userPasswordText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        photoUploadButton.addTarget(self, action: #selector(handleUploadPhoto), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc func handleUploadPhoto(){
        let imagePickUpControl = UIImagePickerController()
        imagePickUpControl.delegate = self
        imagePickUpControl.allowsEditing = true
        present(imagePickUpControl, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            photoUploadButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for:.normal)
            
        }else if let orignalImage = info["UIImagePickerControllerOriginalImage"]as?UIImage{
            photoUploadButton.setImage(orignalImage.withRenderingMode(.alwaysOriginal), for:.normal)
            
        }
        photoUploadButton.layer.cornerRadius = photoUploadButton.frame.width/2
        photoUploadButton.layer.masksToBounds = true
        photoUploadButton.layer.borderColor = UIColor.black.cgColor
        photoUploadButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    @objc func handleSignUp(){
        guard let username = userNameText.text , username.count > 0 else{return}
        guard let password = userPasswordText.text,username.count > 0 else{return}
        guard let email = emailText.text,username.count > 0 else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error
        ) in
            if let err = error{
                print("Error:\(err)")
                return
            }
            print("Successfully:\(user?.uid ?? "")")
            
            guard let image = self.photoUploadButton.imageView?.image else{return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3)else{return}
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("Proflie_Image").child(filename).putData(uploadData, metadata: nil, completion: { (Metadata, error) in
                if let err = error{
                    print("Upload Image Failed:\(err)")
                    return
                }
                
                guard let profileImage = Metadata?.downloadURL()?.absoluteString else{return}
                print("Upload success:\(profileImage)")
                
                guard let uid = user?.uid else{return}
                let dictionaryValue = ["Username":username,"Password":password,"ProfileImage":profileImage]
                let value = [uid:dictionaryValue]
                Database.database().reference().child("User:").updateChildValues(value, withCompletionBlock: { (error, databaseReff) in
                    if let err = error{
                        print("Error upload data:\(err)")
                        return
                    }
                    print("Upload data success:\(databaseReff)")
                    self.performSegue(withIdentifier: "showTabBarController", sender: nil)
                })
            })
            
            
            
        }
        
        
    }
    
    @objc func heandTextField(){
        if let emailTextIsField = emailText.text , let userNameTextIsField = userNameText.text,let userPasswordTextIsField = userPasswordText.text{
            if emailTextIsField.count > 0 && userPasswordTextIsField.count > 0 && userNameTextIsField.count > 0{
                signUpButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                signUpButton.isEnabled = true
            }else{
                signUpButton.backgroundColor = #colorLiteral(red: 0.8016937372, green: 0.8519167859, blue: 1, alpha: 1)
                signUpButton.isEnabled = false
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
