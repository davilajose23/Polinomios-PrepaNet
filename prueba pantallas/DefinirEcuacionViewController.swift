//
//  DefinirEcuacionViewController.swift
//  prueba pantallas
//
//  Created by alumno on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class DefinirEcuacionViewController: UIViewController {

    //outlets
    @IBOutlet weak var outletD: UITextField!
    @IBOutlet weak var outletC: UITextField!
    @IBOutlet weak var outletB: UITextField!
    @IBOutlet weak var outletA: UITextField!
    
    //variables locales
    var ecuacion: NSMutableArray!
    let kFilename = "/data.plist"
    
    
    //funcion para obtener el path del archivo plist
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    //genera un polinomio aleatorio
    @IBAction func clickAleatorio(sender: AnyObject) {
        
        //genera valores aleatorios para A,B,C y D, despues los muestra
        
        var aleatorio = Int(arc4random_uniform(100)) - 50
        outletA.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletB.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletC.text = String(aleatorio)
        
        aleatorio = Int(arc4random_uniform(100)) - 50
        outletD.text = String(aleatorio)
        
        
    }
    
    //funcion para limiar los datos del polinomio
    @IBAction func clickLimpiarDatos(sender: AnyObject) {
        
        //Limpia los datos del polinomio y pone valores default
        outletA.text = "0"
        outletB.text = "0"
        outletC.text = "1"
        outletD.text = "0"
    }
    
    
    // Funcion cuando se da click en guardar
    @IBAction func clickGuardar(sender: AnyObject) {
        
        let array: NSMutableArray = []
        
        // verifica que sea una ecuacion valida ( no este llena de ceros negativos)
        if outletA.text == "-0" || outletB.text == "-0" || outletC.text == "-0" || outletD.text == "-0" {
            
            //Alerta
            alertaSimbolo()
       
        
        
        }else {
            
            //***************************** A
            //verifica si un valor esta vacio lo establece como 0
            if outletA.text == ""{
                array.addObject("0")
                
            }else if Double(outletA.text!) == nil {
                //si algun valor es nulo (con simbolo) manda alerta
                alertaSimbolo()
                outletA.text = ""
                
            }else{
                //agrega el valor al arreglo
                array.addObject(outletA.text!)
            }
            //***************************** B
            if outletB.text == ""{
                //verifica si un valor esta vacio lo establece como 0
                array.addObject("0")
            }else if Double(outletB.text!) == nil {
                //si algun valor es nulo (con simbolo) manda alerta
                alertaSimbolo()
                outletB.text = ""
                
            }else{
                //agrega el valor al arreglo
                array.addObject(outletB.text!)
            }
            
            //***************************** C
            if outletC.text == ""{
                array.addObject("0")
            }else if Double(outletC.text!) == nil {
                //si algun valor es nulo (con simbolo) manda alerta
                alertaSimbolo()
                outletC.text = ""
                
            }else {
                //agrega el valor al arreglo
                array.addObject(outletC.text!)
            }
            
            //***************************** D
             //verifica si un valor esta vacio lo establece como 0
            if outletD.text == ""{
                array.addObject("0")
            }else if Double(outletD.text!) == nil {
                //si algun valor es nulo (con simbolo) manda alerta
                alertaSimbolo()
                outletD.text = ""
                
            }else{
                //agrega el valor al arreglo
                array.addObject(outletD.text!)
            }
            
            // guarda el archivo solo si no hay ningun simbolo
            if (array.count == 4)
            {
                array.writeToFile(dataFilePath(), atomically: true)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Polinomio"
        //Carga los datos desde el archivo
        cargaDatos()
        
     
    }
    
    
    //funcion para cargar datos desde el plist
    
    func cargaDatos(){
        let filePath: String = self.dataFilePath()
        
        //si existe el archivo
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            //crea un arreglo y muestra los datos
            let array = NSArray(contentsOfFile: filePath)
            outletA.text = array![0] as? String
            outletB.text = array![1] as? String
            outletC.text = array![2] as? String
            outletD.text = array![3] as? String
           
        }else{ //si no existe el archivo muestra valores por default
            outletA.text = "0"
            outletB.text = "0"
            outletC.text = "1"
            outletD.text = "0"
        }

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //carga los datos antes de que aparezca la view
        cargaDatos()
    }
    
    //funcion para quitar el teclado de la pantalla
    @IBAction func quitaTeclado(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //funcion que muestra una alerta
    func alertaSimbolo(){
        
            
            let alerta = UIAlertController(title: "Error", message: "Espacio con valores invalidos", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alerta, animated: true, completion: nil)
            
        
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
