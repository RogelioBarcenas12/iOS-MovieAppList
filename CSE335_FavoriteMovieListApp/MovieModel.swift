//
//  MovieModel.swift
//  CSE335_FavoriteMovieListApp
//
//  Created by Rogelio Barcenas on 10/17/16.
//  Copyright © 2016 Rogelio Barcenas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MovieData: UIResponder, UIApplicationDelegate
{

    let insertContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var viewContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var deleteContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchResults = [MovieEntity]()//make an array of ImageRep Entities
    
    var RecordCount: Int = 0
    
    var CurrentRecord: Int = 0
    
    
    ///////////////////////////delete a core data entry below
    
    func removeFromCoreData(index : Int)//this function handles the removal of a single core data entry when the user deletes from the table.
    {
        let fetchRequest = NSFetchRequest(entityName: "MovieEntity")
        
        if let fetchResults = (try? viewContext.executeFetchRequest(fetchRequest)) as? [MovieEntity]
        {
            
            let x = fetchResults.count
            
            if x != 0
            {
                let l = fetchResults[index]//this is where the selected image will be
                viewContext.deleteObject(l)
                
                do{//need this part to save to core data so that it can be accessed in other view controllers
                    try viewContext.save()
                }catch let error
                {
                    print("Movie could not be deleted from core data\(error)")
                }
                
            }
            
        }
        
        
    }
//////////////////////////////////////////////////////////
    
    func AddMovieToCoreData(UserEnteredTitle: String, UserEnteredYear: String)
    {
        let ent = NSEntityDescription.entityForName("MovieEntity", inManagedObjectContext: self.insertContext)
        
        let newItem = MovieEntity(entity: ent!, insertIntoManagedObjectContext: self.insertContext)
        
        newItem.title = UserEnteredTitle//store name of the place
        
        newItem.year = UserEnteredYear//store descriptio of the place
        
        do{//need this part to save to core data so that it can be accessed in other view controllers
            try insertContext.save()
        }catch let error
        {
            print("Movie could not be saved to core data\(error)")
        }
        
        
        print(newItem)
    }
    
//////////////////////////////////////////////////////////
    func getNumberofMovies() -> Int
    {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "MovieEntity")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of LogItem objects
        fetchResults = ((try? insertContext.executeFetchRequest(fetchRequest)) as? [MovieEntity])!
        
        
        x = fetchResults.count
        
        //print(x)
        
        
        return x
        
        
    }
//////////////////////////////////////////////////////////
    func getTitle(index : Int) -> String//returns movie title
    {
        
        var temp = " "
        
        let fetchRequest = NSFetchRequest(entityName: "MovieEntity")
        
        if let fetchResults = (try? viewContext.executeFetchRequest(fetchRequest)) as? [MovieEntity]
        {
            
            let x = fetchResults.count
            
            if x != 0
            {
                let l = fetchResults[index]//this is where the selected image will be
                
                temp = l.title as String
                
                return temp
                
            }
            
        }
        
        return temp
    }
//////////////////////////////////////////////////////////
    func checkIfInCoreData(Title: String, Year: String) -> Bool
    {
        var count: Int = 0
        var temptitle = " "
        var tempyear = " "
        
        let fetchRequest = NSFetchRequest(entityName: "MovieEntity")
        
        if let fetchResults = (try? viewContext.executeFetchRequest(fetchRequest)) as? [MovieEntity]
        {
            let x = fetchResults.count
            
            if x != 0
            {
            
                count = x-1
                
                for i in 0...count
                {
                    temptitle = fetchResults[i].title as String
                    tempyear = fetchResults[i].year as String
                    //print(Title)
                    //print(Year)
                    
                    if (temptitle == Title && tempyear == Year)
                    {
                        return true
                    }
                }
            }
            return false
        }
        
        return false
    }
//////////////////////////////////////////////////////////
    func getYear(index : Int) -> String
    {
        
        var temp = " "
        
        let fetchRequest = NSFetchRequest(entityName: "MovieEntity")
        
        if let fetchResults = (try? viewContext.executeFetchRequest(fetchRequest)) as? [MovieEntity]
        {
            
            let x = fetchResults.count
            
            if x != 0
            {
                let l = fetchResults[index]//this is where the selected image will be
                
                temp = l.year as String
                
                return temp
                
            }
            
        }
        
        return temp
    }
//////////////////////////////////////////////////////////
    func checkIfValidYear(strYear: String)-> Bool
    {
        if (Int(strYear) != nil)
        {
            return true
        }
        return false
    }
