//
//  MultiAddActivitiesTableViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/26/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

class MultiAddActivitiesTableViewController: UITableViewController {

    //-----------
    // UI Objects
    //-----------
    
    // Obtain the object reference to the UITableView object
    @IBOutlet var activitiesTableView: UITableView!
    
    
    //-----------------
    // Global Variables
    //-----------------
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // variable for holding Activity Group names
    var groupNames = [String]()
    
    // variable for holding Activity names
    var activityNames = [String]()
    
    // dataObjectToPass is the data object to pass back up to the upstream view controller
    var dataObjectToPassToNewWorkout = [String]()
    
    
    
    //==========================================================================
    // MARK: - UIView Protocol Methods
    //==========================================================================
    
    //----------------------------------------
    // function for setup when this view loads
    //----------------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // allow for multiple selection
        self.tableView.allowsMultipleSelection = true
        
        // Set the title of this ViewController
        self.title = "Activities"
        
        // Obtain the names of Activity Groups from the appDelegate dictionary
        groupNames = applicationDelegate.dict_ActivityGroup_Dict.allKeys as [String]
        
        // Sort the activity group names within itself in alphabetical order
        groupNames.sort { $0 < $1 }
    }
    
    
    //------------------------
    // Memory warning function
    //------------------------
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //==========================================================================
    // MARK: - Table View Data Source Protocol Methods
    //==========================================================================
    
    
    /*
    ---------------------------------------
    Return Number of Sections in Table View
    ---------------------------------------
    */
    
    // Each table view section corresponds to a genre
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return groupNames.count
    }
    
    
    /*
    --------------------------------
    Return Number of Rows in Section
    --------------------------------
    */
    
    // Number of rows in a given Group (section) = Number of Activities in that group
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Obtain the name of the given group
        var givenActivityGroup = groupNames[section]
        
        // Obtain the activities dictionary in the given group
        var dict_Activity_Dict = applicationDelegate.dict_ActivityGroup_Dict[givenActivityGroup] as NSMutableDictionary
        
        // return the count of activities in the given group
        return dict_Activity_Dict.count
    }
    
    /*
    ------------------------------------
    Prepare and Return a Table View Cell
    ------------------------------------
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // instantiate the new tableView cell object to be prepared and returned
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as UITableViewCell
        
        // obtain the section number (Group index)
        var sectionNumber = indexPath.section
        
        // obtain the row number (Activity index)
        var rowNumber = indexPath.row
        
        // Obtain the name of the given group
        var givenGroup = groupNames[sectionNumber]
        
        // get the dictionary of activities from the given group
        var dict_Activity_Data = applicationDelegate.dict_ActivityGroup_Dict[givenGroup] as NSMutableDictionary
        
        // Obtain the names of Activities from the Activity dictionary
        var activityNames = dict_Activity_Data.allKeys as [String]
        
        // Sort the activity names within itself in alphabetical order
        activityNames.sort { $0 < $1 }
        
        // get the selected activity name
        var givenActivity = activityNames[rowNumber]
        
        // Obtain the activity data from the dict
        var activity: AnyObject? = dict_Activity_Data[givenActivity]
        
        // Convert the Objective-C array to Swift array
        var activityData = activity? as [AnyObject]
        
        // Set the cell title to be the activity name
        cell.textLabel.text = givenActivity
        
        // ????????????????????????????????????????????????????????????????????????
        // check for selection of this activity, and set the checkmark accordingly
        if contains(dataObjectToPassToNewWorkout, givenActivity) {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        // ????????????????????????????????????????????????????????????????????????
        
        // Set the cell subtitle to be the workout activities
        var mainMuscles = activityData[1] as [String]
        cell.detailTextLabel?.text = ", ".join(mainMuscles)
        
        // set the cell image to be the image cooresponding to the activity
        cell.imageView.image = UIImage(named: activityData[3] as String)
        
        return cell
    }
    
    /*
    ----------------------------
    Set Title for Section Header
    ----------------------------
    */
    
    // Set the table view section header to be the genre name
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return groupNames[section]
    }
    
    
    /*
    ----------------------------------
    Disallow Editing of Rows (Activities)
    ----------------------------------
    */
    
    // We allow each row (city) of the table view to be editable, i.e., deletable or movable
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    
    //==========================================================================
    // MARK: - Table View Delegate Protocol Methods
    //==========================================================================
    
    
    
    //------------------------------
    // Selection of a Activity (Row)
    //------------------------------
    
    // Tapping a row (activity) selects it for adding to the workout
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Obtain the name of the Group of the selected activity
        var selectedGroup = groupNames[indexPath.section]
        
        // obtain the row number (Activity index)
        var rowNumber = indexPath.row
        
        // get the dictionary of activities from the given group
        var dict_Activity_Data = applicationDelegate.dict_ActivityGroup_Dict[selectedGroup] as NSMutableDictionary
        
        // Obtain the names of Activities from the Activity dictionary
        var activityNames = dict_Activity_Data.allKeys as [String]
        
        // Sort the activity names within itself in alphabetical order
        activityNames.sort { $0 < $1 }
        
        // Obtain the Activity data array from the dictionary
        var activity: AnyObject? = dict_Activity_Data[activityNames[rowNumber]]
        
        // Convert the Objective-C array to Swift array
        var activityData = activity! as [AnyObject]
        
        // Obtain the name of the selected activity
        var activityName = activityNames[rowNumber]
        
        // Add/Remove the name of the selected activity to the activity array
        var i = find(dataObjectToPassToNewWorkout, activityName)
        if (i == nil) {
            dataObjectToPassToNewWorkout.append(activityName)
        }
        else {
            dataObjectToPassToNewWorkout.removeAtIndex(i!)
        }
    }
    
    
    
    
    //==========================================================================
    // MARK: - Navigation
    //==========================================================================
    
    
    
    //--------------------------------------------------------------------------
    // This method is called by the system whenever you invoke the method
    // performSegueWithIdentifier:sender:
    //--------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        //Do Something?
        
    }
    
    
    //------------------------------------------------
    // Method called when user presses the Save button
    //------------------------------------------------
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("AddActivities-Save", sender: self)

    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("AddActivities-Cancel", sender: self)

    }

    
    
    //=======================
    // MARK: - Helper Methods
    //=======================
    
    //-----------------------
    // Error Message function
    //-----------------------
    func showErrorMessage(errorMessage: String) {
        
        // Instantiate an alert view object
        var alertView = UIAlertView()
        
        alertView.title = "Unable to Obtain Data!"
        alertView.message = errorMessage
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
}
