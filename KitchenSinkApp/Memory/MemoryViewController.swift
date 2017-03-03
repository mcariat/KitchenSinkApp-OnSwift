//
//  MemoryViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 22/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class MemoryCollectionViewController : UICollectionViewController, clicOnCellProtocol{
    
    
    @IBOutlet var memoryCollection: UICollectionView!
    let baseColorTab: [UIColor] = [.red,.green, .darkGray, .blue, .yellow, .orange]
    var nbOfColorInCell: [Int] = [0,0,0,0,0,0]
    var colorTab : [[UIColor]] = []
    var findTab:[[Bool]] = []
    var colorCellOne: UIColor?
    var indexPathOne: IndexPath?
    var pairFind: Int = 0
    var nbMoves: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGame()
    }
    
    //Permet d'initialiser le tableau de cellules et la position de couleur pour une nouvelle parti.
    func initGame(){
        //init des variables
        pairFind = 0
        nbOfColorInCell = [0,0,0,0,0,0]
        colorTab = []
        colorCellOne = nil
        indexPathOne = nil
        nbMoves = 0
        
        //création d'un tableau de couleurs randomisé.
        for _ in 0...3{
            var tempsColorTab: [UIColor] = []
            var tempsFindTab:[Bool] = []
            for _ in 0...2{
                var attributed = false
                while !attributed{
                    let random:Int = Int(arc4random_uniform(UInt32(baseColorTab.count)))
                    if(nbOfColorInCell[random] != 2){
                        nbOfColorInCell[random]+=1
                        tempsColorTab.append(baseColorTab[random])
                        tempsFindTab.append(false)
                        attributed = true
                    }
                }
            }
            colorTab.append(tempsColorTab)
            findTab.append(tempsFindTab)
        }
    }
    
    //Fonction liée au protocol 'ClicOnCellProtocol'
    internal func clicOnCell(indexPath: IndexPath,color: UIColor) {
        if colorCellOne == nil{
            colorCellOne = color
            indexPathOne = indexPath
        }else{
            if colorCellOne != color{
                let cell1 = memoryCollection.cellForItem(at: indexPathOne!) as! MemoryCell
                let cell2 = memoryCollection.cellForItem(at: indexPath) as! MemoryCell
                cell1.hideColorButton()
                cell2.hideColorButton()
            }else{
                pairFind += 1
            }
            colorCellOne = nil
            indexPathOne = nil
            nbMoves += 1
            if pairFind == 6{
                gameWin()
            }
        }
    }
    
    //Affiche un message box avec le nombres de coups joués pour gagner et propose de rejouer ou quitter.
    func gameWin(){
        let winAlert: UIAlertController = UIAlertController(title: "Victory", message: "You win in \(nbMoves) moves", preferredStyle: .alert)
        winAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.initGame()
            self.memoryCollection.reloadData()
        }))
        winAlert.addAction(UIAlertAction(title: "Home", style: .cancel, handler: { action in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(winAlert, animated: true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3 //row number
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let column : Int = indexPath.item % 3
        let row : Int = indexPath.row % 4
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryCell", for: indexPath) as! MemoryCell
        if !findTab[row][column]{
            cell.resetColorForNewGame()
        }
        cell.colorOfButton = colorTab[row][column]
        cell.indexPath = indexPath
        cell.delegate=self
        return cell
    }
    
}

//Permet de vérifier si deux cellules sont selectionnées et s'il elles se corespondes.
@objc protocol clicOnCellProtocol{
    func clicOnCell(indexPath: IndexPath, color: UIColor)
}

//Cellule personnalisée avec un boutton.
class MemoryCell:UICollectionViewCell{
    weak var delegate: clicOnCellProtocol!
    var indexPath : IndexPath?
    @IBOutlet weak var button: UIButton!{
        didSet{
            button.backgroundColor = UIColor.lightGray
        }
    }
    var colorOfButton:UIColor = .gray
    var defaultColorOfButton:UIColor = .lightGray
    
    //Créer une animation qui affiche progressivement la couleur du boutton
    //et désactive les intéractions utilisateurs afin de ne pas retourner cette cellule une fois activé.
    func showColorButton(){
        UIView.animate(withDuration: 0.75, animations: {
            self.button.backgroundColor = self.colorOfButton
            }, completion: {_ in
                self.delegate.clicOnCell(indexPath: self.indexPath!,color: self.colorOfButton)
        })
        self.button.isUserInteractionEnabled = false
        
    }
    
    ////Créer une animation qui cache progressivement la couleur du boutton
    //et active les intéractions utilisateurs afin de pouvoir découvrir cette cellule.
    func hideColorButton(){
        UIView.animate( withDuration: 1.0, animations: {
            self.button.backgroundColor = self.defaultColorOfButton
            }, completion : {_ in
                self.button.isUserInteractionEnabled = true
        })
    }
    
    //fonction appeller dans initGame pour reset les cellules.
    func resetColorForNewGame(){
        self.button.backgroundColor = self.defaultColorOfButton
        self.button.isUserInteractionEnabled = true
    }
    
    //Fonctionne si les userInteractions sont activé.
    @IBAction func touchButton(_ sender: AnyObject) {
        showColorButton()
    }
    
}
