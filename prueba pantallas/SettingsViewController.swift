//
//  SettingsViewController.swift
//  Graph Insight
//
//  Created by alumno on 04/05/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // Outlets
    
    @IBOutlet weak var outletSwitch: UISwitch!
    @IBOutlet weak var outletColores: UISegmentedControl!
    @IBOutlet weak var outletSlider: UISlider!
    @IBOutlet weak var outletIntentos: UITextField!
    @IBOutlet weak var outletGrid: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //cargaSettings()
        
        
        // Do any additional setup after loading the view.
        
                
    }
    
    // cuando se mueve el slider mueve el numero de intentos
    @IBAction func sliderChanged(sender: AnyObject) {
        
        //obtener el valor del slider
        let valor = outletSlider.value
        
        
        //dependiendo del valor del slider modificar el numero de intentos
        if valor <= 1{
            
            outletIntentos.text = "1"
            
        }else if valor > 1 && valor <= 3 {
            outletIntentos.text = "3"

            
        }else if valor > 3 && valor <= 5{
            outletIntentos.text = "5"

            
        }else {
            outletIntentos.text = "7"

            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     //Funcion cuando se selecciona el Switch de colores aleatorios
    @IBAction func clickAleatorio(sender: UISwitch) {
        
        
        //cuando el switch esta apagado esconde el segmento de colores
        if outletSwitch.on {
            
            outletColores.hidden = true
            
            
        }else{
            outletColores.hidden = false
            
            
        }
        
    }
    
    
    //Funcion para cargar los valores que se tienen en settings en la vista
    func cargaSettings(){
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
        // carga colorGrafica
        let colorGrafica:Int = defaults.integerForKey("colorGrafica")
        if colorGrafica == 0 {
            outletSwitch.on = true
            outletColores.hidden = true
        }else {
            outletSwitch.on = false
            outletColores.hidden = false
            outletColores.selectedSegmentIndex = colorGrafica-1
            
            
        }
        
        
        //carga colorGrid
        let colorGrid = defaults.stringForKey("colorGrid")
        
        if colorGrid == "gris"{
        
            outletGrid.selectedSegmentIndex = 1
            
        }else{
            
            outletGrid.selectedSegmentIndex = 0
        }
        
        //carga Intentos

        let intentos = defaults.integerForKey("intentos")
        
        outletIntentos.text = "\(intentos)"
        outletSlider.value = Float(intentos)
        
        
        
    }
    
    
    //Funcion para quitar el teclado
    @IBAction func quitaTeclado(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    // cuando la vista va a aparecer se cargan los settings
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        cargaSettings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

        //defaults.setBool(0, forKey: "valor")
        
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if outletGrid.selectedSegmentIndex == 0 {
            
            defaults.setObject("blanco", forKey: "colorGrid")
        }else{
            defaults.setObject("gris", forKey: "colorGrid")
        }
        
        
        if outletSwitch.on {
            
            defaults.setInteger(0 , forKey: "colorGrafica")
            
        }else{
            
            defaults.setInteger(outletColores.selectedSegmentIndex + 1 , forKey: "colorGrafica")
        }
        
        
        
        
        
        defaults.setInteger(Int(outletIntentos.text!)!,forKey: "intentos")
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
