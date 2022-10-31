//
//  Downloader.swift
//  BuyMe!
//
//  Created by obss on 10.10.2022.
//

import Foundation
import FirebaseStorage

let storge = Storage.storage() // firebase storeage erişim imkanı sunduk.

func uploadImages(images: [UIImage?], imageFileName: String, itemID: String, completion: @escaping (_ imageLinks: [String]) -> Void) { //save etmek istediğimiz imageların arrayini alacak, hangi iteme ait olduğu bilgisiyle berabe yükleyecek ve bize callback olarak bir imagelinkleri arrayi verecek
    
    if Reachabilty.HasConnection(){ // eğer internet erişimi varsa
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0 //kullanma sebebimiz firestore'a aynı isimle birkaç fotoğraf kayıt edildiğinde üst üste yazabiliyor bu yüzden kayıt edilecek isimlere image1 image2 gibi isimler verdirmemiz gerekiyor.
        
        for image in images {
            
            let fileName = imageFileName + "/" + itemID + "/" + "\(nameSuffix)" + ".jpg" //ekleyeceğimiz her bir fotoğrafa dosya ismi veriyoruz isim formatımız: ItemImages/91234D3264/0.jpg olacak böylece aynı item ID'ye sahip fotoğraflar üst üste yazılmayacak ve ayrı olarak gruplanabilecek
            let imageData = image!.jpegData(compressionQuality: 0.01) //imagelarımız PHAuth formatında bu format bizim için uygun değil bu yüzden storage yaparken sıkıştırmamız ve dönüştürmemiz gerekiyor.
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
        
    } else {
        func Error(page: UIViewController) { // kullanıcıya bildirim çıkart ve bir önceki sayfaya gönder!
            ErrorController.alert(alertInfo: AlertKey.connectionError, page: page)
        }
    }
    
    //MARK: - Save Image to Firestore
    
    func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
        var task: StorageUploadTask!
        let storageRef = storge.reference(forURL: imageStorageLink).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil, completion: { metaData, error in
            task.removeAllObservers()
            
            if error != nil {
              //  ErrorController.alert(alertInfo: AlertKey.somethingError , page: ItemsTableViewController())
                print("IMAGE SAVE ERROR: \(String(describing: error))")
                completion(nil)
                return
            } else {
                storageRef.downloadURL { URL, error in
                    guard let downloadURL = URL else {
                        completion(nil)
                        
                        return
                    }
                    
                    completion(downloadURL.absoluteString)
                }
            }
        })
    }
}
//MARK: - Download images from Firestore

func downloadImagesFromFirestore(imageUrls: [String], completion: @escaping(_ images:[UIImage?]) -> Void) {
    
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0

    for link in imageUrls {
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imageArray.append(UIImage(data: data as! Data)! )
                
                if downloadCounter == imageArray.count {
                     
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
            } else {
                //ErrorController.alert(alertInfo: AlertKey.downloadError, page: ItemsTableViewController())
                print("Foto yok foto!")
                completion(imageArray)
            }
        }
        
    }
}
