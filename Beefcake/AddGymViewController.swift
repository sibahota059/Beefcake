//
//  AddGymViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/20/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

class AddGymViewController: UIViewController, UITextFieldDelegate {
    
    //-----------
    // UI Objects
    //-----------
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var urlTextField: UITextField!
    
    // Object reference pointing to the active UITextField object
    var activeTextField: UITextField?
    
    
    /*
    =======================================================================================
    MARK: - View Life Cycle
    =======================================================================================
    */
    
    //-------------------------------------------------------
    // Function to be run when the AddGymViewController loads
    //-------------------------------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Designate self as a subscriber to Keyboard Notifications
        registerForKeyboardNotifications()
    }
    
    //-----------------------------------------------------------
    // Function to call when the device recieves a memory warning
    //-----------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //----------------------------------------------------------------------------
    // Save method for validating data, adding relevant new data to the plist file
    //----------------------------------------------------------------------------
    @IBAction func save(sender: UIBarButtonItem) {
        
        // perform data validation prior to saving and unwinding
        if nameTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
            || addressTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
            || urlTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            showErrorMessage("Fill in all gym data")
        }
        else {
            
            performSegueWithIdentifier("AddGym-Save", sender: self)
        }
    }
    
    
    /*
    =====================================================================================
    MARK: - Keyboard Methods
    =====================================================================================
    */
    
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
        
    }

    //-----------------------------------------------------------
    // This method is called upon Keyboard Will HIDE Notification
    //-----------------------------------------------------------
    func keyboardWillHide(sender: NSNotification) {
        
    }
    
    
    /*
    ====================================
    MARK:- IBAction Methods for Keyboard
    ====================================
    */


    //-----------------------------------------------------------------------
    // This method is invoked when the user taps the Done key on the keyboard
    //-----------------------------------------------------------------------
    @IBAction func keyboardDone(sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
        
        if sender.tag == 0 {
            activeTextField?.resignFirstResponder()
            activeTextField = addressTextField
            activeTextField?.becomeFirstResponder()
            textFieldDidBeginEditing(activeTextField)
        }
        else if sender.tag == 1 {
            activeTextField?.resignFirstResponder()
            activeTextField = urlTextField
            activeTextField?.becomeFirstResponder()
            textFieldDidBeginEditing(activeTextField)
        }
        else if sender.tag == 2 {
            activeTextField?.resignFirstResponder()
            activeTextField = nil
        }
        else {
            
            // do nothing
        }
    }

    //-----------------------------------------------------------------
    // Deactivates the current active text field and hides the keyboard
    // when the user taps an area in the background
    //-----------------------------------------------------------------
    @IBAction func backgroundTouch(sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        activeTextField?.resignFirstResponder()
    }
    
    
    /*
    =======================================================================================
    MARK: - UITextField Delegate Methods
    =======================================================================================
    */
    
    //-------------------------------------------------------------
    // This method is called when the user taps inside a text field
    //-------------------------------------------------------------
    func textFieldDidBeginEditing(textField: UITextField!) {
        
        activeTextField = textField
    }
    
    /*----------------------------------------------------------
    This method is called when the user:
    (1) selects another UI object after editing in a text field
    (2) taps Return on the keyboard
    -----------------------------------------------------------*/
    func textFieldDidEndEditing(textField: UITextField!) {
        
        activeTextField = nil
    }
    
    //----------------------------------------------------------------
    // This method is called when the user taps Return on the keyboard
    //----------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        // Deactivate the text field and remove the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    /*
    ---------------------------------------------
    MARK: - Register and Unregister Notifications
    ---------------------------------------------
    */
    
    
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
