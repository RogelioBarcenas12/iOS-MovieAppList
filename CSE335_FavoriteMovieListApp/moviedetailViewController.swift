//
//  moviedetailViewController.swift
//  CSE335_FavoriteMovieListApp
//
//  Created by Rogelio Barcenas on 10/17/16.
//  Copyright © 2016 Rogelio Barcenas. All rights reserved.
//

import UIKit

class moviedetailViewController: UIViewController , UIWebViewDelegate, UITextViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate
{
    
    
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var ActivityProgess: UIActivityIndicatorView!
    
    @IBOutlet weak var MovieTitleTextField: UITextField!
    
    @IBOutlet weak var YearTextField: UITextField!
    
    var mTitle = String()
    var mYear = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.webView.delegate = self
        self.webView.scrollView.scrollEnabled = true
        self.webView.scalesPageToFit = true
        
        self.MovieTitleTextField.text = self.mTitle
        self.YearTextField.text = self.mYear
        
        load()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func load()
    {
        
        let movietitle = MovieTitleTextField.text
        let movieyear = YearTextField.text
        var formattedMovieTitle = movietitle!.stringByReplacingOccurrencesOfString(" ", withString: "+")//replaces spaces in movie title with "+" for url
        var formattedMovieTitle2 = formattedMovieTitle.stringByReplacingOccurrencesOfString("&", withString: "+")//replaces & in movie title with "+" for url
        
        var formattedMovieTitle3 = formattedMovieTitle2.stringByReplacingOccurrencesOfString("é", withString: "%C3%A9")
        var formattedMovieTitle4 = formattedMovieTitle3.stringByReplacingOccurrencesOfString("è", withString: "%C3%A8")
        var formattedMovieTitle5 = formattedMovieTitle4.stringByReplacingOccurrencesOfString("ë", withString: "%C3%AB")
        var formattedMovieTitle6 = formattedMovieTitle5.stringByReplacingOccurrencesOfString("ù", withString: "%C3%B9")
        var formattedMovieTitle7 = formattedMovieTitle6.stringByReplacingOccurrencesOfString("ÿ", withString: "%C3%BF")
        var formattedMovieTitle8 = formattedMovieTitle7.stringByReplacingOccurrencesOfString("ü", withString: "%C3%BC")
        var formattedMovieTitle9 = formattedMovieTitle8.stringByReplacingOccurrencesOfString("ö", withString: "%C3%B6")
        var formattedMovieTitle10 = formattedMovieTitle9.stringByReplacingOccurrencesOfString("õ", withString: "%C3%B5")
        var formattedMovieTitle11 = formattedMovieTitle10.stringByReplacingOccurrencesOfString("ñ", withString: "%C3%B1")
        var formattedMovieTitle12 = formattedMovieTitle11.stringByReplacingOccurrencesOfString("ó", withString: "%C3%B3")
        var formattedMovieTitle13 = formattedMovieTitle12.stringByReplacingOccurrencesOfString("ã", withString: "%C3%A3")
        var formattedMovieTitle14 = formattedMovieTitle13.stringByReplacingOccurrencesOfString(":", withString: "%3A")
        
        //var escapedString = formattedMovieTitle14.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let webpage: String = "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=" + formattedMovieTitle14 + "+" + movieyear!
        print(webpage)
        
        let url = NSURL(string: webpage)
        let request = NSURLRequest(URL: url!)
        
        
        
        ActivityProgess.hidesWhenStopped = true
        ActivityProgess.startAnimating()
        webView.loadRequest(request)
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
