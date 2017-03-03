//
//  MapViewController.swift
//  KitchenSinkApp
//
//  Created by Student on 16/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate , CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLong: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enableGeoTrackUser()
    }

    //Vérifie si l'app a les autorisation pour accéder à la position actuelle du smartphone.
    //sinon, elle la demande.
    //Si elle possede l'autorisation elle affiche cette position sur la map.
    func enableGeoTrackUser(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
    
    // Affiche la localisation (lat; long) de l'utilisateur
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        labelLat.text = "Lat: \(manager.location!.coordinate.latitude)"
        labelLong.text = "Long: \(manager.location!.coordinate.longitude)"
    }
    
}
