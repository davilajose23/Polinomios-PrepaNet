//
//  PlanoCartesiano.swift
//  Plano
//
//  Created by alumno on 18/04/16.
//  Copyright © 2016 JCGI. All rights reserved.
//

import UIKit

internal class PlanoCartesiano: UIView {
    
    var poli : Polinomio?
    var dblMinX : Double = -10
    var dblMaxX : Double = 10
    var dblMinY : Double = -100
    var dblMaxY : Double = 100
    
    var dblMinIntervalosVertical : Double = 4.0
    var dblMaxIntervalosVertical : Double = 6.0
    var dblMinIntervalosHorizontal : Double = 4.0
    var dblMaxIntervalosHorizontal : Double = 6.0
    
    var dblHorizontalDisplace : Double = 0
    var dblVerticalDisplace : Double = 0
    var dblScaleFactor : Double = 1
    
    private static let cgfLabelFontSize : CGFloat = CGFloat(8)
    private static let cgfLabelHeight : CGFloat = CGFloat(16)
    private static let dblValores : [Double] = [1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5]
    
    override func drawRect(rect: CGRect) {
        if (self.poli != nil)
        {
            for view in self.subviews
            {
                view.removeFromSuperview()
            }
            
            self.setMaxMin()
            
            self.subDrawGrid()
            
            //  Obtengo rango horizontal
            let dblRango = self.dblMaxX - self.dblMinX
            
            //  Creo arreglo con 100 valores, ajustados al tamaño del view.
            var arrPuntos : [Double] = []
            let dblDeltaCalcular = dblRango / 100
            for i in 1...100
            {
                //  Calculo el punto
                var punto = poli!.dblCalcular(self.dblMinX + Double(i) * dblDeltaCalcular)
                
                //  Ajusto al tamaño del view.
                punto = (punto - self.dblMinY) / (self.dblMaxY - self.dblMinY)
                punto = punto * -1 * Double(self.frame.height) + Double(self.frame.height)
                
                //  Agrego punto a arreglo.
                arrPuntos.append(punto)
            }
            
            let contexto = UIGraphicsGetCurrentContext()
            let color = UIColor.blueColor()
            CGContextSetStrokeColorWithColor(contexto, color.CGColor)
            CGContextSetLineWidth(contexto, 4.0)
            
            
            CGContextMoveToPoint(contexto, 0, CGFloat(arrPuntos[0]))
            let dblDelta : Double = (Double(self.frame.width) / 100.0)
            var i = 0
            for dblPoint in arrPuntos
            {
                CGContextAddLineToPoint(contexto, CGFloat(Double(i)*Double(dblDelta)), CGFloat(dblPoint))
                i = i + 1
            }
            
            CGContextStrokePath(contexto)
        }
    }
    
