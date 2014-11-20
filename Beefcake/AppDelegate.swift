//
//  AppDelegate.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/10/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //--------- Create and Initialize the NSMutableDictionaries ----------------

    
    // Dictionary < Activites : String , Type : Dict >
    var dict_Activites_Dict : NSMutableDictionary = NSMutableDictionary.alloc()
    
    // Dictionary < GymNames : String , GymData : [String] >
    var dict_GymNames_GymData: NSMutableDictionary = NSMutableDictionary.alloc()
    
    // Dictionary < MyWorkouts : String , Activities : Dict >
    var dict_MyWorkouts_Dict: NSMutableDictionary = NSMutableDictionary.alloc()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentDirectoryPath = paths[0] as String
        
        let activitiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/Activites.plist"
        
        let myGymsPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyGyms.plist"
        
        let myWorkoutsPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyWorkouts.plist"
        
        
        
        // NSMutableDictionary manages an *unordered* collection of mutable (changeable) key-value pairs.
        // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
        
        var activitesDictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: activitiesPlistFilePathInDocumentDirectory)
        
        var myGymsDictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myGymsPlistFilePathInDocumentDirectory)
        
        var myWorkoutsDictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myWorkoutsPlistFilePathInDocumentDirectory)
        
        /*
        If the optional variable dictionaryFromFile has a value, then
        Activites.plist, MyGyms.plist and MyWorkouts.plist exist in the Document directory and the dictionary is successfully created; else read the plists from the application's main bundle.
        */
        
        // activites plist
        if var activitiesPlistFilePathInDocumentDirectory = activitesDictionaryFromFile {
            
            // Activites.plist exists in the Document directory
            dict_Activites_Dict = activitiesPlistFilePathInDocumentDirectory
            
        } else {
            
            // Activites.plist does not exist in the Document directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            var activitiesPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("Activities", ofType: "plist")
            
            // Instantiate an NSDictionary object and initialize it with the contents of the MyFavoriteMovies.plist file.
            var activitesDictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: activitiesPlistFilePathInMainBundle!)
            
            // Typecast the created NSDictionary as Dictionary type and assign it to the property
            dict_Activites_Dict = activitesDictionaryFromFileInMainBundle!
        }
        
        // myGyms plist
        if var myGymsPlistFilePathInDocumentDirectory = myGymsDictionaryFromFile {
            
            // MyGyms.plist exists in the Document directory
            dict_GymNames_GymData = myGymsPlistFilePathInDocumentDirectory
            
        } else {
            
            // MyGyms.plist does not exist in the Document directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            var myGymsPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("MyGyms", ofType: "plist")
            
            // Instantiate an NSDictionary object and initialize it with the contents of the MyGyms.plist file.
            var myGymsDictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myGymsPlistFilePathInMainBundle!)
            
            // Typecast the created NSDictionary as Dictionary type and assign it to the property
            dict_GymNames_GymData = myGymsDictionaryFromFile!
        }
        
        
        // myWorkouts plist
        if var myWorkoutsPlistFilePathInDocumentDirectory = myWorkoutsDictionaryFromFile {
            
            // MyWorkouts.plist exists in the Document directory
            dict_MyWorkouts_Dict = myWorkoutsPlistFilePathInDocumentDirectory
            
        } else {
            
            // MyWorkouts.plist does not exist in the Document directory; Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            var myWorkoutsPlistFilePathInMainBundle = NSBundle.mainBundle().pathForResource("MyWorkouts", ofType: "plist")
            
            // Instantiate an NSDictionary object and initialize it with the contents of the MyWorkouts.plist file.
            var myWorkoutsDictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myWorkoutsPlistFilePathInMainBundle!)
            
            // Typecast the created NSDictionary as Dictionary type and assign it to the property
            dict_MyWorkouts_Dict = myWorkoutsDictionaryFromFile!
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
        /*
        "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
        An app is active when it is receiving events. An active app can be said to have focus.
        It gains focus after being launched, loses focus when an overlay window pops up or when the device is
        locked, and gains focus when the device is unlocked." [Apple]
        */
        
        // Define the file path to the CountryCities.plist file in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let activitiesPlistFilePathInDocumentDirectory = documentDirectoryPath + "/Activities.plist"
        let myGymsPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyGyms.plist"
        let myWorkoutsPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyWorkouts.plist"
        
        
        // Write the dictionary to the Activites.plist file in the Document directory
        dict_Activites_Dict.writeToFile(activitiesPlistFilePathInDocumentDirectory, atomically: true)
        
        // Write the dictionary to the MyGyms.plist file in the Document directory
        dict_GymNames_GymData.writeToFile(myGymsPlistFilePathInDocumentDirectory, atomically: true)
        
        // Write the dictionary to the MyWorkouts.plist file in the Document directory
        dict_MyWorkouts_Dict.writeToFile(myWorkoutsPlistFilePathInDocumentDirectory, atomically: true)
        
        /*
        The flag "atomically" specifies whether the file should be written atomically or not.
        
        If flag is TRUE, the dictionary is first written to an auxiliary file, and
        then the auxiliary file is renamed to path plistFilePathInDocumentDirectory.
        
        If flag is FALSE, the dictionary is written directly to path plistFilePathInDocumentDirectory.
        This is a bad idea since the file can be corrupted if the system crashes during writing.
        
        The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
        */
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

