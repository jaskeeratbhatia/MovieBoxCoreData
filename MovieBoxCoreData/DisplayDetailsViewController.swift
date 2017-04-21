//
//  DisplayDetailsViewController.swift
//  MovieBoxCoreData
//
//  Created by Jaskeerat Singh Bhatia on 2017-04-03.
//  Copyright © 2017 Jaskeerat Singh Bhatia. All rights reserved.
//

import UIKit

class DisplayDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var actressLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    

    var movie : Movies?
    var movies : [Movies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
        movieLabel.text = movie?.movieName
        movieImage.image = UIImage(data: movie?.movieImage as! Data)
        actorLabel.text = movie?.actorName
        actressLabel.text = movie?.actressName
        durationLabel.text = (movie?.movieDuration)! + "minutes"
        releaseDateLabel.text = "Releasing on " + (movie?.movieReleaseDate)!
        genreLabel.text = movie?.movieGenre
        
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addDetails") as! AddMovieViewController
        navigationController?.pushViewController(nextViewController, animated: true)
        nextViewController.movie = movie
    }
    
    func getData()
    {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            movies = try managedContext.fetch(Movies.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
        
        
    }
    
}