    private func setMaxMin()
    {
        if (poli != nil)
        {
            if (poli!.dblMaximo() != nil && poli!.intGrado() == 3)
            {
                let dblDelta = poli!.dblCalcular(poli!.dblMaximo()!) - poli!.dblCalcular(poli!.dblMinimo()!)
                self.dblMaxY = poli!.dblCalcular(poli!.dblMaximo()!) + dblDelta / 3
                self.dblMinY = poli!.dblCalcular(poli!.dblMinimo()!) - dblDelta / 3
                
                let dblDeltaX = abs(poli!.dblMaximo()! - poli!.dblMinimo()!)
                if (poli!.dblMaximo()! < poli!.dblMinimo()!)
                {
                    self.dblMinX = poli!.dblMaximo()! - dblDeltaX / 3
                    self.dblMaxX = poli!.dblMinimo()! + dblDeltaX / 3
                }
                else
                {
                    self.dblMaxX = poli!.dblMaximo()! + dblDeltaX / 3
                    self.dblMinX = poli!.dblMinimo()! - dblDeltaX / 3
                }
            }
            else if(poli!.intGrado() == 3)
            {
                let dblCentroX = poli!.arrdblPuntosInflexion()[0]
                let dblCentroY = poli!.dblCalcular(poli!.arrdblPuntosInflexion()[0])
                let dim = 10.0
                self.dblMinX = dblCentroX - dim
                self.dblMaxX = dblCentroX + dim
                self.dblMinY = dblCentroY - dim
                self.dblMaxY = dblCentroY + dim
            }
            else if(poli!.intGrado() == 1)
            {
                //  Obtengo la interseccion en eje X
                let dblInterseccionX = poli!.arrdblCeros()[0]
                
                var dim : Double = 0.0
                if (abs(dblInterseccionX) > abs(poli!.dblD))
                {
                    dim = abs(dblInterseccionX)
                }
                else
                {
                    dim = abs(poli!.dblD)
                }
                
                if (dim == 0)
                {
                    dim = 10
                }
                
                dim *= 2
                
                self.dblMaxX = dim
                self.dblMaxY = dim
                self.dblMinX = -dim
                self.dblMinY = -dim
            }
            else if(poli!.intGrado() == 2)
            {
                var dblCentroX = 0.0
                var dblCentroY = 0.0
                if(poli!.dblMaximo() != nil)
                {
                    dblCentroX = poli!.dblMaximo()!
                    dblCentroY = poli!.dblCalcular(poli!.dblMaximo()!)
                }
                else
                {
                    dblCentroX = poli!.dblMinimo()!
                    dblCentroY = poli!.dblCalcular(poli!.dblMinimo()!)
                }
                
                let dim = 10.0
                self.dblMinX = dblCentroX - dim / self.poli!.dblB / 1.5
                self.dblMaxX = dblCentroX + dim / self.poli!.dblB / 1.5
                self.dblMinY = dblCentroY - dim
                self.dblMaxY = dblCentroY + dim
            }
            else if(poli!.intGrado() == 0)
            {
                let dblCentroX = 0.0
                let dblCentroY = poli!.dblD
                
                let dim = 10.0
                self.dblMinX = dblCentroX - dim
                self.dblMaxX = dblCentroX + dim
                self.dblMinY = dblCentroY - dim
                self.dblMaxY = dblCentroY + dim
            }
            
            //  Apply displacement and scaling factors.
            let dblHorizontalDelta = ((self.dblMaxX - self.dblMinX) / 2.0 * self.dblScaleFactor) - (self.dblMaxX - self.dblMinX) / 2.0
            let dblVerticalDelta = ((self.dblMaxY - self.dblMinY) / 2.0 * self.dblScaleFactor) - (self.dblMaxY - self.dblMinY) / 2.0
            
            self.dblMaxX += self.dblHorizontalDisplace + dblHorizontalDelta
            self.dblMinX += self.dblHorizontalDisplace - dblHorizontalDelta
            self.dblMaxY += self.dblVerticalDisplace + dblVerticalDelta
            self.dblMinY += self.dblVerticalDisplace - dblVerticalDelta
        }
    }
    
    func subDrawVerticalLine(contexto: CGContext, dblPointInPlane: Double, dblDelta: Double)
    {
        let value = ((dblPointInPlane - self.dblMinX) / (self.dblMaxX - self.dblMinX)) * Double(self.frame.width)
        let dblDeltaAdjusted = (dblDelta / (self.dblMaxX - self.dblMinX)) * Double(self.frame.width)
        
        if (abs(dblPointInPlane) < 0.0000000001)
        {
            CGContextSetLineWidth(contexto, 3)
        }
        CGContextMoveToPoint(contexto, CGFloat(value), 0)
        CGContextAddLineToPoint(contexto, CGFloat(value), CGFloat(self.frame.height))
        CGContextStrokePath(contexto)
        if (abs(dblPointInPlane) < 0.0000000001)
        {
            CGContextSetLineWidth(contexto, 1)
        }
        
        //  Place label
        let s =  String(round(dblPointInPlane * 100)/100.0)
        let rect = CGRectMake(
            CGFloat(value),
            0,
            CGFloat(dblDeltaAdjusted),
            CGFloat(PlanoCartesiano.cgfLabelHeight)
        )
        let label = UILabel(frame: rect)
        label.textAlignment = NSTextAlignment.Left
        label.text = s
        label.font = label.font.fontWithSize(PlanoCartesiano.cgfLabelFontSize)
        self.addSubview(label)
    }
    
