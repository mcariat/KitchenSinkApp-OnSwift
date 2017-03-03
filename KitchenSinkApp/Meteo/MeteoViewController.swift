//
//  MeteoViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import CoreLocation

class MeteoViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, DataLoad{
    @IBOutlet weak var imageMeteo: UIImageView!
    @IBOutlet weak var tableMeteo: UITableView!
    let apiClient : ApiCLientMeteo = ApiCLientMeteo()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.delegate = self
        apiClient.getData(location: CLLocationCoordinate2D(latitude: 42.6976, longitude: 2.893))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageMeteo.image = #imageLiteral(resourceName: "shower_night").resizeImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(ovalIn: imageMeteo.bounds).cgPath
        imageMeteo.layer.mask = shape
    }
    
    internal func reloadTableView(){
        DispatchQueue.main.async(){
            self.tableMeteo.reloadData()
            if self.apiClient.MeteoTab.count != 0 {
                self.imageMeteo.image = self.apiClient.MeteoTab[0].icon.resizeImage()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiClient.MeteoTab.count // limité aux 24 heures suivantes.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoCell", for: indexPath) as! MeteoCell
        cell.setHour(date: apiClient.MeteoTab[indexPath.row].date)
        cell.labelHumidity.text = "\(Int(apiClient.MeteoTab[indexPath.row].precipProbability*100))%"
        cell.labelTemperature.text = String(format: "%.1f",((apiClient.MeteoTab[indexPath.row].temperature-32)/1.8))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.imageMeteo.image = self.apiClient.MeteoTab[indexPath.row].icon.resizeImage()
    }
    
    func enableGeoTrackUser(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func enableMeteoToMyPosition(_ sender: AnyObject) {
        enableGeoTrackUser()
        apiClient.getData(location: (locationManager.location?.coordinate)!)
    }
    
    
}



extension UIImage{
    func resizeImage() -> UIImage{
        let scale:CGFloat = 0.8
        let newSize = self.size.height * scale
        let newPos = (self.size.height - newSize)/2
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.height,height: self.size.height), false, scale)
        self.draw(in: CGRect(x: newPos,y: newPos,width: newSize,height: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



class MeteoCell : UITableViewCell{
    
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelHoraire: UILabel!
    
    func setHour(date: NSDate){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
        dateFormatter.dateFormat = "EEEdd-MMMM : HH"
        let dateObj = dateFormatter.string(from: date as Date)
        labelHoraire.text = dateObj+"h"
        
    }
}

