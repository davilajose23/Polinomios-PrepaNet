//
//  ExamenTeorico.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 03/05/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//


import UIKit

class ExamenTeorico: UIViewController {
    
    
    
    //Outlets
    
    @IBOutlet weak var outletA: UITextField!
    @IBOutlet weak var outletD: UITextField!
    @IBOutlet weak var outletC: UITextField!
    @IBOutlet weak var outletB: UITextField!
    @IBOutlet weak var outletMaximo: UITextField!
    @IBOutlet weak var outletMinimo: UITextField!
    @IBOutlet weak var outletPuntoInflexion: UITextField!
    @IBOutlet weak var outletIntentos: UILabel!
    @IBOutlet weak var outletImgMaximo: UIImageView!
    @IBOutlet weak var outletImgMinimo: UIImageView!
    @IBOutlet weak var outletImgPuntoInflexion: UIImageView!
    
    
    // variables globales
    let kFilename = "/data.plist"
    var intentos = 0
    var poli = Polinomio(dblA: 0, dblB: 0, dblC: 1, dblD: 0)
    var maximo:String = ""
    var minimo:String = ""
    var puntoInf:String = ""
    let imgBien = UIImage(named: "Bien")
    let imgMal = UIImage(named: "Mal")
    
    
    
    // funcion cuando se da click en limpiar datos
    @IBAction func clickLimpiarDatos(sender: AnyObject) {
        
        //limpia los campos
        outletMaximo.text = ""
        outletMinimo.text = ""
        outletPuntoInflexion.text = ""
        
        //limpia las imagenes
        outletImgMaximo.hidden = true
        outletImgMinimo.hidden = true
        outletImgPuntoInflexion.hidden = true
        
    }
    
    @IBAction func clickCalificar(sender: AnyObject) {
        
        
        //verifica que no existan simbolos
        if Double(outletMaximo.text!) == nil && outletMaximo.text != ""   ||  Double(outletMinimo.text!) == nil && outletMinimo.text != ""  || Double(outletPuntoInflexion.text!) == nil  && outletPuntoInflexion.text != "" {
            
            //Manda una alerta con el error
            alertaSimbolo()
            
            
        }else if intentos < 5{
            
            //cuando aun hay intentos
            outletImgPuntoInflexion.hidden = false
            outletImgMaximo.hidden = false
            outletImgMinimo.hidden = false
            
            //Verificar si esta bien Máximo
            var strRespuestaMaximo : String = ""
            
            if (outletMaximo.text != "")
            {
                strRespuestaMaximo = String(format: "%.2f", Double(outletMaximo.text!)!)
            }
            if strRespuestaMaximo == self.maximo {
                
                outletImgMaximo.image = imgBien
                
            }else{
                outletImgMaximo.image = imgMal
            }
            
            
            // verifica si esta bien Minimo
            var strRespuestaMinimo : String = ""
            if (outletMinimo.text != "")
            {
                strRespuestaMinimo = String(format: "%.2f", Double(outletMinimo.text!)!)
            }
            if strRespuestaMinimo == self.minimo {
                
                outletImgMinimo.image = imgBien
                
            }else{
                outletImgMinimo.image = imgMal
            }
            
            // verifica si esta bien punto de infl
            var strRespuestaPI : String = ""
            if (outletPuntoInflexion.text != "")
            {
                strRespuestaPI = String(format: "%.2f", Double(outletPuntoInflexion.text!)!)
            }
            if strRespuestaPI == self.puntoInf {
                
                outletImgPuntoInflexion.image = imgBien
            }else{
                outletImgPuntoInflexion.image = imgMal
            }
            
            
            //Incrementa los intentos y actualiza el label
            intentos += 1
            outletIntentos.text = "\(intentos) de 5 Intentos"
            
        }else {
            
            
            //Manda alerta que ya no hay intentos
            let alerta = UIAlertController(title: "Alerta", message: "Has llegado al numero máximo de intentos, presiona OK para ver la respuesta correcta", preferredStyle: UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alerta, animated: true, completion: nil)

            
            // Mostrar resultados correctos para maximo
            if self.maximo == "" {
                outletMaximo.text = ""
            }else{
                outletMaximo.text = self.maximo
            }
            // Mostrar resultados correctos para minimo
            if self.minimo == "" {
                outletMinimo.text = ""
            }else{
                outletMinimo.text = self.minimo
            }
            
            // Mostrar resultados correctos para puntos de inflexion
            if self.puntoInf == "" {
                outletPuntoInflexion.text = ""
            }else{
                outletPuntoInflexion.text = self.puntoInf
            }
            
            
            //quita las imagenes
            outletImgPuntoInflexion.hidden = true
            outletImgMaximo.hidden = true
            outletImgMinimo.hidden = true
            
            //quita el numero de intentos y pone "Respuesta:"
            outletIntentos.text = "Respuesta:"
            
        }
        
        
        
    }
    
    
    
    //Funcion para obtener el path del archivo
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Carga de la PList
        cargaDatos()
        
        
    }
    
    
    // funcion que obtiene del archivo los valores guardados y  los carga
    func cargaDatos(){
        let filePath: String = self.dataFilePath()
        
        
        //Si existe el archivo
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            //crea un arreglo mutable con los datos del archivo
            let array = NSMutableArray(contentsOfFile: filePath)
            
            // variables locales Convertidas a Double
            let A = Double((array![0] as? String)!)!
            let B = Double((array![1] as? String)!)!
            let C = Double((array![2] as? String)!)!
            let D = Double((array![3] as? String)!)!
            
            //carga en cada un ode los campos los valores de las variables
            outletA.text = "\(A)"
            outletB.text = "\(B)"
            outletC.text = "\(C)"
            outletD.text = "\(D)"
            
            //define el polinomio "poli" con los valores de las variables
            poli = Polinomio(dblA: A , dblB: B, dblC: C, dblD: D)
            
        }else{ // si no existe el archivo utiliza estos datos
            
            outletA.text = "0"
            outletB.text = "0"
            outletC.text = "1"
            outletD.text = "0"
            
        }
        
        //si existe un valor maximo lo guarda en self.maximo
        if poli.dblMaximo() != nil{
            
            self.maximo = String(format: "%.2f", poli.dblMaximo()!)
        }
        //si existe un valor minimo lo guarda en self.minimo
        if poli.dblMinimo() != nil {
            
            self.minimo = String(format: "%.2f", poli.dblMinimo()! )
        }
        //si existe un valor puntoDeInflexion lo guarda en self.puntoInf
        if poli.arrdblPuntosInflexion().count != 0 {
            
            self.puntoInf =  String(format: "%.2f",poli.arrdblPuntosInflexion()[0])
        }
        
        // Oculta las imagenes de cada valro
        outletImgPuntoInflexion.hidden = true
        outletImgMaximo.hidden = true
        outletImgMinimo.hidden = true
        
        //muestra los intentos disponibles
        outletIntentos.text = "\(intentos) de 5 Intentos"

        
    }
    
    
    //Funcion para mostrar un error cuando hay valores incorrectos
    func alertaSimbolo(){
        
        
        let alerta = UIAlertController(title: "Error", message: "Espacio con valores invalidos", preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
        
        
    }
    
    //antes de que apareza la vista carga los datos
    override func viewWillAppear(animated: Bool) {
        
        cargaDatos()
    }
    
    //funcion para quitar el teclado
    @IBAction func quitaTeclado(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
