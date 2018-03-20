//
//  ViewController.swift
//  Twitter
//
//  Created by robin on 2018-03-17.
//  Copyright © 2018 robin. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    // outlets
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var userTextBox: UITextField!
    
    // When you work with CoreData, you must inlcude a "context"
    // variable. This is the variable you use to interact with the database.
    // Similar to:
    // $db = mysqli_connect("localhost", "", "", "")
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // This variable will store a User
    // Initially, the variable doesnt have a value
    // This is similar to doing:
    //      User userA;
    //  or
    //      User userA = new User()
    var userA : User?
    
    // In this function, I am querying the database for a user
    // named "marcos.bittencourt". 
    // If the user exists, then set the userA variable to "mbittencourt"
    // Otherwise, create a new user called "mbittencourt"
    override func viewDidLoad() {
        super.viewDidLoad()

        
        textview.text = ""
        
        // 1. Search the database for a user called 'mbittencourt'
        // The SQL command being run is:
        // SELECT * FROM User WHERE name == 'mbittencourt' LIMIT 1
        let request : NSFetchRequest<User> = User.fetchRequest()
        let query = NSPredicate(format: "name == %@", "mbittencourt")
        request.predicate = query
        request.fetchLimit = 1;      // command to tell the db to return 1 user
        
        do {
            let results = try myContext.fetch(request)
            
            if results.count == 0 {
                // 2. If unable to find a matching user, then
                // create a new user called mbittencourt
                
                userA = User(context: myContext)
                userA!.name = "mbittencourt"
                
            }
            else {
                // 3. You were able to find a matching user in the
                // database. so set the userA variable
                userA = results[0]
                
                
                // 4. load all pre-existing tweets made by mbittencourt
                // (scroll down and look at the loadTweets function)
                loadTweets()
            }
        }
        catch {
            print("Error while saving users")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadTweets() {
        
        // The SQL statement here is:
        // SELECT * FROM Tweet
        let request : NSFetchRequest<Tweet> = Tweet.fetchRequest()
        
        do {
            // There is more than 1 tweets in the database,
            // so the database will send you the results back as an
            // ARRAY of TWEET objects.
            let databaseResults = try myContext.fetch(request)
            
            
            // Loop through the array and get the user's name and tweet
            // Then show the tweet in the textbox
            for tweet in databaseResults {
                let user = tweet.user!
                let t = tweet.text!
                
                // textView.inserText appends your string to the end
                textview.insertText("@\(user.name!) \(t) \n")
            }
        }
        catch {
            print("error while getting tweets")
        }

    }

    
    @IBAction func tweetButtonPressed(_ sender: UIButton) {
        
        // get what the person wrote in the text box
        let t = textBox.text!
        
        //------ save the tweet to the database
        
        // 1: Create a new Tweet object
        let tweet = Tweet(context: myContext)
        tweet.text = t;
        
        // 2: Set the user for this tweet to user1 (mbittencourt)
        // This is how you can use the RELATIONSHIP between a User and Tweet
        tweet.user = userA;
    
        // 3: Save the Tweet to the database
        do {
            try myContext.save()
            print("done saving")
        }
        catch {
            print("an error occured while saving: \(error)")
        }
        
        //------ show the tweet and the user in the textview
        textview.insertText("@\(userA!.name!) \(tweet.text!) \n")
    }
}
