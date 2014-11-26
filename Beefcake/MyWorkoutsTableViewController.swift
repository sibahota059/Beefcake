//
//  MyWorkoutsTableViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/23/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

class MyWorkoutsTableViewController: UITableViewController {
    
    //-----------
    // UI Objects
    //-----------
    
    // Obtain the object reference to the UITableView object
    @IBOutlet var myWorkoutsTableView: UITableView!
    
    //-----------------
    // Global Variables
    //-----------------
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // variable for holding MyWorkout names
    var workoutNames = [String]()
    
    // dataObjectToPass is the data object to pass to the downstream WorkoutTableViewController
    var dataObjectToPassToWorkout: [String] = ["", ""]
    
    // dataObjectToPass is the data object to pass to the downstream AddWorkoutTableViewController
    var dataObjectToPassToAddWorkout: [String] = ["", ""]
    
    // dataObjectToPass is the data object to pass to the downstream EditWorkoutTableViewController
    var dataObjectToPassToEditWorkout: [String] = ["", ""]
    
    
    
    //===============================================================================================================
    // MARK: - UIView Protocol Methods
    //===============================================================================================================
    
    //----------------------------------------
    // function for setup when this view loads
    //----------------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Set up the Add (+) button on the right of the navigation bar to call the addWorkout method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addWorkout:")
        
        // Display an Add(+) button in the navigation bar (right)
        self.navigationItem.rightBarButtonItem = addButton
        
        // Set the title of this ViewController
        self.title = "My Workouts"
        
        // obtain the workout dictionary from the app delegate
        var myWorkoutsDict = applicationDelegate.dict_WorkoutOrderNumber_Dict
        
