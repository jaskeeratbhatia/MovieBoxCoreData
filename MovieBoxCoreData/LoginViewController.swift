//
//  ViewController.swift
//  MovieBoxCoreData
//
//  Created by Jaskeerat Singh Bhatia on 2017-04-02.
//  Copyright © 2017 Jaskeerat Singh Bhatia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedUsers : [Users] = []
    
    @IBOutlet weak var emailtxt: UITextField!
    
    @IBOutlet weak var passwordtxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        emailtxt.text="xxxxx@gmail.com"
        passwordtxt.text="123456"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        getData()
        var isfound = false
        
        for i in fetchedUsers
        {
            if(i.userEmail == emailtxt.text)
            {
                isfound = true
                if(i.password == passwordtxt.text)
                {
                    self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "displayList"))! as! DisplayListViewController, animated: true)
                    
                }
                else{
                    
                    let alert  = UIAlertController(title: "Error", message: "Password is wrong", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        if isfound == false
        {
            let alert  = UIAlertController(title: "Error", message: "User is not registered", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "signUp"))! as! SignupViewController, animated: true)
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
    
}
