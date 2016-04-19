//
//  Polinomio.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//

import UIKit
import Foundation


//	Clase encargada de representar a un polinomio de hasta tercer grado.
//	El polinomio tendr· la siguiente forma: ax^3 + bx^2 + cx + d

class Polinomio:NSObject
{
    //-----------------------------------------------------------------------------------------------------------
    //							PROPIEDADES DE INSTANCIA
    //							Valores de 'a' hasta 'd'
    
    
    private var dblA : Double
    private var dblB : Double
    private var dblC : Double
    private var dblD : Double
    
    //  CONSTRUCTOR
    
    init(dblA: Double, dblB: Double, dblC: Double, dblD: Double)
    {
        self.dblA = dblA
        self.dblB = dblB
        self.dblC = dblC
        self.dblD = dblD
    }
    
    //------------------------------------------------------------------------------------------------------------
    //							PROPIEDADES CALCULADAS
    
    //						    El grado del polinomio.
    //					Es útil calcularlo para evitar procesos innecesarios.
    
    lazy var intGrado : Int = {
        if (self.dblA != 0) {return 3}
        if (self.dblB != 0) {return 2}
        if (self.dblC != 0) {return 1}
        return 0
    }()
    
    //							Puntos de inflexion. Son los puntos en los que la segunda
    //						derivada es igual a cero.
    lazy var arrdblPuntosInflexion : [Double] = {
        if (self.intGrado < 3) {return []}
        
        var dblPuntoDeInflexion : Double = -2 * self.dblB
        dblPuntoDeInflexion /= 6 * self.dblA
        
        return [dblPuntoDeInflexion]
    }()
    
    //														Los ceros de la funcion.
    //														Hay cuatro posibles casos:
    //															- El grado es 0: se regresa un conjunto vacÌo
    //															- El grado es 1: se obtiene por medio de la ecuacion
    //																-(d/c)
    //															- El grado es 2: se utiliza la fÛrmula general
    //																cuadr·tica
    //															- El grado es 3: la funciÛn se lcasifica en uno de tres
    //                                                              casos y se resuelve acorde
    //                                                              Caso 1: No tiene m·ximos ni mÌnimos.
    //                                                              Caso 2: M·ximo y mÌnimo son negativos o positivos.
    //                                                              Caso 3: M·ximo y mÌnimo son uno negativo y otro no.
    lazy var arrdblCeros : [Double] = {
        if (self.intGrado == 0){
            return []
        }
        else if (self.intGrado == 1)
        {
            return [-self.dblD / self.dblC]
        }
        else if (self.intGrado == 2)
        {
            var dblRootOf : Double = pow(self.dblC,2) - 4 * self.dblB * self.dblD
            if (dblRootOf < 0) {return []}
            
            let dblRootPositive = (-self.dblC + sqrt(dblRootOf)) / (2 * self.dblB)
            let dblRootNegative = (-self.dblC - sqrt(dblRootOf)) / (2 * self.dblB)
            
            return [dblRootPositive, dblRootNegative]
        }
        else
        {
            //                                              Grado 3
            
            var intCaso : Int = 0
            if (self.dblMaximo == nil) {intCaso = 1}
            else if (self.dblCalcular(self.dblMaximo!) == 0 || self.dblCalcular(self.dblMinimo!) == 0 ||
                self.dblCalcular(self.dblMaximo!) / self.dblCalcular(self.dblMinimo!) < 0) {intCaso = 3}
            else {intCaso = 2}
            
            if (intCaso == 1)
            {
                return [self.dblBusquedaPendiente(self.arrdblPuntosInflexion[0], dblError: 0.000001)]
            }
            else if (intCaso == 2)
            {
                if (self.dblCalcular(self.dblMaximo!) < 0)
                {
                    if (self.dblMaximo! > self.dblMinimo!)
                    {
                        return [self.dblBusquedaPendiente(self.dblMinimo! - 1, dblError: 0.000001)]
                    }
                    return [self.dblBusquedaPendiente(self.dblMinimo! + 1, dblError: 0.000001)]
                }
                if (self.dblMaximo! > self.dblMinimo!)
                {
                    return [self.dblBusquedaPendiente(self.dblMaximo! + 1, dblError: 0.000001)]
                }
                return [self.dblBusquedaPendiente(self.dblMaximo! - 1, dblError: 0.000001)]
            }
            else
            {
                var arrdblCeros : [Double] = []
                if (self.dblMaximo! < self.dblMinimo!)
                {
                    arrdblCeros.append(self.dblBusquedaPendiente(self.dblMaximo! - 1, dblError: 0.000001))
                    arrdblCeros.append(self.dblBusquedaPendiente(self.dblMinimo! + 1, dblError: 0.000001))
                }
                else
                {
                    arrdblCeros.append(self.dblBusquedaPendiente(self.dblMaximo! + 1, dblError: 0.000001))
                    arrdblCeros.append(self.dblBusquedaPendiente(self.dblMinimo! - 1, dblError: 0.000001))
                }
                
                arrdblCeros.append(self.dblBusquedaBinaria(self.dblMinimo!, dblMax: self.dblMaximo!, dblError: 0.000001))
                
                return arrdblCeros
            }
        }
    }()
    
