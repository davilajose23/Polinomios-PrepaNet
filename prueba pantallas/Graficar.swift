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
    
    
    @IBOutlet weak var outletPlanoCartesiano: PlanoCartesiano!
    
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
            
            poli = Polinomio(dblA: 0, dblB: 0, dblC: 1, dblD: 0)
        }
        
        // dibuja la grafica
        
        outletPlanoCartesiano.poli = poli
        
        outletPlanoCartesiano.setNeedsDisplay()
        
        
        
        if let maxi = poli.dblMaximo(){
            
            outletMaximo.text = String(format: "%.5f",maxi)
        }else{
            outletMaximo.text = "-"
        }
        
        if let min = poli.dblMinimo(){
            
            outletMinimo.text = String(format: "%.5f",min)
        }else{
            outletMinimo.text = "-"
        }
        
        //outletMaximo.text = String (maxi) + "si"
        
        
        
        let infl = poli.arrdblPuntosInflexion()
            
        var puntosInf = ""
            
        for var i in infl {
                
            if i == 0 {
                puntosInf += "0"
            }else{
                puntosInf += String(format: "%.5f ",i)
            }

            
        }
        
        if puntosInf == "" {
            
            outletPuntoInflexion.text = "-"
            
        }else{
            outletPuntoInflexion.text = puntosInf
            
        }
        
        
        

        
    }
    
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translate :CGPoint = sender.translationInView(self.view)
       
        outletPlanoCartesiano.dblVerticalDisplace += Double(translate.y) / Double(outletPlanoCartesiano.frame.height) * (outletPlanoCartesiano.dblMaxY - outletPlanoCartesiano.dblMinY)
        outletPlanoCartesiano.dblHorizontalDisplace -= Double(translate.x) / Double(outletPlanoCartesiano.frame.width) * (outletPlanoCartesiano.dblMaxX - outletPlanoCartesiano.dblMinX)
        outletPlanoCartesiano.setNeedsDisplay()
        
        sender.setTranslation(CGPoint.zero, inView: self.view)
            
        
        
        
    }
    
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        
        let factor: CGFloat = sender.scale
        
        outletPlanoCartesiano.dblScaleFactor *= Double(factor)
        sender.scale = 1
        outletPlanoCartesiano.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCentrar(sender: AnyObject) {
        outletPlanoCartesiano.dblHorizontalDisplace = 0
        outletPlanoCartesiano.dblVerticalDisplace = 0
        outletPlanoCartesiano.dblScaleFactor = 1
        outletPlanoCartesiano.setNeedsDisplay()
    }
    
    
}
