import UIKit

User().registerUser(email: email, password: password) { error in
    if error != nil {
        ErrorController.alert(alertInfo: "Verification e-mail sended! Please verify your account!", page: self)
        self.signInStatus = true
     
    } else {
        self.prepare(for: UIStoryboardSegue.init(identifier: signinSucces, source: LoginViewController().self, destination: CategoryCollectionViewController().self), sender: (Any).self)
        self.signInStatus = false
        self.dismiss(animated: true)
    }
}
}
