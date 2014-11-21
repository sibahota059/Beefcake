//
//  GymWebViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/20/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit


class GymWebViewController: UIViewController {
    
    
    //-----------------
    // Global Variables
    //-----------------
    
    // Web data passed down from upstream view controller
    var webInfoPassedDown = [String]()

    
    
    //-------------------------------------------------------
    // Function to be run when the GymMapViewController loads
    //-------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    //-----------------------------------------------------------
    // Function to call when the device recieves a memory warning
    //-----------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
