//
//  AnimationViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 16/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//
import UIKit

class AnimationViewController: UIViewController {
    var typeMove : Bool = true
    @IBOutlet weak var Retract: UIButton!
    @IBOutlet weak var myView: AnimationView!
    var inAnimation: Bool = false
    
    //En fonction de l'état du boutton on appelle la fonction 'moveToCenter' ou 'moveToFar' si aucune animation n'est déja en cour.
    @IBAction func clickbuton(_ sender: AnyObject) {
        if(inAnimation == false){
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.inAnimation = false
            }
            inAnimation=true
            if typeMove{
                Retract.setTitle("Extend", for: .normal)
                myView.moveToCenter()
                typeMove = false
            }
            else{
                Retract.setTitle("Retract", for: .normal)
                myView.moveToFar()
                typeMove = true
            }
            
            CATransaction.commit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myView.setNeedsDisplay()
    }
}

class AnimationView : UIView{
    var colonnes: Int = 16
    var lignes : Int = 16
    var blueBoxes: [[CALayer]] = []
    let anim : CABasicAnimation  = CABasicAnimation(keyPath: "position")
    
    //Rassemble tous les points en un point central.
    func moveToCenter(){
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        for i in 0 ..< self.colonnes{
            for j in 0 ..< self.lignes{
                anim.fromValue    = self.blueBoxes[i][j].position
                anim.toValue  = center
                anim.duration   = 1.0;
                self.blueBoxes[i][j].position = center
                self.blueBoxes[i][j].add(anim, forKey:"position")
            }
        }
    }
    
    //Renvoit tous les points à leur position d'origine.
    func moveToFar(){
        
        let cellSize = CGSize(width: bounds.width/CGFloat(colonnes),
                              height: bounds.height/CGFloat(lignes))
        for i in 0 ..< self.colonnes{
            for j in 0 ..< self.lignes{
                anim.fromValue    = self.blueBoxes[i][j].position
                anim.toValue  = CGPoint(x: (CGFloat(i)+0.5) * cellSize.width,
                                        y: (CGFloat(j)+0.5) * cellSize.height)
                anim.duration   = 1.0;
                self.blueBoxes[i][j].position = CGPoint(x: (CGFloat(i)+0.5) * cellSize.width,
                                                        y: (CGFloat(j)+0.5) * cellSize.height)
                self.blueBoxes[i][j].add(anim, forKey:"position")
            }
        }
    }
    
    //créer et affiche tous les points sous forme de layers.
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if blueBoxes.count == 0{
            //let defaultFrame = CGRect(x: 0, y: 0, width: 10, height: 10)
            let cellSize = CGSize(width: bounds.width/CGFloat(colonnes),
                                  height: bounds.height/CGFloat(lignes))
            
            for i in 0 ..< colonnes{
                var blueBoxesColumn: [CALayer] = []
                for j in 0 ..< lignes{
                    
                    let ijView = CALayer()
                    ijView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                    ijView.position = CGPoint(x: (CGFloat(i)+0.5) * cellSize.width,
                                              y: (CGFloat(j)+0.5) * cellSize.height)
                    ijView.backgroundColor = UIColor.blue.cgColor
                    blueBoxesColumn.append(ijView)
                    layer.addSublayer(ijView)
                }
                blueBoxes.append(blueBoxesColumn)
            }
        }
    }
}
