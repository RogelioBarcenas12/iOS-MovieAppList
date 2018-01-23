//
//  tableViewController.swift
//  CSE335_FavoriteMovieListApp
//
//  Created by Rogelio Barcenas on 10/17/16.
//  Copyright © 2016 Rogelio Barcenas. All rights reserved.
//

import UIKit
//import CoreData

class tableViewController: UIViewController , UIWebViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate
{

    @IBOutlet weak var MoviesTable: UITableView!
    
    var test = String()
    
    var MovieT = String()
    
    var MovieY = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    // This is a data source method that will be called when table is loaded
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return addAMovie.Movies.count
        return add.getNumberofMovies()
    }
    
    // This datasource method will create each cell of the table
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = add.getTitle(indexPath.row)
        cell.detailTextLabel?.text = add.getYear(indexPath.row)
        
        return cell;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        // If a row could not be edited we have to return false for the row index
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            add.removeFromCoreData(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.MoviesTable.reloadData()
        }
        
    }

    // segue will be called as a row of the table is selected
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let selectedIndex: NSIndexPath = self.MoviesTable.indexPathForCell(sender as! UITableViewCell)!
        
        self.MovieT = add.getTitle(selectedIndex.row);
        self.MovieY = add.getYear(selectedIndex.row);
        
        if(segue.identifier == "movieDetail")
        {
            if let moviedetailViewController: moviedetailViewController = segue.destinationViewController as? moviedetailViewController
            {
                moviedetailViewController.mTitle = MovieT
                moviedetailViewController.mYear = MovieY
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
