//
//  DisplayListViewController.swift
//  MovieBoxCoreData
//
//  Created by Jaskeerat Singh Bhatia on 2017-04-02.
//  Copyright © 2017 Jaskeerat Singh Bhatia. All rights reserved.
//

import UIKit

class DisplayListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    var movies : [Movies] = []
    var filteredMovies : [Movies] = []
    
    @IBOutlet weak var myTableView: UITableView!
    let textCellIdentifier = "TextCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentforSearchText(searchText : String , scope : String = "All")
    {
        filteredMovies = movies.filter{ movie in return (movie.movieName?.lowercased().contains(searchText.lowercased()))!}
        myTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        myTableView.dataSource = self
        myTableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentforSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // call the getData
        getData()
        
        //load the tableview
        myTableView.reloadData()
        
        for i in movies
        {
            print(i.movieName!)
        }}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return filteredMovies.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let movieCell :Movies
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            movieCell = filteredMovies[indexPath.row]
        }
        else{
            movieCell = movies[indexPath.row]
        }
        
        cell.textLabel?.text = movieCell.movieName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete{
            
            managedContext.delete(movies[indexPath.row])
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        do{
            
            movies = try managedContext.fetch(Movies.fetchRequest())
        }
        catch{
            print("Fetch Failed")
        }
        
        // myTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.automatic)
        myTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "displayDetails") as! DisplayDetailsViewController
        
        //    self.present(nextViewController, animated:true, completion:nil)
        navigationController?.pushViewController(nextViewController, animated: true)
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            nextViewController.movie = filteredMovies[indexPath.row]
        }
        else{
            nextViewController.movie = movies[indexPath.row]
        }
        
        //performSegue(withIdentifier: "toDisplayData", sender: nil)
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
