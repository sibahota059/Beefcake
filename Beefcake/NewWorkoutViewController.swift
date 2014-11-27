//
//  AddWorkoutViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/24/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

class NewWorkoutViewController: UIViewController, UITextFieldDelegate {
    
    //-----------
    // UI Objects
    //-----------
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var addActivitiesButton: UIButton!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    //-----------------
    // Global Variables
    //-----------------
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // name of the workout to add
    var workoutToAdd: String = ""
    
    var workoutNames = [String]()
    
    var activitiesToAdd = [String]()
    
    
    //=====================================================================
    // MARK: - View Life Cycle
    //=====================================================================
    
    //----------------------------------------
    // function for setup when this view loads
    //----------------------------------------
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Designate self as a subscriber to Keyboard Notifications
        registerForKeyboardNotifications()
    }

    //------------------------
    // Memory warning function
    //------------------------
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //==========================================================================
    // Navigation Methods
    //==========================================================================
    
    
    
    //-----------------------------------------------
    // Unwind method called by downstream controllers
    //-----------------------------------------------
    @IBAction func unwindToNewWorkoutViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "AddActivities-Cancel" {
            
            // remove any entries to the ativitiesToAdd array
            activitiesToAdd.removeAll(keepCapacity: false)
        }
        
        if segue.identifier == "AddActivities-Save" {

            // get the downstream controller
            var controller: MultiAddActivitiesTableViewController = segue.sourceViewController as MultiAddActivitiesTableViewController
            
            // obtain the activities added in the multi-add controller
            activitiesToAdd = controller.selectedActivities
        }
    }
    
    
    //-------------------------
    // Segue Preparation Method
    //-------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddActivities" {
            
            // store the name of the workout to add
            workoutToAdd = nameTextField.text
        }
    }
    
    //----------------------------------------------------------------------------
    // Save method for validating data, adding relevant new data to the plist file
    //----------------------------------------------------------------------------
    @IBAction func save(sender: UIBarButtonItem) {
        
        // perform data validation prior to saving and unwinding
        if nameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            showErrorMessage("Missing Data", errorMessage: "Provide the New Workout Name")
        }
        else {
            
            // assert that the user has added activities to the new workout
            if (activitiesToAdd.isEmpty) {
                showErrorMessage("Missing Data", errorMessage: "You must first add activities to the new workout")
                return
            }
            
            // add the newly created workout to MyWorkouts dictionary
            else {
                
                // instantiate the new dictionary
                var dict_Workout_Activities: NSMutableDictionary = NSMutableDictionary.alloc()
                
                // add all the activities to the dictionary
                for (var i = 0; i < activitiesToAdd.count; ++i) {
                    
                     dict_Workout_Activities.setValue(activitiesToAdd[i], forKey: String(i + 1))
                }
                
                // if the workout is already contained in the dictionary, remove it
                if (contains(workoutNames, workoutToAdd)) {
                    
                    // remove the existing workout from MyWorkouts dictionary
                    applicationDelegate.dict_WorkoutOrderNumber_Dict.removeObjectForKey(workoutToAdd)
                }
                
                // get the current size of the Workout dict from the app delegate
                var currentSize = applicationDelegate.dict_WorkoutOrderNumber_Dict.count
                
                // instantiate the new dictionary ordered by number
                var dict_WorkoutOrderNum_Dict: NSMutableDictionary = NSMutableDictionary.alloc()
                
                // insert the new workout dictionary into ordered workout dictionary
                dict_WorkoutOrderNum_Dict.setValue(dict_Workout_Activities, forKey: workoutToAdd)
                
                //insert the new workout dictionary with the ordered key
                applicationDelegate.dict_WorkoutOrderNumber_Dict.setValue(dict_WorkoutOrderNum_Dict, forKey: String(currentSize + 1))
                
                // unwind to MyWorkoutsTableViewController with the NewWorkout-Save
                performSegueWithIdentifier("NewWorkout-Save", sender: self)
            }
        }
    }
    
    //----------------------------------------------------------
    // Method fired when user pressed the  Add Activities button
    //----------------------------------------------------------
    @IBAction func addActivities(sender: UIButton) {
        
        // alert the user that this workout will overwrite an existing workout
        willOverwrite()
        
        performSegueWithIdentifier("AddActivities", sender: self)
    }
    
    
    
    //=============================================================================================
    // MARK: - Keyboard Methods
    //=============================================================================================

    //-----------------------------------------------------------------------------------
    // This method is called in viewDidLoad() to register self for keyboard notifications
    //-----------------------------------------------------------------------------------
    func registerForKeyboardNotifications() {
        
        // "An NSNotificationCenter object (or simply, notification center) provides a
        // mechanism for broadcasting information within a program." [Apple]
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self,
            selector:   "keyboardWillShow:",    // <-- Call this method upon Keyboard Will SHOW Notification
            name:       UIKeyboardWillShowNotification,
            object:     nil)
        
        notificationCenter.addObserver(self,
            selector:   "keyboardWillHide:",    //  <-- Call this method upon Keyboard Will HIDE Notification
            name:       UIKeyboardWillHideNotification,
            object:     nil)
    }
    
    //-----------------------------------------------------------
    // This method is called upon Keyboard Will SHOW Notification
    //-----------------------------------------------------------
    func keyboardWillShow(sender: NSNotification) {
       
        //Do Nothing
    }
    
    //-----------------------------------------------------------
    // This method is called upon Keyboard Will HIDE Notification
    //-----------------------------------------------------------
    func keyboardWillHide(sender: NSNotification) {
        
        willOverwrite()
    }

    
    
    //=============================================================================================
    // MARK:- IBAction Methods for Keyboard
    //=============================================================================================
    
    
    //-----------------------------------------------------------------------
    // This method is invoked when the user taps the Done key on the keyboard
    //-----------------------------------------------------------------------
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    //-----------------------------------------------------------------
    // Deactivates the current active text field and hides the keyboard
    // when the user taps an area in the background
    //-----------------------------------------------------------------
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        nameTextField.resignFirstResponder()
    }
    
    
    
    //=======================================================================================
    // MARK: - UITextField Delegate Methods
    //=======================================================================================
    
    
    //-------------------------------------------------------------
    // This method is called when the user taps inside a text field
    //-------------------------------------------------------------
    func textFieldDidBeginEditing(textField: UITextField!) {
        
        // Do Nothing
    }
    
    /*----------------------------------------------------------
    This method is called when the user:
    (1) selects another UI object after editing in a text field
    (2) taps Return on the keyboard
    -----------------------------------------------------------*/
    func textFieldDidEndEditing(textField: UITextField!) {
        
        // store the name of the workout to add
        workoutToAdd = nameTextField.text
    }
    
    //----------------------------------------------------------------
    // This method is called when the user taps Return on the keyboard
    //----------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        if (willOverwrite()) {
            return false
        }
        
        // Deactivate the text field and remove the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    //=============================================================================
    // MARK: - Register and Unregister Notifications
    //=============================================================================
    
    
    //--------------------------------
    // Method called when view appears
    //--------------------------------
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    //----------------------------------
    // Method called when view disapears
    //----------------------------------
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    //=============================================================================
    // MARK: - Helper Functions
    //=============================================================================
    
    //----------------------------------------------------------------------------
    // Function for alerting the user that an existing workout will be overwritten
    //----------------------------------------------------------------------------
    func willOverwrite() -> Bool {
        
        // if a workout with this name already exists
        if (contains(workoutNames, nameTextField.text)) {
            
            showErrorMessage("Overwriting Workout", errorMessage:
                "A workout with this name already exists, proceeding will overwrite the existing workout")
            return true
        }
        else {
            return false
        }
    }
    
    //-----------------------------------------
    // Show Alert View Displaying Error Message
    //-----------------------------------------
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        
        // Instantiate an alert view object
        var alertView = UIAlertView()
        
        alertView.title = errorTitle
        alertView.message = errorMessage
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    
}
