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
    @IBOutlet weak var userPasswordTextComfirm: UITextField!
    @IBOutlet weak var backToLoging: UIButton!
    @IBOutlet weak var lbError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.becomeFirstResponder()
        userNameText.becomeFirstResponder()
        userPasswordText.becomeFirstResponder()
        userPasswordTextComfirm.becomeFirstResponder()
        
        emailText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        userNameText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        userPasswordText.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        userPasswordTextComfirm.addTarget(self, action: #selector(heandTextField), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        photoUploadButton.addTarget(self, action: #selector(handleUploadPhoto), for: .touchUpInside)
        backToLoging.addTarget(self, action: #selector(handleBackToLogIn), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        signUpButton.layer.cornerRadius = 11
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailText.resignFirstResponder()
        userNameText.resignFirstResponder()
        userPasswordText.resignFirstResponder()
        userPasswordTextComfirm.resignFirstResponder()
    }
    
    @objc func handleBackToLogIn(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadPhoto(){
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Library", style: .default) { (action) in
            self.handlePlusPhotoLibrary()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action3 = UIAlertAction(title: "Camera", style: .default) {(_)in
            self.cameraPlusPhoto()
        }
        action2.setValue(UIColor.red, forKey: "titleTextColor")
        sheet.addAction(action1)
        sheet.addAction(action2)
        sheet.addAction(action3)
        present(sheet, animated: true, completion: nil)
        
    }
    
   func handlePlusPhotoLibrary(){
        let imagePickUpControl = UIImagePickerController()
        imagePickUpControl.delegate = self
        imagePickUpControl.sourceType = .photoLibrary
        imagePickUpControl.allowsEditing = true
        present(imagePickUpControl, animated: true, completion: nil)
    }
    
    func cameraPlusPhoto(){
        let cameraPickUpControl = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraPickUpControl.delegate = self
            cameraPickUpControl.sourceType = UIImagePickerControllerSourceType.camera
            cameraPickUpControl.cameraCaptureMode = .photo
            cameraPickUpControl.modalPresentationStyle = .fullScreen
            present(cameraPickUpControl, animated: true, completion: nil)
        }else{
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
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
        if userPasswordText.text != userPasswordTextComfirm.text{
            lbError.text = "Password and confirmation password do not match"
        }else{
        Auth.auth().createUser(withEmail: email, password: password) { (user, error
        ) in
            if let err = error{
                print("Error:\(err)")
                 self.lbError.text = err.localizedDescription
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
                    
                    let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let signUpShowTabBarViewController = myStoryBoard.instantiateViewController(withIdentifier: "MyTabBarViewController")
                    self.present(signUpShowTabBarViewController, animated:true, completion:nil)
                    
                })
            })

            }
        }
    }
    
    @objc func heandTextField(){
        if let emailTextIsField = emailText.text , let userNameTextIsField = userNameText.text,let userPasswordTextIsField = userPasswordText.text,let userPasswordComfirmTextIsField = userPasswordTextComfirm.text{
            
            if emailTextIsField.count > 0 && userPasswordTextIsField.count > 0 &&  userNameTextIsField.count > 0 && userPasswordComfirmTextIsField.count > 0{
                signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.05490196078, alpha: 1)
                signUpButton.isEnabled = true
            }else{
                signUpButton.backgroundColor = #colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)
                signUpButton.isEnabled = false
            }
       
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
