//
//  ExamenTeorico.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 03/05/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//


import UIKit

class ExamenTeorico: UIViewController {
    
    let kFilename = "/data.plist"
    
    
    
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
    
    var intentos = 0
    var poli = Polinomio(dblA: 0, dblB: 0, dblC: 1, dblD: 0)
    var maximo:String = ""
    var minimo:String = ""
    var puntoInf:String = ""
    
    let imgBien = UIImage(named: "Bien")
    let imgMal = UIImage(named: "Mal")
    
    @IBAction func clickLimpiarDatos(sender: AnyObject) {
        
        outletMaximo.text = ""
        outletMinimo.text = ""
        outletPuntoInflexion.text = ""
        
        outletImgMaximo.hidden = true
        outletImgMinimo.hidden = true
        outletImgPuntoInflexion.hidden = true
        
    }
    
    @IBAction func clickCalificar(sender: AnyObject) {
        
        if Double(outletMaximo.text!) == nil && outletMaximo.text != ""   ||  Double(outletMinimo.text!) == nil && outletMinimo.text != ""  || Double(outletPuntoInflexion.text!) == nil  && outletPuntoInflexion.text != "" {
            
            alertaSimbolo()
            
            
        }else if intentos < 5{
            
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
            
            
            intentos++
            outletIntentos.text = "\(intentos) de 5 Intentos"
            
        }else {
            
            
            //Alerta
            let alerta = UIAlertController(title: "Alerta", message: "Has llegado al numero máximo de intentos, presiona OK para ver la respuesta correcta", preferredStyle: UIAlertControllerStyle.Alert)
            alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alerta, animated: true, completion: nil)

            
            // Mostrar resultados correctos
            
            if self.maximo == "" {
                outletMaximo.text = ""
            }else{
                outletMaximo.text = self.maximo
            }
            
            if self.minimo == "" {
                outletMinimo.text = ""
            }else{
                outletMinimo.text = self.minimo
            }
            
            
            if self.puntoInf == "" {
                outletPuntoInflexion.text = ""
            }else{
                outletPuntoInflexion.text = self.puntoInf
            }
            
            outletImgPuntoInflexion.hidden = true
            outletImgMaximo.hidden = true
            outletImgMinimo.hidden = true
            
            outletIntentos.text = "Respuesta:"
            
        }
        
        
        
    }
    
    
    
    
    func dataFilePath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory.stringByAppendingString(kFilename)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cargaDatos()
        
        
    }
    
    
    
    func cargaDatos(){
        let filePath: String = self.dataFilePath()
        
        
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath){
            
            let array = NSMutableArray(contentsOfFile: filePath)
            //outletA.text = array![0] as? String
            
            
            let A = Double((array![0] as? String)!)!
            let B = Double((array![1] as? String)!)!
            let C = Double((array![2] as? String)!)!
            let D = Double((array![3] as? String)!)!
            
            outletA.text = "\(A)"
            outletB.text = "\(B)"
            outletC.text = "\(C)"
            outletD.text = "\(D)"
            
            poli = Polinomio(dblA: A , dblB: B, dblC: C, dblD: D)
            
        }else{
            
            outletA.text = "0"
            outletB.text = "2"
            outletC.text = "1"
            outletD.text = "0"
            
        }
        
        if poli.dblMaximo() != nil{
            
            self.maximo = String(format: "%.2f", poli.dblMaximo()!)
        }
        if poli.dblMinimo() != nil {
            
            self.minimo = String(format: "%.2f", poli.dblMinimo()! )
        }
        
        if poli.arrdblPuntosInflexion().count != 0 {
            
            self.puntoInf =  String(format: "%.2f",poli.arrdblPuntosInflexion()[0])
        }
        
        outletImgPuntoInflexion.hidden = true
        outletImgMaximo.hidden = true
        outletImgMinimo.hidden = true
        
        outletIntentos.text = "\(intentos) de 5 Intentos"

        
    }
    
    func alertaSimbolo(){
        
        
        let alerta = UIAlertController(title: "Error", message: "Campos con valores invalidos", preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
        
        
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
    
    
}
