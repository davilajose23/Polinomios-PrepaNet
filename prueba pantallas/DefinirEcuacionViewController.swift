//
//  DefinirEcuacionViewController.swift
//  prueba pantallas
//
//  Created by alumno on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class DefinirEcuacionViewController: UIViewController {

    
    var ecuacion: NSMutableArray!
    
    
    @IBOutlet weak var outletD: UITextField!
    @IBOutlet weak var outletC: UITextField!
    @IBOutlet weak var outletB: UITextField!
    @IBOutlet weak var outletA: UITextField!
    
    
    let kFilename = "/data.plist"
    
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    
    @IBAction func clickGuardar(sender: AnyObject) {
        
        let array: NSMutableArray = []
        
        
        
        array.addObject(outletA.text!)
        array.addObject(outletB.text!)
        array.addObject(outletC.text!)
        array.addObject(outletD.text!)
        
        array.writeToFile(dataFilePath(), atomically: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let filePath: String = self.dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            let array = NSArray(contentsOfFile: filePath)
            outletA.text = array![0] as? String
            outletB.text = array![1] as? String
            outletC.text = array![2] as? String
            outletD.text = array![3] as? String
            
            
        }
        
     
    }

    
    
    
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
