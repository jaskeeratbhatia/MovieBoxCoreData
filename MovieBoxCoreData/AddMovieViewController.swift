//
//  AddMovieViewController.swift
//  MovieBoxCoreData
//
//  Created by Jaskeerat Singh Bhatia on 2017-04-02.
//  Copyright © 2017 Jaskeerat Singh Bhatia. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let actorNames = ["Diljit Dosanjh","Shah Rukh Khan","Ranbir Kapoor","Sushant Singh Rajput","Akshay Kumar"]
    let actressNames = ["Kareena Kapoor","Deepika Padukone","Anushka Sharma", "Priyanka Chopra", "Huma Qureshi"]
    let genreNames = ["Action","Comedy","Thriller", "Romance", "Biography"]
    
    let actorPicker = UIPickerView()
    let actressPicker = UIPickerView()
    let genrePicker = UIPickerView()
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var txtfield: UITextField!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var actorTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var actressTextField: UITextField!
    @IBOutlet weak var releaseDateTxtField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editMovieLabel: UILabel!
    @IBOutlet weak var addMovieLabel: UILabel!
    var movie : Movies?
    var fetchedMovies : [Movies] = []
    var movieName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveChangesButton.isHidden = true
        editMovieLabel.isHidden = true
        
        if movie != nil{
            saveChangesButton.isHidden = false
            editMovieLabel.isHidden = false
            addMovieLabel.isHidden = true
            addButton.isHidden = true
            txtfield.text = movie?.movieName
            movieImageView.image = UIImage(data: movie?.movieImage as! Data)
            actorTextField.text = movie?.actorName
            actressTextField.text = movie?.actressName
            genreTextField.text = movie?.movieGenre
            releaseDateTxtField.text = movie?.movieReleaseDate
            durationTextField.text = movie?.movieDuration
            movieName = txtfield.text!
        }
        
        // define the tags for the picker views
        actorPicker.tag = 0
        actressPicker.tag = 1
        genrePicker.tag = 2
        
        // define delegate and datasource for all picker views
        actorPicker.dataSource = self
        actorPicker.delegate = self
        actressPicker.delegate = self
        actressPicker.dataSource = self
        genrePicker.dataSource = self
        genrePicker.delegate = self
        
        // provide input for text fields
        actorTextField.inputView = actorPicker
        actressTextField.inputView = actressPicker
        genreTextField.inputView = genrePicker
        
        //Call the function for datepicker
        createDatePicker()
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return actorNames.count
        }
        else if pickerView.tag == 1
        {
            return actressNames.count
        }
        else if pickerView.tag == 2
        {
            return genreNames.count
        }
        
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0
        {
            return actorNames[row]
        }
        else if pickerView.tag == 1
        {
            return actressNames[row]
        }
        else if pickerView.tag == 2
        {
            return genreNames[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 0
        {
            actorTextField.text = actorNames[row]
        }
        else if pickerView.tag == 1
        {
            actressTextField.text = actressNames[row]
        }
        else if pickerView.tag == 2
        {
            genreTextField.text = genreNames[row]
        }
        
        self.view.endEditing(false)
        
    }
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        movieImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        
        if txtfield.text == nil || actorTextField.text == nil || genreTextField.text == nil || actressTextField.text == nil || releaseDateTxtField.text == nil || durationTextField.text == nil || movieImageView.image == #imageLiteral(resourceName: "defaultImage") {
            
            let alert  = UIAlertController(title: "Error", message: "One or more details are missing", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
            
        else{
            
            let imageData = UIImageJPEGRepresentation(movieImageView.image!, 1)
            let managedContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let movie = Movies(context: managedContext)
            
            movie.movieName = txtfield.text!
            movie.movieImage = imageData as NSObject?
            movie.actorName = actorTextField.text
            movie.actressName = actressTextField.text
            movie.movieGenre = genreTextField.text
            movie.movieDuration = durationTextField.text
            movie.movieReleaseDate = releaseDateTxtField.text
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            navigationController!.popViewController(animated: true)
            
        }
    }
    
    @IBAction func onClickSaveChanges(_ sender: Any) {
        
        getData()
        
        for i in fetchedMovies
        {
            if i.movieName == movieName
            {
                if txtfield.text == nil || actorTextField.text == nil || genreTextField.text == nil || actressTextField.text == nil || releaseDateTxtField.text == nil || durationTextField.text == nil || movieImageView.image == #imageLiteral(resourceName: "defaultImage") {
                    
                    let alert  = UIAlertController(title: "Error", message: "One or more details are missing", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    i.setValue(txtfield.text!, forKey: "movieName")
                    i.setValue(actorTextField.text!, forKey: "actorName")
                    i.setValue(actressTextField.text!, forKey: "actressName")
                    i.setValue(genreTextField.text, forKey: "movieGenre")
                    i.setValue(durationTextField.text, forKey: "movieDuration")
                    i.setValue(releaseDateTxtField.text, forKey: "movieReleaseDate")
                    let imageData = UIImageJPEGRepresentation(movieImageView.image!, 1)
                    i.setValue(imageData as NSObject?, forKey: "movieImage")
                    
                    //Update Context
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    navigationController!.popViewController(animated: true)
                    
                }
            }
            
        }
    }
    
    func createDatePicker()
    {
        //datepicker format
        datePicker.datePickerMode = .date
        
        //create toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .blackTranslucent
        
        // bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        // add toolbar to datepicker
        releaseDateTxtField.inputAccessoryView = toolbar
        
        // assigning date picker to text field
        releaseDateTxtField.inputView = datePicker
        
    }
    
    func donePressed()
    {
        //date format
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        releaseDateTxtField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func getData()
    {
        do{
            fetchedMovies = try managedContext.fetch(Movies.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
    }
    
   }
