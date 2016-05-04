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
    
    @IBOutlet weak var outletLabelEcuacion: UILabel!
   
    
    
    
    let kFilename = "/data.plist"
    
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    @IBAction func clickAleatorio(sender: AnyObject) {
        
        var aleatorio = Int(arc4random_uniform(100)) - 50
        outletA.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletB.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletC.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletD.text = String(aleatorio)
        
        
    }
    
    @IBAction func clickLimpiarDatos(sender: AnyObject) {
        
        outletA.text = "0"
        outletB.text = "0"
        outletC.text = "1"
        outletD.text = "0"
    }
    
    // Funcion cuando se da click en guardar
    
    @IBAction func clickGuardar(sender: AnyObject) {
        
        let array: NSMutableArray = []
        
        
        // verifica que sea una ecuacion valida ( no este llena de ceros)
        
        if outletA.text == "-0" || outletB.text == "-0" || outletC.text == "-0" || outletD.text == "-0" {
            
            // TODO: Agregar alerta
            
            
            //Alerta
            let alerta = UIAlertController(title: "Error", message: "Campos con valores invalidos", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alerta, animated: true, completion: nil)
       
        
        
        }else {
            
            //
            if outletA.text == ""{
                array.addObject("0")
            }else {
                array.addObject(outletA.text!)
            }
            
            if outletB.text == ""{
                array.addObject("0")
            }else{
                array.addObject(outletB.text!)
            }
            
            
            if outletC.text == ""{
                array.addObject("0")
            }else {
                array.addObject(outletC.text!)
            }
            
            if outletD.text == ""{
                array.addObject("0")
            }else{
                array.addObject(outletD.text!)
            }
            
            // guarda el archivo
            array.writeToFile(dataFilePath(), atomically: true)
            
            
            // regresa a la vista anterior
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Polinomio"
        
        cargaDatos()
        
     
    }

    func cargaDatos(){
        let filePath: String = self.dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            let array = NSArray(contentsOfFile: filePath)
            outletA.text = array![0] as? String
            outletB.text = array![1] as? String
            outletC.text = array![2] as? String
            outletD.text = array![3] as? String
           
        }else{
            outletA.text = "0"
            outletB.text = "0"
            outletC.text = "1"
            outletD.text = "0"
        }

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        cargaDatos()
    }
    
    @IBAction func quitaTeclado(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
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
