//
//  ItemAddViewController.swift
//  BuyMe!
//
//  Created by obss on 7.10.2022.
//

import UIKit
import Gallery
import NVActivityIndicatorView

//MARK: - Bu controllerın görevi, itemstableview(ITV) içerisinde yer alacak olan verinin yine ITV içinde tanımlanmış olan id, name, image gibi verilerinin kullanıcı tarafından girilecek olan kısımlarını toplamak ve bu verileri firebase içerisinde yer alan Items case'i içine eklemektir.

class ItemAddViewController: UIViewController {
//MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var stockOfItem: UITextField!
    //Singleton
    var items = Items.shared
    //MARK: - Variables
    var category: Category! // Force edilmiş bir category değişkeni tanımlıyoruz bunu yapmamızın sebebi eklenecek olan item bir kategoriye ait olmak zorunda. kategorilendirilmemiş olan bir item DB içinde kaybolacak ve alakasız durumlarda karşımıza çıkacaktır. Bu değişkenin görevi kullanıcıdan alınamayacak olan ve backgroundda halletmemiz gereken iteme ait kategori numarasının paslanabilmesidir.
    var gallery: GalleryController!
    var activityIndicator: NVActivityIndicatorView? // Yükleme ikonlarının olduğu third party kütüphane
    
    var itemImages: [UIImage?] = []
    
    //MARK: - View LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: Int(self.view.frame.width) / 2 - 30, y: Int(self.view.frame.height) / 2 - 30, width: 60, height: 30), type: .ballPulse, color: .lightGray, padding: nil) //activity indicator'ı sayfa içerisinde konumlandırıyoruz merkezin yarısının 30 eksiği ile x ve y de ortaladık, 60x60 ölçü verdik, tipini seçtik.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
 //MARK: -IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
 
        dismissKeyboard()
         
        if checkFieldsAreCompleted() {
            saveItems()
            NotificationCenter.default.post(name: NSNotification.Name(itemAddToCategory), object: nil)
        } else {
            ErrorController.alert(alertInfo: AlertKey.fillMessage, page: self)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGalleryForItems()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) { // keyboardu kapatabilmek için bunu kullanıyoruz.
        dismissKeyboard()
        
    }
    
    //MARK: - Helper functions
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreCompleted() -> Bool {
        return (titleLabel.text != "" && priceTextField.text != "" && descriptionTextView.text != "" &&
                stockOfItem.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)

    }
    
    //MARK: - Item saving
    
    private func saveItems() {
        
        showLoadingIndicator()
        
        let item = items
        
        item.id = UUID().uuidString
        item.name = titleLabel.text!
        item.categoryID = category.id
        item.description = Helper.characterCheck(text: descriptionTextView.text!) 
        item.price = Double(priceTextField.text!) ?? 0.0
        item.stock = Int(stockOfItem.text!) ?? 0
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, imageFileName: "ItemImages", itemID: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                
                Items().saveItemsToFirestore(item)
                self.hideLoadingIndicator()
                self.popTheView()
            }
            
        } else {
            
            items.saveItemsToFirestore(item)
            hideLoadingIndicator()
            popTheView() 
        }
        
    }
    
//MARK: - Activity Indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil{
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
//MARK: - Show gallery
    private func showImageGalleryForItems() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab] // Galeri kütüphanesi içinde hazır bulunan tab /sekme gösterme özelliğini tabsToShow olarak çağırdık ve imageların olduğu ve kameranın olduğu iki tab açmasını söyledik.
        Config.Camera.imageLimit = 6 // kamerayı 6 fotoğraf ile kısıtladık.
        
        self.present(self.gallery, animated: true, completion: nil) // Küçük bir detay olarak bu aşamada kamera ve fotoğrafların kullanımı için Info.plist içerisinde bu kullanımı seçmeli ve kullanıcıdan onay istemeliyiz. aksi takdirde uygulama crash edecektir. 
        
    }

}

extension ItemAddViewController: GalleryControllerDelegate { // Galeriye eklenmiş olan fotoğrafların seçimi kamera kullanımı için gerekli protocol
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
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
