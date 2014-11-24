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
    
    
    
    
    //========================================================================
    // Navigation Methods
    //========================================================================
    
    
    
    //-----------------------------------------------
    // Unwind method called by downstream controllers
    //-----------------------------------------------
    @IBAction func unwindToNewWorkoutViewController (segue : UIStoryboardSegue) {
        
        println("Unwound to New Workout")
        
    }
    
    
    //-------------------------
    // Segue Preparation Method
    //-------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "AddActivities" {
        
        // Obtain the object reference of the destination (downstream) view controller
        var multiAddActivityViewController: MultiAddActivityViewController = segue.destinationViewController as MultiAddActivityViewController
        
        // pass the data object to the downsteam view controller
        // multiAddActivityViewController.somethingThere = self.somethingHere
        }
        
    }
    
    
    //----------------------------------------------------------------------------
    // Save method for validating data, adding relevant new data to the plist file
    //----------------------------------------------------------------------------
    @IBAction func save(sender: UIBarButtonItem) {
        
        // perform data validation prior to saving and unwinding
        if nameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            showErrorMessage("Provide the New Workout Name")
        }
        else {
            
            //TODO
            // perform data validation
            
            // unwind to MyWorkoutsTableViewController with the NewWorkout-Save
            performSegueWithIdentifier("NewWorkout-Save", sender: self)
        }
    }
    
    //----------------------------------------------------------
    // Method fired when user pressed the  Add Activities button
    //----------------------------------------------------------
    @IBAction func addActivities(sender: UIButton) {
        
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
        
        //Do Nothing
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
        
        // Do Nothing
    }
    
    //----------------------------------------------------------------
    // This method is called when the user taps Return on the keyboard
    //----------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // Deactivate the text field and remove the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //==============================================
    // MARK: - Register and Unregister Notifications
    //==============================================
    
    
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
    
    /*
    ------------------------------------------------
    MARK: - Show Alert View Displaying Error Message
    ------------------------------------------------
    */
    func showErrorMessage(errorMessage: String) {
        
        // Instantiate an alert view object
        var alertView = UIAlertView()
        
        alertView.title = "Necessary Data Missing!"
        alertView.message = errorMessage
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
    }
    

}