    func subDrawHorizontalLine(contexto: CGContext, dblPointInPlane: Double, dblDelta: Double)
    {
        // Transport point in plane to point in view
        let value = Double(self.frame.height) - (((dblPointInPlane - self.dblMinY) / (self.dblMaxY - self.dblMinY)) * Double(self.frame.height))
        let dblDeltaAdjusted = (dblDelta / (self.dblMaxY - self.dblMinY)) * Double(self.frame.height)
        
        if (abs(dblPointInPlane) < 0.0000000001)
        {
            CGContextSetLineWidth(contexto, 3)
        }
        CGContextMoveToPoint(contexto, 0, CGFloat(value))
        CGContextAddLineToPoint(contexto, self.frame.width, CGFloat(value))
        CGContextStrokePath(contexto)
        if (abs(dblPointInPlane) < 0.0000000001)
        {
            CGContextSetLineWidth(contexto, 1)
        }
        
        //  Place label
        let s =  String(dblPointInPlane)
        let rect = CGRectMake(
            0,
            CGFloat(value),
            CGFloat(dblDeltaAdjusted),
            PlanoCartesiano.cgfLabelHeight
        )
        let label = UILabel(frame: rect)
        label.textAlignment = NSTextAlignment.Left
        label.text = s
        label.font = label.font.fontWithSize(PlanoCartesiano.cgfLabelFontSize)
        self.addSubview(label)
    }
    
    func dblObtenerTamanoIntervalo(boolVertical : Bool) -> Double
    {
        var dblValoresAux = PlanoCartesiano.dblValores
        
        var dblTamanoTotal : Double = 0
        var dblMaxIntervalos : Double = 0
        var dblMinIntervalos :Double = 0
        if (boolVertical)
        {
            dblTamanoTotal = self.dblMaxX - self.dblMinX
            dblMaxIntervalos = self.dblMaxIntervalosVertical
            dblMinIntervalos = self.dblMinIntervalosVertical
            
        }
        else
        {
            dblTamanoTotal = self.dblMaxY - self.dblMinY
            dblMaxIntervalos = self.dblMaxIntervalosHorizontal
            dblMinIntervalos = self.dblMinIntervalosHorizontal
        }
        
        if (dblTamanoTotal / dblValoresAux[0] < dblMinIntervalos)
        {
            let dblFactor : Double = 0.1
            while (dblTamanoTotal / dblValoresAux[0] < dblMinIntervalos)
            {
                for i in 0...dblValoresAux.count - 1
                {
                    dblValoresAux[i] *= dblFactor
                }
            }
        }
        else
        {
            let dblFactor : Double = 10.0
            while (dblTamanoTotal / dblValoresAux[dblValoresAux.count - 1] > dblMaxIntervalos)
            {
                for i in 0...dblValoresAux.count - 1
                {
                    dblValoresAux[i] *= dblFactor
                }
            }
        }
        
        var dblTamanoIntervalo : Double = 1.0
        for dblValor in dblValoresAux
        {
            dblTamanoIntervalo = dblValor
            let dblCantActual : Double = dblTamanoTotal / dblTamanoIntervalo
            if (dblCantActual >= dblMinIntervalos && dblCantActual <= dblMaxIntervalos)
            {
                break
            }
        }
        
        return dblTamanoIntervalo
    }
    
    func subDrawGrid()
    {
        let contexto = UIGraphicsGetCurrentContext()
        let color = UIColor.blackColor()
        CGContextSetStrokeColorWithColor(contexto, CGColorCreateCopyWithAlpha( color.CGColor,CGFloat(0.5)))
        CGContextSetLineWidth(contexto, 1)
        
        //Pinto lineas verticales
        let dblTamanoIntervaloVertical = self.dblObtenerTamanoIntervalo(true)
        var dblLineaActual : Double = (floor(self.dblMinX / dblTamanoIntervaloVertical) + 1.0) * dblTamanoIntervaloVertical
        while (dblLineaActual < self.dblMaxX)
        {
            subDrawVerticalLine(contexto!, dblPointInPlane: dblLineaActual, dblDelta: dblTamanoIntervaloVertical)
            dblLineaActual += dblTamanoIntervaloVertical
        }
        
        //Pinto lineas horizontales
        let dblTamanoIntervaloHorizontal = self.dblObtenerTamanoIntervalo(false)
        dblLineaActual = (floor(self.dblMinY / dblTamanoIntervaloHorizontal) + 1.0) * dblTamanoIntervaloHorizontal
        while (dblLineaActual < self.dblMaxY)
        {
            subDrawHorizontalLine(contexto!, dblPointInPlane: dblLineaActual, dblDelta: dblTamanoIntervaloHorizontal)
            dblLineaActual += dblTamanoIntervaloHorizontal
        }
    }
}