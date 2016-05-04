//
//  SettingsViewController.swift
//  Graph Insight
//
//  Created by alumno on 04/05/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargaSettings(){
        
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
        
    }
    
    
    @IBAction func quitaTeclado(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cargaSettings()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

        //defaults.setBool(0, forKey: "valor")
        
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
