//
//  Category.swift
//  BuyMe!
//
//  Created by obss on 5.10.2022.
//
//MARK: - Kategorileri modellediğimiz, Firestoredan isimlerini almasını sağlayacak initilazerları tanımladığımız bir class yarattık.
import Foundation
import UIKit

//MARK: - Kategori sınıfımızın içeriklerini belirledik.
class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init (_name: String, _imageName: String) { // içeriklerin tanımlamalarını ve tiplerini yazdık
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init (_dictionary: NSDictionary) { // içeriklerin bir dictionary olarak depolanacağı initilazerı tanımladık ve içeriğin yapısını tanımladık.
        
        id = _dictionary[keyObjectID] as! String
        name = _dictionary[keyName] as! String
        image = UIImage(named: _dictionary[keyImageName] as? String ?? "")
        
    }
}

//MARK: - Downloading Categories from Firebase

func downloadCategoriesFromFirebase(completion: @escaping(_ categoryArray: [Category]) -> Void) { //Uygulama run edildiğinde bazı verilen databaseden senkronize bir şekilde alınması ve işlenmesi gerekiyor bu yüzden completion içeren bir fonksiyon yaratarak her load edilmede bu fonksiyonu çağrıyoruz. completion firebase içinde olan verileri Category arrayine işliyor ve fonksiyonu çağrıyor.
    
    var categoryArray: [Category] = [] // verilerin içine initilaze edilebilmesi için bir array yaratıyoruz.
    
    firebaseReference(.Category).getDocuments { snapshot, error in // callback devam edebilmek için ilk önce kontrol yapmalı, eğer firebase içinde hiç bir şey yoksa hiç birşey dönmeyecektir. uygulamanın crash etmemesi için bu kontrolü yapmamız gerekir.
        guard let snapshot = snapshot else {//snapshot olarak isimlendirdiğimiz query içeriğinin varlığını kontrol ediyoruz. eğer içerik yoksa boş olarak geri dönüyor burada
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty { // bu da 2. kontrol kısmı snapshotın içini kontrol ediyor eğer snapshot boş değilse categoryArray'e erişiyor ve içine Category classı içinde yarattığımız dictionary'i append ediyor.
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
            
        }
        completion(categoryArray)
    }
}

//MARK: - Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString // id oluşturmak için bir id generator yaratıyoruz.
    category.id = id // yarattığımız kategorilere uygulamamız yarattığı id'yi atıyor.
    
    firebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any]) //firebase'e yaratılan id'yi kaydediyor. Key bir string ve karşılığı any olarak database'e veriyi aktarıyoruz.
    
}

//MARK: - Helpers / Kategoriler için bir kütüphane yaratıyoruz id ye bağlı olarak isim image ve image name verilerini setlediğimiz bir yapı yaratıyoruz. Aslında bu fonksiyon bir converter olarak çalışıyor.

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName as Any], forKeys: [keyObjectID as NSCopying, keyName as NSCopying, keyImageName as NSCopying])
    
   
    
}
//MARK: -Creating of categories, tek kullanımlık fonksiyon. kategorileri yaratıyor. Bu fonksiyonu çağırdığımızda içinde tanımlı olan kategorileri firebase üzerinde yaratıp save ediyor. Uygulama run edildiğinde dolaylı yoldan çalışmış oluyor. kategori eklemek istediğimizde buraya ekleme yaparak commentten çıkartıp tekrar run ediyoruz. updatelemiş oluyor.

func createCategorySet() {

     let womenClothing = Category(_name: "Women's Clothing & Accessories", _imageName: "womenCloth")
     let footWaer = Category(_name: "Footwaer", _imageName: "footWaer")
     let electronics = Category(_name: "Electronics", _imageName: "electronics")
     let menClothing = Category(_name: "Men's Clothing & Accessories" , _imageName: "menCloth")
     let health = Category(_name: "Health & Beauty", _imageName: "health")
     let baby = Category(_name: "Baby Stuff", _imageName: "baby")
     let home = Category(_name: "Home & Kitchen", _imageName: "home")
     let car = Category(_name: "Automobiles & Motorcyles", _imageName: "car")
     let luggage = Category(_name: "Luggage & bags", _imageName: "luggage")
     let jewelery = Category(_name: "Jewelery", _imageName: "jewelery")
     let hobby =  Category(_name: "Hobby, Sport, Traveling", _imageName: "hobby")
     let pet = Category(_name: "Pet products", _imageName: "pet")
     let industry = Category(_name: "Industry & Business", _imageName: "industry")
     let garden = Category(_name: "Garden supplies", _imageName: "garden")
     let camera = Category(_name: "Cameras & Optics", _imageName: "camera")

     let arrayOfCategories = [womenClothing, footWaer, electronics, menClothing, health, baby, home, car, luggage, jewelery, hobby, pet, industry, garden, camera]

    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }

}


