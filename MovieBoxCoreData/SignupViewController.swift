//
//  SignupViewController.swift
//  MovieBoxCoreData
//
//  Created by Jaskeerat Singh Bhatia on 2017-04-02.
//  Copyright © 2017 Jaskeerat Singh Bhatia. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    
    var user : Users?
    var fetchedUsers : [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onDoneClick(_ sender: UIBarButtonItem) {
        
        getData()
        var isDuplicate = false
        print("Done Pressed")
        if (emailTxt.text == "" || nameTxt.text == "" || confirmPasswordTxt.text == "" || nameTxt.text == "")
        {
            let alert  = UIAlertController(title: "Error", message: "One or more details are missing", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            
            for i in fetchedUsers
            {
                if i.userEmail == emailTxt.text
                {
                    isDuplicate = true
                }
            }
            
            if isDuplicate
            {
                let alert  = UIAlertController(title: "Error", message: "Email already registered", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
                
            else
            {
                if isValidEmail(testStr: emailTxt.text!)
                {
                    if isValidPassword(testStr: passwordTxt.text!)
                    {
                        if (passwordTxt.text == confirmPasswordTxt.text)
                        {
                            let user = Users(context : managedContext)
                            
                            user.userName = nameTxt.text
                            user.userEmail = emailTxt.text
                            user.password = passwordTxt.text
                            
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            
                            let actionSheet = UIAlertController(title: nil, message: "You have been successfully registered", preferredStyle: .actionSheet)
                            
                            // Create UIAlertAction for UIAlertController
                            
                            let loginAction = UIAlertAction(title: "Go to Login", style: .default, handler: {
                                (alert: UIAlertAction!) -> Void in
                                self.navigationController?.popViewController(animated: true)
                            })
                            
                            
                            actionSheet.addAction(loginAction)
                            
                            self.present(actionSheet, animated: true, completion: nil)
                            
                            
                        }
                            
                        else{
                            let alert  = UIAlertController(title: "Error", message: "Passwords do not match. Try again", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    else{
                        let alert  = UIAlertController(title: "Error", message: "Password should be more than 6 charcaters and must contain 1 uppercase, 1 lowercase and 1 specialCharacter", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                    
                else {
                    let alert  = UIAlertController(title: "Error", message: "Invalid email format.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    
    
    func getData()
    {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            
            fetchedUsers = try managedContext.fetch(Users.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func isValidPassword(testStr : String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z].)(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: testStr)
        return result
        
    }
    
}
