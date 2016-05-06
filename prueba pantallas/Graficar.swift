//
//  Graficar.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class Graficar: UIViewController {

    
    
    //outlets
    @IBOutlet weak var outletMaximo: UITextField!
    @IBOutlet weak var outletMinimo: UITextField!
    @IBOutlet weak var outletPuntoInflexion: UITextField!
    @IBOutlet weak var outletPlanoCartesiano: PlanoCartesiano!
    
    //nombre del archivo
    let kFilename = "/data.plist"
    
    //funcion para obtener la path del archivo
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
            
            //crea un arreglo mutable desde el archivo
            let array = NSMutableArray(contentsOfFile: filePath)
            
            //variables locales con los datos del arreglo como Double
            let A = Double((array![0] as? String)!)!
            let B = Double((array![1] as? String)!)!
            let C = Double((array![2] as? String)!)!
            let D = Double((array![3] as? String)!)!
            
            //define una variable polinomio de la clase Polinomio con los datos del arreglo
            poli = Polinomio(dblA: A , dblB: B, dblC: C, dblD: D)
            
            
        }else{ //en caso de no encontrar el archivo plist
            
            //define polinomio con valores por default
            poli = Polinomio(dblA: 0, dblB: 0, dblC: 1, dblD: 0)
        }
        
        // relaciona el polinomio a la grafica y la dibuja
        outletPlanoCartesiano.poli = poli
        outletPlanoCartesiano.setNeedsDisplay()
        
        
        //Verifica que exista un maximo y lo despliega
        if let maxi = poli.dblMaximo(){
            
            outletMaximo.text = String(format: "%.5f",maxi)
        }else{
            outletMaximo.text = "-"
        }
        
        //Verifica que exista un minimo y lo despliega
        if let min = poli.dblMinimo(){
            
            outletMinimo.text = String(format: "%.5f",min)
        }else{
            outletMinimo.text = "-"
        }
        
        
        // obtiene los puntos de inflexion
        let infl = poli.arrdblPuntosInflexion()
            
        var puntosInf = ""
            
        for  i in infl {
                
            if i == 0 {
                puntosInf += "0"
            }else{
                puntosInf += String(format: "%.5f ",i)
            }

        }
        
        //verifica si hay puntos de inflexion y los muestra
        if puntosInf == "" {
            
            outletPuntoInflexion.text = "-"
            
        }else{
            outletPuntoInflexion.text = puntosInf
            
        }
        
    }
    
    
    //funcion para poder hacer scroll en la grafica
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let translate :CGPoint = sender.translationInView(self.view)
       
        //obtiene el traslado en X y Y
        outletPlanoCartesiano.dblVerticalDisplace += Double(translate.y) / Double(outletPlanoCartesiano.frame.height) * (outletPlanoCartesiano.dblMaxY - outletPlanoCartesiano.dblMinY)
        
        outletPlanoCartesiano.dblHorizontalDisplace -= Double(translate.x) / Double(outletPlanoCartesiano.frame.width) * (outletPlanoCartesiano.dblMaxX - outletPlanoCartesiano.dblMinX)
        
        //vuelve a dibujar la grafica
        outletPlanoCartesiano.setNeedsDisplay()
        sender.setTranslation(CGPoint.zero, inView: self.view)
        
    }
    
    //funcion para hacer zoom
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        
        //obtiene el factor de escala
        let factor: CGFloat = sender.scale
        
        //modifica el valor de escala en el plano cartesiano
        outletPlanoCartesiano.dblScaleFactor *= Double(factor)
        sender.scale = 1
        //vuelve a dibujar la grafica
        outletPlanoCartesiano.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Funcion para centrar la grafica como en un inicio
    @IBAction func btnCentrar(sender: AnyObject) {
        
        //reestablece los valores por defecto
        outletPlanoCartesiano.dblHorizontalDisplace = 0
        outletPlanoCartesiano.dblVerticalDisplace = 0
        outletPlanoCartesiano.dblScaleFactor = 1
        
        //vuelve a dibujar la grafica
        outletPlanoCartesiano.setNeedsDisplay()
    }
    
}
