//
//  MainViewController.swift
//  Randomizer
//
//  Created by nguyen ha on 10/10/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MainViewController: PrimaryViewController {

    @IBOutlet weak var randomCollectionView: UICollectionView!
    @IBOutlet weak var numberTxt: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var users: [User] = []
    var previewUserItemList: [UserItem] = []
    var currentUser: User?
    var selectedUsers: [User] = []
    var onReset =  false
    var timer : Timer?                       = nil
    var onAnimate = false
    var index = -1
    var isShowingKeyboard = false
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        randomCollectionView.backgroundColor = Const.colorGrey100
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardNotification(_ notification: Notification) {
        self.isShowingKeyboard = notification.name == NSNotification.Name.UIKeyboardWillShow
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameHeight = endFrame?.size.height ?? 0.0
            self.bottomSpacingConstraint?.constant = self.isShowingKeyboard ? endFrameHeight + 8.0 : 8.0
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func settimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.randomElement), userInfo: nil, repeats: true)
    }
    
    func initUI () {
        self.navigationItem.title = "RANDOMIZER"
        self.previewUserItemList = convertUserListToPreviewUserItemList(users: users)
        self.startButton.roundCorner(Const.colorGrey, borderWidth: 1.0)
        self.numberTxt.bottomBorderUi()
        randomCollectionView.register(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        randomCollectionView.register(UINib(nibName: "AddNewUserCell", bundle: nil), forCellWithReuseIdentifier: "AddNewUserCell")
        self.updateUI()
    }
    
    func updateUI () {
        self.users.removeAll()
        self.previewUserItemList.removeAll()
        let users = DatabaseUseCase.getAllUser()
        for user in users {
            user.image = CacheManager.getCachedImage(imageId: user.imageUrl)
            self.users.append(user)
        }
        self.previewUserItemList = convertUserListToPreviewUserItemList(users: users)
        randomCollectionView.reloadData()
    }
    
    func resetValue() {
        selectedUsers.removeAll()
        index = 0
        numberTxt.text = ""
    }
    
    func convertUserListToPreviewUserItemList(users: [User]) -> [UserItem] {
        var previewUserItemList: [UserItem] = []
        for user in users {
            previewUserItemList.append(UserItem(user: user))
        }
        previewUserItemList.append(UserItem(contentType: .addNewUserButton))
        return previewUserItemList
    }
    
    @IBAction func onClickClearButton(_ sender: Any) {
        _ = DatabaseSession.mainSession().deleteAll()
        self.updateUI()
    }
    
    @IBAction func onClickFaceDetectionButton(_ sender: Any) {
        let controller = ResourceProvider.getViewController(FaceDetactionViewController.self)
        self.navigateToScreen(controller)
    }
    @IBAction func onClickStartButton(_ sender: Any) {
        if (numberTxt.text!.isEmpty) {
            return
        }
        if !onReset {
            self.settimer()
            numberTxt.isEnabled = false
            startButton.setTitle("RESET", for: .normal)
        } else {
            numberTxt.isEnabled = true
            startButton.setTitle("START", for: .normal)
            resetValue()
            randomCollectionView.reloadData()
        }
        onReset = !onReset
    }
    
    @objc func randomElement() {
        index += 1
            let number = Int(numberTxt.text!)!
            if number > users.count {
                numberTxt.text = ""
                return
            }
            selectedUsers = users.choose(number)
            randomCollectionView.reloadData()
        if index == 5 {
            self.timer?.invalidate()
        }
    }
    
    func onClickPlusButton() {
        showAlertAddNewUser()
    }
    
    func showCameraPermissionRequest() {
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
    }
    
    func gotoCamera() {
        // Check Camera Permission
        let mediaType: String = AVMediaType.video.rawValue
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: mediaType))
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted {
            self.showCameraPermissionRequest()
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
            } else {
                imagePickerController.sourceType = .savedPhotosAlbum
            }
            imagePickerController.mediaTypes = ["public.image"]
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func showAlertAddNewUser() {
        let controller = UIAlertController(title: "c_title".localize, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "c_cancel".localize, style: .default, handler:{ (_) in
            
        })
        let okAction = UIAlertAction(title: "c_ok".localize, style: .default, handler: { (_) in
            let textField = controller.textFields![0]
            let user = User()
            user.id = BaseUseCase.currentTimeInSeconds
            user.name = String(describing: textField.text!)
            _ = DatabaseSession.mainSession().writeObject(user)
            self.updateUI()
        })
        controller.addTextField(configurationHandler: {(textField) in textField.placeholder = "your name"})
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        presentDialog(controller)
    }
    
    func onClickChangeAvatar(user: User?) {
        self.currentUser = user
        gotoCamera()
    }
    
}

extension MainViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewUserItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.previewUserItemList[indexPath.row]
        if item.contentType == .user {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.updateUI(user: item.user, selectedUsers: self.selectedUsers)
            cell.onClickButton = onClickChangeAvatar
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewUserCell", for: indexPath) as! AddNewUserCell
            cell.onClickPlusButton =  onClickPlusButton
            return cell
        }
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.close()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageId = CacheManager.generateImageId(user: self.currentUser)
        CacheManager.cacheImage(image, imageId: imageId)
        DatabaseSession.mainSession().openTransaction({
            self.currentUser?.imageUrl = imageId!
        })
        self.updateUI()
        picker.close()
    }
    
}
