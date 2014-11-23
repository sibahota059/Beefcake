//
//  MyGymsViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/20/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit
import CoreLocation

class MyGymsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    //--------------------
    // UI Object variables
    //--------------------
    
    // UIPickerView object for selecting from "My Gyms"
    @IBOutlet var pickerView: UIPickerView!
    
    // Map type segmented controller
    @IBOutlet var mapTypeSegmentedControl: UISegmentedControl!
    
    
    //-----------------
    // Global variables
    //-----------------
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // create a String array to hold the names of the Gyms
    var gymNames = [String]()
    
    // the absolute filepath to the maps.html file
    var mapsHtmlFilePath: String?
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    // dataObjectToPass = [ GymName: String, GoogleMapsGymAddressURL: String ]
    var mapDataObjectToPass: [String] = ["", ""]
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    // dataObjectToPass = [ GymName: String, GymURL: String ]
    var webDataObjectToPass: [String] = ["", ""]
    
    // dataObjectToPass is the data object to pass to the downstream view controller
    // dataObjectToPass = [ GymName: String, Address: String, Website: String ]
    var gymDataToPassDown: [String] = ["", "", ""]
    
    // search URL to pass down to find nearby gyms
    var gymSearchURLtoPassDown: String = ""
    
    
    //-------------------
    // Location variables
    //-------------------
    
    // Instantiate a CLLocationManager object
    var locationManager = CLLocationManager()
    
    var userAuthorizedLocationMonitoring = false
    
    
    /*
    =======================
    MARK: - View Life Cycle
    =======================
    */
    
    
    //-----------------------------
    // View initialization function
    //-----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Add button on the right of the navigation bar to call the addGym method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addGym:")
        
        // set right navigation "addButton"
        self.navigationItem.rightBarButtonItem = addButton
        
        // Set up the Edit button on the left of the navigation bar to call the editGym method when tapped
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editGym:")
        
        // set left navigation "editButton"
        self.navigationItem.leftBarButtonItem = editButton
        
        
        // set the title of this view
        self.title = "My Gyms"
        
        /*
        allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
        Therefore, typecast the AnyObject type keys to be of type String.
        The keys in the array are *unordered*; therefore, they need to be sorted.
        */
        gymNames = applicationDelegate.dict_GymName_GymData.allKeys as [String]
        
        // Sort the gym names within itself in alphabetical order
        gymNames.sort { $0 < $1 }
        
        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
        
        println("LOCATION? : \(CLLocationManager.locationServicesEnabled())")
        
        // check that location services are enabled
        if !CLLocationManager.locationServicesEnabled() {
            
            // Instantiate an alert view object
            var alertView = UIAlertView()
            
            alertView.title = "Location Services Disabled!"
            alertView.message = "Turn Location Services On in your device settings to be able to use location services!"
            alertView.delegate = nil
            alertView.addButtonWithTitle("OK")
            
            alertView.show()
            
            return
        }
        
        // request user approval for their current location
        locationManager.requestWhenInUseAuthorization()
        
        // check the status of location authorization
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied
        {
            self.userAuthorizedLocationMonitoring = false
        }
        else
        {
            self.userAuthorizedLocationMonitoring = true
        }

        // Obtain the absolute file path to the maps.html file in the main bundle
        mapsHtmlFilePath = NSBundle.mainBundle().pathForResource("maps", ofType: "html")
    }
    
    
    //--------------------------
    // View Will Appear function
    //--------------------------
    override func viewWillAppear(animated: Bool) {
        
        resetView()
        
    }
    
    //-------------------
    // Reseting this view
    //-------------------
    func resetView() {
        
        // Obtain the number of the row in the middle of the Gym names list
        var numberOfGyms = gymNames.count
        var numberOfRowToShow = Int(numberOfGyms / 2)
        
        // Show the picker view of Gym names, starting from the middle
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        // Deselect the earlier selected directions type
        mapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
    }
    
    
    //------------------------
    // Memory warning function
    //------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    =====================
    MARK: - Navigation
    =====================
    */
    
    
    //-------------------------
    // Segue Preparation Method
    //-------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Performing a Gym Google Maps Web View segue
        if segue.identifier == "GymMap" {
            
            // Obtain the object reference of the destination (downstream) view controller
            var gymMapViewController: GymMapViewController = segue.destinationViewController as GymMapViewController
            
            // pass the data object to the downsteam view controller
            gymMapViewController.mapDataPassedDown = self.mapDataObjectToPass
        }
        
        else if segue.identifier == "GymWeb" {
            
            // Obtain the object reference of the destination (downstream) view controller
            var gymWebViewController: GymWebViewController = segue.destinationViewController as GymWebViewController
            
            // pass the data object to the downsteam view controller
            gymWebViewController.webDataPassedDown = self.webDataObjectToPass
        }
            
        else if segue.identifier == "EditGym"
        {
            // Obtain the object reference of the destination (downstream) view controller
            var editGymViewController: EditGymViewController = segue.destinationViewController as EditGymViewController
            
            // pass the data object to the downsteam view controller
            editGymViewController.gymDataPassedDown = self.gymDataToPassDown
        }
        
        else if segue.identifier == "GymSearch"
        {
            // Obtain the object reference of the destination (downstream) view controller
            var gymSearchViewController: GymSearchViewController = segue.destinationViewController as GymSearchViewController
            
            // pass the search URL String to the downsteam view controller
            gymSearchViewController.searchURLPassedDown = self.gymSearchURLtoPassDown
        }
    }
    
    
    
    //----------------------------------
    // function for showing the map view
    //----------------------------------
    @IBAction func showMap(sender: UISegmentedControl) {
        
        // get the currently selected gym name from the picker
        var gymName: String = gymNames[pickerView.selectedRowInComponent(0)]
        
        // get the currently selected gyms data
        var gymData: [String] = applicationDelegate.dict_GymName_GymData.objectForKey(gymName) as [String]
        
        // get the address of the gym from the gymData array
        var gymAddress: String = gymData[0]
        
        var urlReadyAddress: String = gymAddress.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
        
        var googleMapsQuery: String = ""
        
        switch sender.selectedSegmentIndex {
            
        case 0:   // Roadmap map type selected
            googleMapsQuery = mapsHtmlFilePath! + "?place=\(urlReadyAddress)&maptype=ROADMAP&zoom=16"
            
        case 1:   // Satellite map type selected
            googleMapsQuery = mapsHtmlFilePath! + "?place=\(urlReadyAddress)&maptype=SATELLITE&zoom=16"
            
        case 2:   // Hybrid map type selected
            googleMapsQuery = mapsHtmlFilePath! + "?place=\(urlReadyAddress)&maptype=HYBRID&zoom=16"
            
        case 3:   // Terrain map type selected
            googleMapsQuery = mapsHtmlFilePath! + "?place=\(urlReadyAddress)&maptype=TERRAIN&zoom=16"
            
        default:
            return
        }
        
        // package data for downstream GymMapViewController
        mapDataObjectToPass[0] = gymName
        mapDataObjectToPass[1] = googleMapsQuery
        
        performSegueWithIdentifier("GymMap", sender: self)
    }
    
    
    //----------------------------------
    // function for showing the web view
    //----------------------------------
    @IBAction func showWeb(sender: UIButton) {
    
        // get the currently selected gym name from the picker
        var gymName: String = gymNames[pickerView.selectedRowInComponent(0)]
        
        // get the currently selected gyms data
        var gymData: [String] = applicationDelegate.dict_GymName_GymData.objectForKey(gymName) as [String]
        
        // get the url of the gym from the gymData array
        var gymUrl: String = gymData[1]
        
        // package data for downstream GymMapViewController
        webDataObjectToPass[0] = gymName
        webDataObjectToPass[1] = gymUrl
        
        performSegueWithIdentifier("GymWeb", sender: self)
    }
    

        
    //----------------------------------------------------------------
    // The addGym method is invoked when the user taps the Add (+) button
    //----------------------------------------------------------------
    func addGym(sender: AnyObject) {
    
        performSegueWithIdentifier("AddGym", sender: self)
    }
    
    
    //-----------------------------------------------------------------
    // The editGym method is invoked when the user taps the Edit button
    //-----------------------------------------------------------------
    func editGym(sender: AnyObject) {
        
        // obtain current gym information from the pickerView
        var gymName: String = gymNames[pickerView.selectedRowInComponent(0)]
        
        // get the currently selected gyms data
        var gymData: [String] = applicationDelegate.dict_GymName_GymData.objectForKey(gymName) as [String]
        
        // get the address of the gym from the gymData array
        var gymAddress: String = gymData[0]
        
        // get the url of the gym from the gymData array
        var gymUrl: String = gymData[1]
        
        // package data for the downstream controller
        gymDataToPassDown = [gymName, gymAddress, gymUrl]
        
        performSegueWithIdentifier("EditGym", sender: self)
    }
    
    
    //-------------------------------------------------------------------
    // The editGym method is invoked when the user taps the Search button
    //-------------------------------------------------------------------
    @IBAction func searchGyms(sender: UIButton) {
        
        if !userAuthorizedLocationMonitoring {
            
            // User does not authorize location monitoring
            
            // Instantiate an alert view object
            var alertView = UIAlertView()
            
            alertView.title = "Authorization Denied!"
            alertView.message = "Unable to determine current location!"
            alertView.delegate = nil
            alertView.addButtonWithTitle("OK")
            
            alertView.show()
            
            return
        }
        
        // Set the current view controller to be the delegate of the location manager object
        locationManager.delegate = self
        
        // Set the location manager's distance filter to kCLDistanceFilterNone implying that
        // a location update will be sent regardless of movement of the device
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        // Set the location manager's desired accuracy to be the best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Start the generation of updates that report the user’s current location.
        // Implement the CLLocationManager Delegate Methods below to receive and process the location info.
        locationManager.startUpdatingLocation()
        
        println("Location Updating... \(self.locationManager)")
        
        // Perform the segue named GymSearch
        performSegueWithIdentifier("GymSearch", sender: self)
    }
    
    /*
    ------------------------------------------
    MARK: - CLLocationManager Delegate Methods
    ------------------------------------------
    */
    
    //---------------------------------------------------------
    // Tells the delegate that a new location data is available
    //---------------------------------------------------------
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("locationManager()") //DEBUG
        
        /*
        The objects in the given locations array are ordered with respect to their occurrence times.
        Therefore, the most recent location update is at the end of the array; hence, we access the last object.
        */
        let lastObjectAtIndex = locations.count - 1
        var currentLocation: CLLocation = locations[lastObjectAtIndex] as CLLocation
        
        // Obtain current location's latitude in degrees
        var latitudeValue = currentLocation.coordinate.latitude
        
        // Obtain current location's longitude in degrees
        var longitudeValue = currentLocation.coordinate.longitude
        
        // Stops the generation of location updates since we do not need it anymore
        manager.stopUpdatingLocation()
        
        gymSearchURLtoPassDown = mapsHtmlFilePath! + "?n=Current+Location&lat=\(latitudeValue)&lng=\(longitudeValue)&maptype=ROADMAP&zoom=16"
        
        println("gym search URL created: \(gymSearchURLtoPassDown)") //DEBUG
        
        // Perform the segue named GymSearch
        performSegueWithIdentifier("GymSearch", sender: self)
    }
    
    //-----------------------------------------------------
    // Tells the delegate that location data is unavailable
    //-----------------------------------------------------
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        // Stops the generation of location updates since error occurred
        manager.stopUpdatingLocation()
        
        // Instantiate an alert view object
        var alertView = UIAlertView()
        
        alertView.title = "Unable to Locate!"
        alertView.message = "An error occurred while trying to determine your location: \(error.localizedDescription)"
        alertView.delegate = nil
        alertView.addButtonWithTitle("OK")
        
        alertView.show()
        
        return
    }

    
    /*
    ==========================================================================================================
    MARK: - Unwind Segue Method
    ==========================================================================================================
    */
    
    //-----------------------------------------------
    // Unwind method called by downstream controllers
    //-----------------------------------------------
    @IBAction func unwindToGymViewController (segue : UIStoryboardSegue) {
        
        // adding a gym
        if (segue.identifier == "AddGym-Save") {
            
            // get the downstream controller
            var controller: AddGymViewController = segue.sourceViewController as AddGymViewController
            
            // obtain data from downstream view controller
            var nameEntered = controller.nameTextField.text
            var addressEntered = controller.addressTextField.text
            var urlEntered = controller.urlTextField.text
            
            // insert the gym into the dictionary
            insertGym(name: nameEntered, address: addressEntered, url: urlEntered)
        }
            
        // deleting a gym
        else if (segue.identifier == "EditGym-Delete") {
            
            // get the downstream controller
            var controller: EditGymViewController = segue.sourceViewController as EditGymViewController
            
            // obtain data from downstream view controller
            var nameEntered = controller.nameTextField.text
            var addressEntered = controller.addressTextField.text
            var urlEntered = controller.urlTextField.text
            
            // delete the gym from the dictionary
            deleteGym(name: nameEntered, address: addressEntered, url: urlEntered)
        }
            
        // editing a gym
        else if (segue.identifier == "EditGym-Save")
        {
            // get the downstream controller
            var controller: EditGymViewController = segue.sourceViewController as EditGymViewController
            
            // obtain data from downstream view controller
            var nameEntered = controller.nameTextField.text
            var addressEntered = controller.addressTextField.text
            var urlEntered = controller.urlTextField.text
            
            // insert the gym into the dictionary
            insertGym(name: nameEntered, address: addressEntered, url: urlEntered)
        }
        
        // Do Nothing
        else
        {
            return
        }
        
    }
    
    /*
    ==============================================================================================================
    MARK: - Picker View Methods
    ==============================================================================================================
    */
    
    
    /*
    ----------------------------------------
    UIPickerView Data Source Methods
    ----------------------------------------
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return gymNames.count
    }
    
    /*
    ----------------------------
    UIPickerView Delegate Method
    ----------------------------
    */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return gymNames[row]
    }
    
    
    /*
    ================================================================================================================
    MARK: - Helper Methods
    ================================================================================================================
    */
    
    
    //------------------------------------------------
    // function for inserting a Gym to the dictionary
    //------------------------------------------------
    func insertGym(#name: String, address: String, url: String) {
        
        // package the gym data in an array
        var gymData = [address, url]
        
        // if the gym does not already exist in the dictionary...
        if applicationDelegate.dict_GymName_GymData.objectForKey(name) == nil {
            
            //insert the new record into the dictionary
            applicationDelegate.dict_GymName_GymData.setObject(gymData, forKey: name)
        }
        else {
            
            // remove the old record
            applicationDelegate.dict_GymName_GymData.removeObjectForKey(name)
            
            // insert the updated record (update/edit)
            applicationDelegate.dict_GymName_GymData.setObject(gymData, forKey: name)
        }
        
        // update the gym names in this view
        gymNames = applicationDelegate.dict_GymName_GymData.allKeys as [String]
        gymNames.sort {$0 < $1}
        
        // update this view
        resetView()
    }
    
    //----------------------------------------------------
    // function for removing a Gym from the dictionary
    //----------------------------------------------------
    func deleteGym(#name: String, address: String, url: String) {
        
        // update the dictionary by removing the gym data, if it exists
        if applicationDelegate.dict_GymName_GymData.objectForKey(name) == nil {
            
            // do nothing
            return
        }
        else {
            
            // remove the record
            applicationDelegate.dict_GymName_GymData.removeObjectForKey(name)
            
            // package the gym data in an array
            var gymData = [address, url]
            
            // update the gym names in this view
            gymNames = applicationDelegate.dict_GymName_GymData.allKeys as [String]
            gymNames.sort {$0 < $1}
            
            // update this view
            resetView()
        }
    }

    
    
    //-----------------------------------------
    // Show Alert View Displaying Error Message
    //-------------------------------------------
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
