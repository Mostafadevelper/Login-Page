

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {

    // Create Outlets :-
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // Create Varaible and Constants :-
    let url = "https://app-api.yalladealz.com/login"
    private let minLength = 4

        override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        displayShape()
       
    }
    
    @IBAction func loginPressedButton(_ sender: Any) {
        
                guard let username = userNameTextField.text?.trimmingCharacters(in: .whitespaces) , !username.isEmpty else {
                    displayErrorMessage(errorMessage: "UserName is Required")
                    return  }
        guard username.count > minLength else { displayErrorMessage(errorMessage: "email must be larger than 5 letters")
            return }
                guard isValidEmail(emailID: username) == true else { displayErrorMessage(errorMessage: "Email is not Valid")
                    return}
                guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) , !password.isEmpty else { displayErrorMessage(errorMessage: "Password is Required")
                    return }
        guard password.count > minLength else  { displayErrorMessage(errorMessage: "password must be larger than 5 letters")
            return }
        
                let params = ["email":username,"password":password]
                ValidUser(url: url, parameters: params)
        
            }
    
            func ValidUser(url: String , parameters : [String:String] ){
        SVProgressHUD.show()
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Accept": "application/json"]).responseString {
                    (response) in
        
                    switch response.result {
        
                    case .failure(let error):
                        print("************* error ***************")
                        SVProgressHUD.dismiss()
                        self.displayErrorMessage(errorMessage: error as! String)
                            print(error)
                    case .success (let value):
                        print("************* success ***************")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "GoToHome", sender: self)
                        print(value)
                                }
            }
 
    }
    
    func isValidEmail(emailID : String)-> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES%@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }

    func displayShape(){
        
        // Border Style :-
        userNameTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        emailView.layer.borderWidth = 1
        passwordView.layer.borderWidth = 1
        loginButton.layer.borderWidth = 1
        
    }
   
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        view.endEditing(true)
    }
    
}

//// MARK: Private Methods
private extension LoginViewController {
    func displayErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

