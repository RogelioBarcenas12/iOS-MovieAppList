//
//  ViewController.swift
//  CSE335_FavoriteMovieListApp
//
//  Created by Rogelio Barcenas on 10/16/16.
//  Copyright © 2016 Rogelio Barcenas. All rights reserved.
//

import UIKit
import CoreData

let add = MovieData();

class ViewController: UIViewController , UIWebViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate
{
    
    @IBOutlet weak var MovieTitleLabel: UILabel!
    
    @IBOutlet weak var UserEnteredTitle: UITextField!
    @IBOutlet weak var UserEnteredYear: UITextField!
    
    @IBOutlet weak var WarningLabel: UILabel!
    
    
    @IBOutlet weak var MoviePicture: UIImageView!
    
    @IBOutlet weak var DisplayMovieTitle: UITextField!
    @IBOutlet weak var DisplayDate: UITextField!
    @IBOutlet weak var DisplayRating: UITextField!
    @IBOutlet weak var DisplayCast: UITextField!

    
    @IBOutlet weak var DisplayPlot: UILabel!
    
    var Success: Bool = false
    var returntype = String()
    var response = String()
    var movieImagURL = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        if(add.getNumberofMovies() == 0)
        {
            let alertController = UIAlertController(title: "Hi, I'm Hal!", message: "I'll be assisting you with movie searchs. Enter an approximate title and year and I will get a description of the movie. If it's the one, add it. If it's not, fix the title or year.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        if (add.getNumberofMovies() >= 1)
        {
            let alertController = UIAlertController(title: "Welcome back!", message: "You have movies to view from your list.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        DisplayPlot.numberOfLines = 0
        self.DisplayPlot.hidden = true
        self.WarningLabel.hidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///////////////////////////Keyboard///////////////////////////////////
    // move the view upwards as keyboard appears
    func keyboardWillShow(sender: NSNotification) {//func no necessary
        
        self.view.frame.origin.y -= 0
        
    }
    
    // move the keyboard back as keyboard disapears
    //you can literally remove willhide and will show funcs
    func keyboardWillHide(sender: NSNotification) {//func not necessary
        
        self.view.frame.origin.y += 0//
        
    }
    
    // make the keyboard disapear as user touches outside the  text boxes
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        
    }
    //////////////////////////////////////////////////////////////////////
    
    @IBAction func AddMovieButton(sender: UIButton)
    {
        if (Success == true || (!(DisplayMovieTitle.text?.isEmpty)! && !(DisplayDate.text?.isEmpty)!))
        {
            print(returntype)
            if (returntype == "movie")
            {
                
                 if(add.checkIfInCoreData(DisplayMovieTitle.text!, Year: DisplayDate.text!) == false)
                 {
                    add.AddMovieToCoreData(DisplayMovieTitle.text!, UserEnteredYear: DisplayDate.text!)
                    WarningLabel.hidden = false
                    WarningLabel.text = "Movie Successfully Added!"
                 }
                 else
                 {
                    let alertController = UIAlertController(title: "I'm sorry. I'm afraid I can't do that.", message: "The movie title and year you entered is already in your watch list!", preferredStyle: .Alert)
                 
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                 }
                 
            }
            else
            {
                let alertController = UIAlertController(title: "I'm sorry. I'm afraid I can't do that.", message: "What you entered is not a movie but a " + returntype + ".", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        else
        {
            let alertController = UIAlertController(title: "I'm sorry. I'm afraid I can't do that.", message: "Try searching for a movie first.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func GoToMovieListButton(sender: AnyObject)
    {
        if (add.getNumberofMovies() == 0)//if there are no movies don't show the table
        {
            let alertController = UIAlertController(title: "I'm sorry. I'm afraid I can't do that.", message: "You do not have a movie list. Add movies to the list first.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            if (WarningLabel.hidden == false)
            {
                WarningLabel.hidden = true
                WarningLabel.text = " "
            }
             self.performSegueWithIdentifier("Table", sender: nil)
        }
        
    }
    

    @IBAction func GetMovieInfoJSon(sender: UIButton)
    {
        //http://www.omdbapi.com/?t=Batman+&y=1989&plot=short&r=json
        
        //Using Quotes from movie since it's relevant for my app and Hal is the button and needs to repsond to user "errors"...
        //2001: A Space Odyssey (1968)
          //Quotes: Hal: "I'm sorry, Dave. I'm afraid I can't do that."
                  //Hal: "I think you know what the problem is just as well as I do."
                  //Hal: "Just what do you think you're doing, Dave?"
        
        if(UserEnteredTitle.text!.isEmpty && UserEnteredYear.text!.isEmpty)
        {
            WarningLabel.hidden = false
            Success = false
            WarningLabel.text = "You have to enter a title and year!"
            
            let alertController = UIAlertController(title: "I'm sorry. I'm afraid I can't do that.", message: "Try entering a title and year.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else if(UserEnteredTitle.text!.isEmpty)
        {
            WarningLabel.hidden = false
            Success = false
            WarningLabel.text = "You have to enter a title!"
            let alertController = UIAlertController(title: "I think you know what the problem is just as well as I do.", message: "Try entering the Title.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else if(UserEnteredYear.text!.isEmpty)
        {
            WarningLabel.hidden = false
            Success = false
            WarningLabel.text = "You have to enter a year!"
            
            let alertController = UIAlertController(title: "Just what do you think you're doing?", message: "Try entering the Year. Even if you are unsure I will get the approximate movie with the year you entered.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else if(add.checkIfValidYear(UserEnteredYear.text!) == false)
        {
            let alertController = UIAlertController(title: "Just what do you think you're doing?", message: "Try entering a singular valid Year.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            if (WarningLabel.hidden == false)
            {
                WarningLabel.hidden = true
                WarningLabel.text = " "
            }
            Success = true
            let MovieTitle = UserEnteredTitle.text
            let MovieYear = UserEnteredYear.text
            
            dispatch_async(dispatch_get_main_queue()){self.response = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 6)}
            
            dispatch_async(dispatch_get_main_queue()){self.returntype = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 5)}
            
            dispatch_async(dispatch_get_main_queue()){self.DisplayMovieTitle.text = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 1)}
            
            dispatch_async(dispatch_get_main_queue()){self.DisplayDate.text = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 2)}
            
            dispatch_async(dispatch_get_main_queue()){self.DisplayRating.text = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 0)}
            
            self.DisplayPlot.hidden = false;
            
            dispatch_async(dispatch_get_main_queue()){self.DisplayPlot.text = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 3)}
            
            dispatch_async(dispatch_get_main_queue()){self.DisplayCast.text = add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 4)}
            

                dispatch_async(dispatch_get_main_queue()){
                    
                    let url = NSURL(string: add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 7))
                    
                    if url != nil
                    {
                        //need to look into this
                        if NSData(contentsOfURL: NSURL(string: add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 7))!) == nil
                        {
                            self.MoviePicture.image = UIImage(named: "Noimage.jpg");
                        }
                        else{
                            self.MoviePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: add.testgetMovieInfoJson(MovieTitle!, MovieYear: MovieYear!, selector: 7))!)!)
                        }
                    }
                    else
                    {
                        self.MoviePicture.image = UIImage(named: "Noimage.jpg");
                    }
            
            }
            
        }
        
    }
    

    
   
}
