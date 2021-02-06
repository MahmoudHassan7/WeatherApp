//
//  ViewController.swift
//  Clima
//
//  Created by Mahmoud Hassan on 1/2/21.
//  Copyright © 2021 Mahmoud Hassan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var StatueLAbel: UILabel!
    @IBOutlet weak var temprature: UILabel!
    let url = "http://api.openweathermap.org/data/2.5/weather"
    let myID = "2b99ef230060de07c1752e515de853bc";
    
    let LocationManager = CLLocationManager();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        LocationManager.delegate = self;
        LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        LocationManager.requestWhenInUseAuthorization();
        
        LocationManager.startUpdatingLocation();
    
    
    }
    
    // func update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count-1];
        
        if(location.horizontalAccuracy > 0)
        {
            let latitude = String(location.coordinate.latitude);
            let longitude = String(location.coordinate.longitude);
            
            let MyCordinates : [String : String] = ["lat": latitude, "lon" : longitude, "appid" : myID];
         
            GetWeatherData(url: url, MyCordinates: MyCordinates )
            LocationManager.stopUpdatingLocation();
        }
        
    }
    
    
    // func fail updating the location
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
        StatueLAbel.text = "Connection Failure!";
    }
    
    
// Get weather data function from the server
    
    func GetWeatherData(url: String, MyCordinates: [String:String])
    {
        AF.request(url, method: .get , parameters: MyCordinates).responseJSON
        {
            response in
           
            let resultJSON : JSON = JSON(response.value)
            print(resultJSON);
    //        print (resultJSON["main"]["temp"]);
            
        }
    }

}