//////////////////////////////////////////////////////////
    var MovieTitle = " "
    var MovieYear = " "
    var MovieRating = " "
    var MoviePlot = " "
    var MovieCast = " "
    
    
    func testgetMovieInfoJson(MovieTitle: String, MovieYear: String, selector: Int) -> String
    {
        var semaphore = dispatch_semaphore_create(0)
        var returnedMovieTitle = " "
        var returnedMovieYear = " "
        var returnedMovieRating = " "
        var returnedMoviePlot = " "
        var returnedMovieCast = " "
        var returnedtype = " " //this is to make sure that what's being returned is a movie and not a series
        var returnedresponse = " "//if the movie exists or not
        var returnedPosterURL = " "
        
        var formattedMovieTitle = MovieTitle.stringByReplacingOccurrencesOfString(" ", withString: "+")//replaces spaces in movie title with "+" for url
        var formattedMovieTitle2 = formattedMovieTitle.stringByReplacingOccurrencesOfString("é", withString: "%C3%A9")
        var formattedMovieTitle3 = formattedMovieTitle2.stringByReplacingOccurrencesOfString("è", withString: "%C3%A8")
        var formattedMovieTitle4 = formattedMovieTitle3.stringByReplacingOccurrencesOfString("ë", withString: "%C3%AB")
        var formattedMovieTitle5 = formattedMovieTitle4.stringByReplacingOccurrencesOfString("ù", withString: "%C3%B9")
        var formattedMovieTitle6 = formattedMovieTitle5.stringByReplacingOccurrencesOfString("ÿ", withString: "%C3%BF")
        var formattedMovieTitle7 = formattedMovieTitle6.stringByReplacingOccurrencesOfString("ü", withString: "%C3%BC")
        var formattedMovieTitle8 = formattedMovieTitle7.stringByReplacingOccurrencesOfString("ö", withString: "%C3%B6")
        var formattedMovieTitle9 = formattedMovieTitle8.stringByReplacingOccurrencesOfString("õ", withString: "%C3%B5")
        var formattedMovieTitle10 = formattedMovieTitle9.stringByReplacingOccurrencesOfString("ñ", withString: "%C3%B1")
        var formattedMovieTitle11 = formattedMovieTitle10.stringByReplacingOccurrencesOfString("ó", withString: "%C3%B3")
        var formattedMovieTitle12 = formattedMovieTitle11.stringByReplacingOccurrencesOfString("ã", withString: "%C3%A3")
        
        var escapedString = formattedMovieTitle12.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var urlAsString = "http:www.omdbapi.com/"
        urlAsString = urlAsString + "?t=" + escapedString!
        urlAsString = urlAsString + "+&y=" + MovieYear
        urlAsString = urlAsString + "&plot=short&r=json"
        print(urlAsString)
        
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil)
            {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            if (err != nil)
            {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            returnedresponse = jsonResult["Response"] as! String//specififes if the json file has Response = true | false
            //if Response = "False" then it will not contain fields Title, Year, Rated, Plot, Actors, and Type; It will lead to a bad access.
            
            if (returnedresponse == "True")
            {
                
                
                returnedMovieTitle = jsonResult["Title"] as! String
                returnedMovieYear = jsonResult["Year"] as! String
                returnedMovieRating = jsonResult["Rated"] as! String
                returnedMoviePlot = jsonResult["Plot"] as! String
                returnedMovieCast = jsonResult["Actors"] as! String
                returnedPosterURL = jsonResult["Poster"] as! String
                if (returnedPosterURL == " " || returnedPosterURL == "N/A" )
                {
                    returnedPosterURL = "http://thingstado.com/assets/images/no_image.jpg"
                   
                }
                
                
                returnedtype = jsonResult["Type"] as! String
            }
            else
            {
                returnedMovieTitle = "Not Found"
                returnedMovieYear = "N/A"
                returnedMovieRating = "N/A"
                returnedMoviePlot = "N/A"
                returnedMovieCast = "N/A"
                returnedPosterURL = "http://thingstado.com/assets/images/no_image.jpg"
                returnedtype = "movie that was not found."
            }
            
            dispatch_semaphore_signal(semaphore)
            
        })
        jsonQuery.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if (selector == 1)
        {
            return returnedMovieTitle;
        }
        if (selector == 2)
        {
            return returnedMovieYear;
        }
        if (selector == 3)
        {
            return returnedMoviePlot;
        }
        if (selector == 4)
        {
            return returnedMovieCast;
        }
        if (selector == 5)
        {
            return returnedtype;
        }
        if (selector == 6)
        {
            return returnedresponse;
        }
        if (selector == 7)
        {
            return returnedPosterURL;
        }
        return returnedMovieRating;
      
    }
//////////////////////////////////////////////////////////
  
//////////////////////////////////////////////////////////
    
}//end of MovieData class

