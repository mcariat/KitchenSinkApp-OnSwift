//
//  ImageListeViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 01/03/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
class ImageListeViewController : UITableViewController{
    
    //associe une url à son image ainsi que sont état de chargement.
    struct ImageCache {
        var urlString : String
        var imageView : UIImageView = UIImageView()
        var onLoading: Bool = false
        
        init(url urlString: String){
            self.urlString = urlString
        }
    }
    
    //url https de test.
    var tabUrl: [String] = ["https://cdn.pixabay.com/photo/2015/10/01/21/39/background-image-967820_960_720.jpg","https://news.mit.edu/sites/mit.edu.newsoffice/files/images/2016/MIT-Earth-Dish_0.jpg","https://cdn.eso.org/images/large/eso1436a.jpg","https://cdn.eso.org/images/screen/eso1119b.jpg","https://2.bp.blogspot.com/-wazaLZaCE1w/V7BPt3rcy2I/AAAAAAAAAIc/NZRzCy_Ly8UsH93y_wUYlx7wNsgw3lcngCK4B/s1600/Indian-flag-images-free.jpeg", "testerror","https://cdn.paper4pc.com/images/spaceship-wallpaper-16.jpg", "https://ae01.alicdn.com/kf/HTB19DHQJVXXXXcyXFXXq6xXFXXXl/For-Refrigerator-For-font-b-Wall-b-font-Video-Game-font-b-wall-b-font-sticker.jpg", "https://thehyperbolicgamer.files.wordpress.com/2014/09/broken-controller-thing.png", "https://www.planwallpaper.com/static/images/infinity-hdtv-1080p-hd-HD.jpg", "http://cdn.wallpapersafari.com/72/66/BP1fYC.jpg", "a", "a", "a", "a",""]
    
    var imageCache: [ImageCache] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remplisage d'imageCache avec les url https de test.
        tabUrl.forEach { (url) in
            if(url.characters.count != 0){
                imageCache.append(ImageCache(url: url))
            }
        }
    }
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCache.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageListCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        //Vérifie si l'image est déja présente dans la table imageCache ou si elle est en chagement.
        if imageCache[indexPath.row].imageView.image == nil && !imageCache[indexPath.row].onLoading{
            //Indique que l'image est en chargement et exécute le download en asynchrone.
            imageCache[indexPath.row].onLoading = true
            //DispatchQueue.main.async (execute:{
                self.imageCache[indexPath.row].imageView.getImageFromUrl(urlString: self.imageCache[indexPath.row].urlString, tableView: tableView )
            //})
            
        }else if(imageCache[indexPath.row].imageView.image == nil && imageCache[indexPath.row].onLoading){
            //Attend la fin du download pour afficher une image.
            cell.imageView?.image = nil
        }else{
            //Affiche l'image dowload ou l'image par défaut en cas d'érreur.
            cell.imageView?.image = imageCache[indexPath.row].imageView.image
        }
        return cell
    }
    
}

//Implemente des fonctions dans la class UIImageView
extension UIImageView{
    //Fait une requette pour récupérer l'image contenue dan l'url,
    //et l'enregistre dans la variable image de la class UIImageView.
    func getImageFromUrl(urlString: String, tableView: UITableView){
        //Lance un requette de connection https.
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            //En cas d'érreur 'image not found' est renvoyé.
            if error != nil {
                self.image = #imageLiteral(resourceName: "image-not-found")
            }
            //En cas de réussite, on recompile un image a partir des data reçu.
            else {
                self.image = UIImage(data: data!)!
            }
            DispatchQueue.main.async(execute: { 
                tableView.reloadData()
            })
            }.resume()
        
    }
}
