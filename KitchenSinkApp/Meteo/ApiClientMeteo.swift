//
//  ApiClient.swift
//  KitchenSinkApp
//
//  Created by Student on 24/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import CoreLocation



class DataMeteo{
    var icon: UIImage
    var windSpeed: Double
    var temperature: Double
    var precipProbability : Double
    var date: NSDate
    var sunrise: Double
    var sunset: Double
    
    init(iconName: String, windSpeed: Double, temperature: Double, precipProbability : Double, timeInterval: Double, sunrise: Double, sunset: Double) {
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.precipProbability = precipProbability
        
        switch iconName {
        case "clear-day":
            icon = #imageLiteral(resourceName: "sunny")
        case "clear-night":
            icon = #imageLiteral(resourceName: "sunny_night")
        case "rain":
            if timeInterval >= sunrise && timeInterval <= sunset{
                icon = #imageLiteral(resourceName: "shower")
            }else{
                icon = #imageLiteral(resourceName: "shower_night")
            }
        case "snow":
            icon = #imageLiteral(resourceName: "snow")
        case "sleet":
            icon = #imageLiteral(resourceName: "snow")
        case "fog":
            if timeInterval >= sunrise && timeInterval <= sunset{
                icon = #imageLiteral(resourceName: "fog")
            }else{
                icon = #imageLiteral(resourceName: "fog_night")
            }
        case "cloudy":
            icon = #imageLiteral(resourceName: "cloudy")
        case "partly-cloudy-day":
            icon = #imageLiteral(resourceName: "cloudy_sun")
        case "partly-cloudy-night":
            icon = #imageLiteral(resourceName: "cloudy_night")
        default:
            if timeInterval >= sunrise && timeInterval <= sunset{
                icon = #imageLiteral(resourceName: "sunny")
            }else{
                icon = #imageLiteral(resourceName: "sunny_night")
            }
        }
        
        self.date = NSDate(timeIntervalSince1970: timeInterval)
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

@objc protocol DataLoad{
    func reloadTableView()
}

class ApiCLientMeteo{
    //Vous aurait besoin d'une clef api darksky afin de faire fonctionner cette Api.
    //créer le fichier Key.swift
    //entrer le code suivant:
    
    //class KeyApi {
    //  public let meteoKeyApi: String = "your key darksky"
    //}
    
    let keyApi = KeyApi()
    
    let baseURL : String = "https://api.darksky.net/forecast/"
    lazy var data = NSMutableData()
    var MeteoTab: [DataMeteo] = []
    weak var delegate: DataLoad!
    
    func getData(location: CLLocationCoordinate2D){
        let url: URL = URL(string: baseURL+keyApi.meteoKeyApi+"/\(location.latitude),\(location.longitude)?extend=hourly")!
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                self.MeteoTab = []
                if let parsedData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any],
                    let daily = parsedData["daily"] as? [String: Any],
                    let dataDay = daily["data"] as? [[String: Any]],
                    let hourly = parsedData["hourly"] as? [String: Any],
                    let datasJson = hourly["data"] as? [[String: Any]]{
                    var nbOfElement:Int = 0
                    for dataJson in datasJson {
                        if let sunrise = dataDay[0]["sunriseTime"] as? Double,
                            let sunset = dataDay[0]["sunsetTime"] as? Double,
                            let iconName = dataJson["icon"] as? String,
                            let windSpeed = dataJson["windSpeed"] as? Double,
                            let temperature = dataJson["temperature"] as? Double,
                            let precipProbability = dataJson["precipProbability"] as? Double,
                            let timeInterval = dataJson["time"] as? Double{
                            let dataMeteo = DataMeteo(iconName: iconName, windSpeed: windSpeed, temperature: temperature, precipProbability: precipProbability, timeInterval: timeInterval, sunrise: sunrise, sunset: sunset)
                            self.MeteoTab.append(dataMeteo)
                            nbOfElement+=1
                            if nbOfElement == 24{
                                break
                            }
                        }
                    }
                }else{
                    print(error)
                }
            }
            self.delegate.reloadTableView()
            }.resume()
    }
}