        // Obtain the names of MyWorkouts from the appDelegate dictionary
        for var index = 1; index <= myWorkoutsDict.count; ++index {
            
            var workoutDict = myWorkoutsDict.objectForKey(String(index)) as NSMutableDictionary
        
            var keyArray = workoutDict.allKeys as [String]
            
            workoutNames.append(keyArray[0])
        }
        
    }
    
    //------------------------
    // Memory warning function
    //------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    //===============================================================================================================
    // MARK: - Table view data source
    //===============================================================================================================
    

    //----------------------------------------------------------------
    // Return the number of rows (activities) in the MyWorkout TableView
    //----------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workoutNames.count
    }

    //------------------------------------------------------
    // Prepare and Return a Table View Cell for each workout
    //------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // instantiate the new tableView cell object to be prepared and returned
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell", forIndexPath: indexPath) as UITableViewCell
        
        // obtain the section number => 1
        var sectionNumber = indexPath.section
        
        // obtain the row number (Activity index)
        var rowNumber = indexPath.row
        
        // Obtain the name of the given workout
        var givenWorkoutName = workoutNames[rowNumber]
        
        // Set the cell title to be the workout name
        cell.textLabel.text = givenWorkoutName
        
        // set the cell image
        cell.imageView.image = UIImage(named: "workout_icon.png")
        
        /*
        Note that workout names must not be sorted. The order shows how favorite the workout is.
        The higher the order the more favorite the workout is. The user specifies the ordering
        in the Edit mode by moving a row from one location to another.
        */
        
        // Obtain the workout data from the dict with the key corresponding to the rowNumber + 1 *(this accounts for ZERO)
        var workoutDict = applicationDelegate.dict_WorkoutOrderNumber_Dict[String(rowNumber + 1)] as NSMutableDictionary
        
        // Obtain the dictionary of activities for the given Workout
        var activityDict = workoutDict.objectForKey(workoutDict.allKeys[0]) as NSMutableDictionary
        
        // Instantiate an array of strings to hold the activity names
        var activityNames = [String]()
        
        // Obtain the names of the activities from the activityDict dictionary
        for var index = 1; index <= activityDict.count; ++index {
        
            var activityName = activityDict.objectForKey(String(index)) as String
    
            activityNames.append(activityName)
        }
        
        // Set the cell subtitle to be the workout activities
        cell.detailTextLabel?.text = ", ".join(activityNames)
        
        return cell
    }

    
    //----------------------------------------------------------
    // Override to support conditional editing of the table view
    //----------------------------------------------------------
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    


        
    //-------------------------------------------
    // Override to support editing the table view
    //-------------------------------------------
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        }
        else if editingStyle == .Insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    //=======================================================================================================
    // MARK: - Navigation
    //=======================================================================================================

    
    //----------------------------------------------------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //----------------------------------------------------------------------------------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "NewWorkout" {
            
            //Do Nothing
            
        }
        else if segue.identifier == "EditWorkout" {
            
            //TODO
            
        }
        else if segue.identifier == "StartWorkout" {
            
            //TODO
            
        }

    }
    
    
    
    //---------------------------
    // Unwind Segue Method
    //---------------------------
     @IBAction func unwindToMyWorkoutsTableViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "NewWorkout-Save" {
            
            //TODO
             println("Unwound to MyWorkouts")
            
        }
    }
    
    
    /*
    -----------------------------
    Movement of Workout Attempted
    -----------------------------
    */
    
    //---------------------------------------------------------------------------------------------
    // This method is invoked to carry out the row movement after the method
    // tableView: targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath: approved the move.
    //---------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        // Obtain the dictionary of workouts in the genre as AnyObject
        var dict_WorkoutOrderNumber_Dict = applicationDelegate.dict_WorkoutOrderNumber_Dict as NSMutableDictionary
        
        // Row number to move FROM *(+1 to account for Zero)
        var rowNumberFrom = fromIndexPath.row + 1
        
        // Row number to move TO *(+1 to account for Zero)
        var rowNumberTo = toIndexPath.row + 1
        
        // Get reference of Workout Dictionary object to move
        var workoutToMove = dict_WorkoutOrderNumber_Dict.objectForKey(String(rowNumberFrom)) as NSMutableDictionary
        
        // remove the entry from the dictionary
        dict_WorkoutOrderNumber_Dict.removeObjectForKey(String(rowNumberFrom))
        
        // movement is from the lower part of the list to the upper part of the list
        if (rowNumberFrom > rowNumberTo) {
            
            for var index = (rowNumberFrom - 1); index >= (rowNumberTo); --index {
                
                // get the entry from the Dictionary and store it temporarily
                var temp_object : AnyObject? = dict_WorkoutOrderNumber_Dict.objectForKey(String(index))
                
                // remove the entry from the dictionary
                dict_WorkoutOrderNumber_Dict.removeObjectForKey(String(index))
                
                // re-insert the workout at the incremented key index
                dict_WorkoutOrderNumber_Dict.setObject(temp_object!, forKey: String(index + 1))
            }
        }
            
        // movement is from the lower part of the list to the upper part of the list
        else if (rowNumberFrom < rowNumberTo) {
            
            for var index = (rowNumberFrom + 1); index <= (rowNumberTo); ++index {
                
                // get the entry and store it temporarily
                var temp_object : AnyObject? = dict_WorkoutOrderNumber_Dict.objectForKey(String(index))
                
                // remove the entry from the dictionary
                dict_WorkoutOrderNumber_Dict.removeObjectForKey(String(index))
                
                // re-insert the workout at the incremented key index
                dict_WorkoutOrderNumber_Dict.setObject(temp_object!, forKey: String(index - 1))
            }
        }
        
        // re-insert the moved record with the new key: the rowNumberTo variable cast as a String
        dict_WorkoutOrderNumber_Dict.setObject(workoutToMove, forKey: String(rowNumberTo))
        
        // Update the new dictionary of < Key : WorkoutOrderNum, Value : WorkoutDict> for the genre in the Objective-C dictionary
        applicationDelegate.dict_WorkoutOrderNumber_Dict = dict_WorkoutOrderNumber_Dict
        
    }
    

    //----------------------------------
    // Allow Movement of Rows (Workouts)
    //----------------------------------
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    
    
    //========================================================================================================
    // MARK: - Helper Methods
    //========================================================================================================
    
    
    
    //-------------------
    // Add Workout Method
    //-------------------
    
    // The addWorkout method is invoked when the user taps the Add(+) button
    func addWorkout(sender: AnyObject) {
        
        // Perform the segue named AddMovie
        performSegueWithIdentifier("AddWorkout", sender: self)
    }
    
    //-------------------
    // Add Workout Method
    //-------------------
    
    // The editWorkout method is invoked when the user taps the Edit button
    func editWorkout(sender: AnyObject) {
        
        // Perform the segue named AddMovie
        performSegueWithIdentifier("EditWorkout", sender: self)
    }

}
