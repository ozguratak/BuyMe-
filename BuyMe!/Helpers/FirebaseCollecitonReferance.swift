//
//  FirebaseCollecitonReferance.swift
//  BuyMe!
//
//  Created by obss on 5.10.2022.
//

//MARK: - FireStroe içeriklerini tanımladığımız referans yönetim kodu

import Foundation
import FirebaseFirestore

//MARK: CollectionReference, Firestore içerisinde verileri oluşturabilmek için firebaseReference adında bir fonksiyon yarattık. Bu fonksiyonun görevi firebase'in kendi kullanımına göre yazdığı JSON formata hızlı erişim yapabilmek için. kısaca 24. satırı her seferinde baştan yazmamak için bu fonksiyonu çağırıyoruz. Bu fonksiyon bizden collection istiyor. collectionlarımızı enum olarak oluşturduk çünkü her bir case'in kendine göre özelleştirilmiş initleri var ve kendine özel değerler alabiliyor.
enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Basket
    case Order
}
//MARK: Yaratılan bu fonksiyonun görevi JSON formatında gelen verinin hızlı bir şekilde okunabilmesi ve bu verinin ilgili case'ine göre çağrılıp get veya set edilebilmesini kolaylaştırmaktır. 
func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
