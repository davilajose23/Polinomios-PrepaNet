//
//  SettingsViewController.swift
//  Graph Insight
//
//  Created by alumno on 04/05/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var outletSwitch: UISwitch!
    
    @IBOutlet weak var outletColores: UISegmentedControl!
    
    
    @IBOutlet weak var outletSlider: UISlider!
    @IBOutlet weak var outletIntentos: UITextField!
    @IBOutlet weak var outletGrid: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    @IBAction func sliderChanged(sender: AnyObject) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickAleatorio(sender: UISwitch) {
        
        if outletSwitch.on {
            
            
        }else{
            
            
        }
        
    }
    
    func cargaSettings(){
        
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let colorGrafica = String(defaults.valueForKey("settingsColorGrafica"))
        
        if colorGrafica == "0" {
            outletSwitch.on = true
            
        }else {
            outletSwitch.on = false
            outletColores.selectedSegmentIndex = 0
            
        }
        
        
        
        
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
