//
//  EqualizerViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 21/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

class EqualizerView : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdateValueTabProtocol{
    
    @IBOutlet weak var sliderNbPlages: UISlider!
    @IBOutlet weak var NbPlagesSelectionnees: UITextView!
    @IBOutlet weak var collectionEqualizer: UICollectionView!
    
    @IBOutlet weak var graphiqueView: UIView!
    
    var equalizerValueTab : [Float] = [3,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        graphiqueView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        graphiqueView.setNeedsDisplay(graphiqueView.bounds)
        updateGraphiqueView()
        
    }
    
    @IBAction func NbPlagesValueChanged(_ sender: AnyObject) {
        NbPlagesSelectionnees.text = String(Int(sliderNbPlages.value))
        while equalizerValueTab.count != Int(sliderNbPlages.value) {
            if(equalizerValueTab.count<Int(sliderNbPlages.value)){
                equalizerValueTab.append(0)
            }else if(equalizerValueTab.count > Int(sliderNbPlages.value)){
                equalizerValueTab.remove(at: equalizerValueTab.count-1)
            }
        }
        collectionEqualizer.reloadData()
        updateGraphiqueView()
    }
    
    func updateTabValue(indexPath: Int, value: Float){
        equalizerValueTab[indexPath] = value
        updateGraphiqueView()
    }
    
    func updateGraphiqueView(){
        graphiqueView.layer.sublayers?.removeAll()
        var pointsTab: [CGPoint] = []
        let intervalDistance: Int = Int(graphiqueView.bounds.size.width)/(equalizerValueTab.count-1)
        
        for i in 0...equalizerValueTab.count-1{
            let value = equalizerValueTab[i]
            let maxValue: Float =  10
            let minValue: Float = -10
            let interval = maxValue - minValue
            let y = graphiqueView.bounds.size.height * (1.0 - CGFloat((value - minValue) / interval))
            
            pointsTab.append(CGPoint(x: CGFloat(intervalDistance*i), y: y))
        }
        
        let Path: UIBezierPath = UIBezierPath()
        Path.lineWidth = 2
        
        for i in 0...pointsTab.count-1{
            if(i==0){
                Path.move(to: pointsTab[i])
            }else{
                let controlPoint1 : CGPoint = CGPoint(x: pointsTab[i-1].x + CGFloat(intervalDistance/2) , y: pointsTab[i-1].y)
                let controlPoint2 : CGPoint = CGPoint(x: pointsTab[i].x - CGFloat(intervalDistance/2) , y: pointsTab[i].y)
                Path.addCurve(to: pointsTab[i], controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            }
            
        }
        
        let line:CAShapeLayer = CAShapeLayer()
        line.path = Path.cgPath
        line.strokeColor = UIColor.blue.cgColor
        line.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        graphiqueView.layer.addSublayer(line)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  Int(sliderNbPlages.value)// NbPlages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EqualizerCell", for: indexPath) as! EqualizerCell
        cell.levelEqualizerSlider.setValue(Float(equalizerValueTab[indexPath.row]), animated: true)
        cell.valueEqualizer.text = "\(Int(round(equalizerValueTab[indexPath.row])))db"
        if(indexPath.row == 0){
            cell.frequencyValue.text = "20Hz"
        }else{
            cell.frequencyValue.text = String(Int(((20000.0/Double(equalizerValueTab.count-1)) * Double(indexPath.row))/1000)) + "KHz"
        }
        cell.indexpath = indexPath.row
        cell.delegate=self
        return cell
    }
    
    //Redéfinie la taille de la celule pour adapter la largueur au nombre de celules, avec comme largueur minimun 90dp.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minWidth: Int = 90
        let newWidth = Int(Int(collectionView.bounds.size.width) / Int(sliderNbPlages.value))
        if(newWidth < minWidth){
            return CGSize(width: minWidth, height: Int(collectionView.bounds.height))
        }
        return CGSize(width: newWidth, height: Int(collectionView.bounds.height))
    }
}

@objc protocol UpdateValueTabProtocol{
    func updateTabValue(indexPath: Int, value: Float)
}

class EqualizerCell: UICollectionViewCell{
    var midLine: UIView!
    @IBOutlet weak var frequencyValue: UILabel!
    @IBOutlet weak var valueEqualizer: UITextView!
    @IBOutlet weak var levelEqualizerSlider : UISlider!{
        didSet{
            levelEqualizerSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        }
    }
    
    weak var delegate: UpdateValueTabProtocol!
    var indexpath: Int = 0
    @IBAction func equalizerValueChanged(_ sender: AnyObject) {
        valueEqualizer.text = "\(Int(round(levelEqualizerSlider.value)))db"
        delegate.updateTabValue(indexPath: indexpath, value: levelEqualizerSlider.value)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        if midLine == nil{
            midLine = UIView(frame: CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: 1))
            midLine.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            addSubview(midLine)
        }else if midLine.bounds.width != self.bounds.width{
            midLine.frame = CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: 1)
        }
        sendSubview(toBack: midLine)
    }
}