    //														Valor m·ximo de la funciÛn.
    //														No necesariamente es cuando la funciÛn vale m·s, sino cuando
    //															se encuentra que la derivada es igual a cero, y la
    //															segunda derivada es negativa.
    lazy var dblMaximo : Double? =
    {
        if (self.intGrado < 2) {return nil}
        
        let poliPendiente = Polinomio(dblA: 0, dblB: self.dblA * 3, dblC: self.dblB * 2, dblD: self.dblC)
        let poliAceleracion = Polinomio(dblA: 0, dblB: 0, dblC: self.dblA * 6, dblD: self.dblB * 2)
        
        for dblMaxMin in poliPendiente.arrdblCeros
        {
            if (poliAceleracion.dblCalcular(dblMaxMin) < 0) {return dblMaxMin}
        }
        
        return nil
    }()
    
    //														Valor minimo de la funciÛn.
    //														No necesariamente es cuando la funciÛn vale menos, sino que
    //															se encuentra que la derivada es igual a cero, y la
    //															segunda derivada es positiva.
    lazy var dblMinimo : Double? =
    {
        if (self.intGrado < 2) {return nil}
        
        let poliPendiente = Polinomio(dblA: 0, dblB: self.dblA * 3, dblC: self.dblB * 2, dblD: self.dblC)
        let poliAceleracion = Polinomio(dblA: 0, dblB: 0, dblC: self.dblA * 6, dblD: self.dblB * 2)
        
        for dblMaxMin in poliPendiente.arrdblCeros
        {
            if (poliAceleracion.dblCalcular(dblMaxMin) > 0) {return dblMaxMin}
        }
        
        return nil
    }()
    
    //------------------------------------------------------------------------------------------------------------------
    //														MÈtodos de consulta.
    
    //														Eval˙a la funciÛn en cierto valor de 'x'
    func dblCalcular(dblX : Double) -> Double
    {
        return self.dblA * pow(dblX,3) + self.dblB * pow(dblX,2) + self.dblC * dblX + self.dblD;
    }
    
    //														Determina si un polinomio de grado 1 es factor del polinomio
    //															con la condiciÛn de ser de grado 3.
    private func boolEsFactor(poliFactor: Polinomio) -> Bool
    {
        if (poliFactor.intGrado != 1) {return false}
        if (self.intGrado != 3) {return false}
        
        let fe = poliFactor.dblD / poliFactor.dblC
        
        return (self.dblD == fe * self.dblC - fe * fe * self.dblB + fe * fe * fe * self.dblA)
    }
    
    //														Realiza una divisiÛn de un polinomio de grado 3 entre un
    //															polinomio de grado 1.
    //														Si los polinomios no son v·lidos, regresa nulo. Lo mismo
    //															ocurre si el polinomio no es divisible entre el
    //															denominador.
    private func poliDivide(poliDenominador: Polinomio) -> Polinomio?
    {
        if (!self.boolEsFactor(poliDenominador)) {return nil}
        
        let b = self.dblA / poliDenominador.dblC
        let c = self.dblB / poliDenominador.dblC - poliDenominador.dblD * b / poliDenominador.dblC
        let d = self.dblC / poliDenominador.dblC - poliDenominador.dblD * c / poliDenominador.dblC
        
        return Polinomio(dblA: 0, dblB: b, dblC: c, dblD: d)
    }
    
    //                                                      Realiza una busqueda bianria de un cero de una funcion con
    //                                                          un valor maximo que evaluado es mayor a 0 y un valor
    //                                                          minimo que evaluado es menor a cero.
    private func dblBusquedaBinaria(dblMin: Double, dblMax: Double, dblError: Double) -> Double
    {
        var dblCero : Double = 0
        var dblMx = dblMax
        var dblMn = dblMin
        while(true)
        {
            dblCero = (dblMx + dblMn) / 2
            
            let dblFX = self.dblCalcular(dblCero)
            if (abs(dblFX) < dblError) {break}
            
            if (dblFX < 0){dblMn = dblCero}
            else {dblMx = dblCero}
        }
        
        return dblCero
    }
    
    private func dblBusquedaPendiente(dblX: Double, dblError: Double) -> Double
    {
        var dblActual = dblX
        let poliDerivada = Polinomio(dblA: 0, dblB: 3 * self.dblA, dblC: 2 * self.dblB, dblD: self.dblC)
        
        while (abs(self.dblCalcular(dblActual)) > dblError)
        {
            dblActual += -self.dblCalcular(dblActual) / poliDerivada.dblCalcular(dblActual)
        }
        
        return dblActual
    }
}
