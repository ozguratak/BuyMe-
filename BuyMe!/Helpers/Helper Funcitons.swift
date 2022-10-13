//
//  Alerts And Errors.swift
//  BuyMe!
//
//  Created by obss on 7.10.2022.
//
//MARK: - Error kontrol sınıfı uygulama genelinde sıklıkla kullanılan pop-up hata mesajlarının singleton olarak toparlanmış bir sınıfıdır. fonksiyon singleton ile çağrıldıktan sonra hata mesajı ve ViewController bilgileri verilerek kullanılabilir.
import Foundation
import UIKit
import NVActivityIndicatorView



class ErrorController {
    
    static func alert(alertInfo: String, page: UIViewController) {
        let alertVC = UIAlertController(title: AlertKey.error, message: alertInfo, preferredStyle: .alert)
        let okButton = UIAlertAction(title: AlertKey.ok, style: .default) { action in
            page.navigationController?.popToViewController(page, animated: true)
        }
        alertVC.addAction(okButton)
        page.present(alertVC, animated: true)
    }
}

//MARK: - currency Converter, loader gibi yardımcı fonksiyonlar

class Helper: UIViewController {
    
    static func currencyConverter(value: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        
        return currencyFormatter.string(from: NSNumber(value: value))!
    }
    //MARK: - Loading activity

    var spinner = UIActivityIndicatorView(style: .large)

        override func loadView() {
            view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.7)

            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            view.addSubview(spinner)

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }

}
