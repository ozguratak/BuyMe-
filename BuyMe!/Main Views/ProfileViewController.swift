//
//  ProfileViewController.swift
//  BuyMe!
//
//  Created by obss on 24.10.2022.
//
import Foundation
import Gallery
import UIKit

class ProfileViewController: UIViewController {
    
    var currentUser: User?
    var gallery: GalleryController!
    var objectID = userID
    var purchasedItems: [String] = []
    var profileImages: [UIImage?] = []
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        ErrorController.deleteAccount(page: self)
    }
    
    @IBAction func profileImageChangeButtonPressed(_ sender: Any) {
        if profileImages.count > 0 {
            profileImages.removeAll()
            showImageGalleryForProfile()
            
        } else {
            showImageGalleryForProfile()
          
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        User.logOutUser(page: self)
    }
    
    @IBAction func passwordChangeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: passwordChange, sender: nil)
    }
    @IBAction func emailChangeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: emailChange, sender: nil)
    }
    @IBAction func sameAddressButtonPressed(_ sender: Any) {
        if shippingAdressTextField.text != nil {
            billAdressTextField.text = shippingAdressTextField.text
        }
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        updateUserInformations()
        setupUI()
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var shippingAdressTextField: UITextField!
    @IBOutlet weak var billAdressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        downloadCurrentUser()
        
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh) , name: Notification.Name(userLoggedIn), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @objc func refresh() {
        presentedViewController?.reloadInputViews()
    }
    
    
    
    func downloadCurrentUser() {
        User().downloadUserFromFirestore { userArray in
            if userArray.isEmpty != true {
                for user in userArray {
                    if user.email == currentEmail {
                        self.currentUser = user
                        self.downloadPictures()
                        
                    
                        return
                    }
                }
            } else {
                ErrorController.alert(alertInfo: "user indirilemedi.", page: self)
            }
        }
    }
    
    private func downloadPictures(){
        if currentUser != nil && currentUser?.profileImageLinks != nil {
            downloadImagesFromFirestore(imageUrls: currentUser?.profileImageLinks ?? [""]) { images in
                if images.count > 0 {
                    self.profileImages = images as! [UIImage]
                    self.setupUI()
                }
            }
        }
    }
    
    private func setupUI() {
        
        if currentUser?.onBoard == true {
            
            nameTextField.placeholder = currentUser?.firstName
            lastNameTextField.placeholder = currentUser?.lastName
            phoneTextField.placeholder = currentUser?.phoneNumber
            shippingAdressTextField.placeholder = currentUser?.fullAdress
            billAdressTextField.placeholder = currentUser?.billAdress
            
            if profileImages.count > 0 {
                profileImageView.image = profileImages[0]
            } else {
                profileImageView.image = UIImage(named: "placeHolder")
            }
            
        } else {
            nameTextField.placeholder = "Name"
            lastNameTextField.placeholder = "Last Name"
            phoneTextField.placeholder = "Phone Number"
            shippingAdressTextField.placeholder = "Shipping Adress"
            billAdressTextField.placeholder = "Bill Adress"
        }
       
    }
    
    private func updateUserInformations() {
        if nameTextField.text != nil && lastNameTextField.text != nil && billAdressTextField.text != nil && shippingAdressTextField.text != nil && phoneTextField.text != nil {
            User().updateUserInformations(userID: User.currentId(), name: nameTextField.text!, lastName: lastNameTextField.text!, billAdress: billAdressTextField.text!, shippingAdress: shippingAdressTextField.text!, phone: phoneTextField.text!, profileImage: profileImages)
            self.message(message: "Profile succesfully updated!", title: "Good!", action: true) { action in
                action.dismiss(animated: true)
            }
        } else {
            ErrorController.alert(alertInfo: "Please confirm all blanks!", page: self)
        }
    }
    
    private func message(message: String, title: String, action: Bool, completion: @escaping (_ action: UIAlertController) -> Void) {
        
        let notificationVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if action {
            self.present(notificationVC, animated: true)
        }
        completion(notificationVC)
    }
    
    func deleteUserInfo() {
        if let userID = userID {
            firebaseReference(.User).document(userID).delete { error in
                if let error = error {
                    print("ERRO OLUŞTU!!!\(error)")
                } else {
                    User().deleteUser()
                    NotificationCenter.default.post(name: NSNotification.Name(logOutNotification), object: nil)
                }
            }
        } else {
            ErrorController.alert(alertInfo: "This account was not verified. So you cant delete this account. Please verify your account firstly!", page: self)
        }
    }
    
    
}
extension ProfileViewController: GalleryControllerDelegate { // Galeriye eklenmiş olan fotoğrafların seçimi kamera kullanımı için gerekli protocol
    private func showImageGalleryForProfile() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab] // Galeri kütüphanesi içinde hazır bulunan tab /sekme gösterme özelliğini tabsToShow olarak çağırdık ve imageların olduğu ve kameranın olduğu iki tab açmasını söyledik.
        Config.Camera.imageLimit = 1 // kamerayı 1 fotoğraf ile kısıtladık.
        
        self.present(self.gallery, animated: true, completion: nil) // Küçük bir detay olarak bu aşamada kamera ve fotoğrafların kullanımı için Info.plist içerisinde bu kullanımı seçmeli ve kullanıcıdan onay istemeliyiz. aksi takdirde uygulama crash edecektir.
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.profileImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}






