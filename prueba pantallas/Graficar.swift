//
//  Graficar.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class Graficar: UIViewController {

    let kFilename = "/data.plist"
    
    
    @IBOutlet weak var outletMaximo: UITextField!
    
    @IBOutlet weak var outletMinimo: UITextField!
    
    @IBOutlet weak var outletPuntoInflexion: UITextField!
    
    
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let filePath: String = self.dataFilePath()
        
        
        var poli: Polinomio
        
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            let array = NSMutableArray(contentsOfFile: filePath)
            //outletA.text = array![0] as? String
            
           
        
            
            let A = Double((array![0] as? String)!)!
            let B = Double((array![1] as? String)!)!
            let C = Double((array![2] as? String)!)!
            let D = Double((array![3] as? String)!)!

            
            
            
            poli = Polinomio(dblA: A , dblB: B, dblC: C, dblD: D)
            
            
            
            
        }else{
            /*
            outletA.text = "0"
            outletB.text = "0"
            outletC.text = "1"
            outletD.text = "0" */
            
            poli = Polinomio(dblA: 0, dblB: 2, dblC: 1, dblD: 0)
        }
        
        
         if let maxi = poli.dblMaximo {
            
            outletMaximo.text = String(format: "%.5f",maxi)
        }
        
        if let min = poli.dblMinimo {
            
            outletMinimo.text = String(format: "%.5f",min)
        }
        //outletMaximo.text = String (maxi) + "si"

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
