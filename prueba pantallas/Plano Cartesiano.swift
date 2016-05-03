//
//  Plano Cartesiano.swift
//  prueba pantallas
//
//  Created by Jose Fernando Dávila Orta on 18/04/16.
//  Copyright © 2016 JoseFernandoDavila. All rights reserved.
//



import UIKit

internal class PlanoCartesiano: UIView {
    
    var poli : Polinomio?
    var dblMinX : Double = -10
    var dblMaxX : Double = 10
    var dblMinY : Double = -100
    var dblMaxY : Double = 100
    
    var dblHorizontalDisplace : Double = 0
    var dblVerticalDisplace : Double = 0
    var dblScaleFactor : Double = 1
    
    private static let cgfLabelFontSize : CGFloat = CGFloat(8)
    private static let cgfLabelHeight : CGFloat = CGFloat(16)
    
    var intAmountOfVerticalGrids = 8
    var intAmountOfHorizontalGrids = 8
    
    override func drawRect(rect: CGRect) {
        if (self.poli != nil)
        {
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
    
    private func subDrawGrid()
    {
        let contexto = UIGraphicsGetCurrentContext()
        let color = UIColor.blackColor()
        CGContextSetStrokeColorWithColor(contexto, CGColorCreateCopyWithAlpha( color.CGColor,CGFloat(0.5)))
        CGContextSetLineWidth(contexto, 1)
        
        //  Draw vertical grids.
        var dblDelta : Double = (Double(self.frame.width) / Double(self.intAmountOfVerticalGrids))
        for i in 1...self.intAmountOfVerticalGrids - 1
        {
            CGContextMoveToPoint(contexto, CGFloat(Double(i) * dblDelta), 0)
            CGContextAddLineToPoint(contexto, CGFloat(Double(i) * dblDelta), CGFloat(self.frame.height))
            CGContextStrokePath(contexto)
            
            // Transport point in view to point in plane
            let value = self.dblMinX + Double(i)/Double(self.intAmountOfVerticalGrids) * (self.dblMaxX - self.dblMinX)
            
            //  Place label
            let s =  String(round(value * 100)/100.0)
            let rect = CGRectMake(
                CGFloat(Double(i) * dblDelta),
                0,
                CGFloat(dblDelta),
                CGFloat(PlanoCartesiano.cgfLabelHeight)
            )
            let label = UILabel(frame: rect)
            label.textAlignment = NSTextAlignment.Left
            label.text = s
            label.font = label.font.fontWithSize(PlanoCartesiano.cgfLabelFontSize)
            self.addSubview(label)
        }
        
        //  Draw horizontal grids.
        dblDelta = (Double(self.frame.height) / Double(self.intAmountOfHorizontalGrids))
        for i in 1...self.intAmountOfHorizontalGrids - 1
        {
            CGContextMoveToPoint(contexto, 0, CGFloat(Double(i) * dblDelta))
            CGContextAddLineToPoint(contexto, self.frame.width, CGFloat(Double(i) * dblDelta))
            CGContextStrokePath(contexto)
            
            // Transport point in view to point in plane
            let value = self.dblMinY + (1-Double(i)/Double(self.intAmountOfHorizontalGrids)) * (self.dblMaxY - self.dblMinY)
            
            //  Place label
            let s =  String(round(value * 100)/100.0)
            let rect = CGRectMake(
                CGFloat(-dblDelta / 2.0),
                CGFloat((Double(i) + 0.4) * dblDelta),
                CGFloat(dblDelta),
                PlanoCartesiano.cgfLabelHeight
            )
            let label = UILabel(frame: rect)
            label.textAlignment = NSTextAlignment.Right
            label.text = s
            label.font = label.font.fontWithSize(PlanoCartesiano.cgfLabelFontSize)
            label.transform = CGAffineTransformRotate(label.transform, CGFloat(-M_PI_2))
            self.addSubview(label)
        }
    }
}