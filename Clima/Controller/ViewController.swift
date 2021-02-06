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

class ViewController: UIViewController , CLLocationManagerDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var TempratureLabel: UILabel!
    @IBOutlet weak var WeatherIcon: UIImageView!
    @IBOutlet weak var StatueLAbel: UILabel!
    
    @IBOutlet weak var SearchBox: UITextField!
    let url = "http://api.openweathermap.org/data/2.5/weather"
    let myID = "1f3b5f72aca294d2748d0dfe7bac01a6";
    var city : String?
    let LocationManager = CLLocationManager();
    let MyData = MyWeatherData();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LocationManager.delegate = self;
        LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        LocationManager.requestWhenInUseAuthorization();
        
        LocationManager.startUpdatingLocation();
        
        
        SearchBox.delegate = self;
        
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
        
        SearchBox.endEditing(true)
        updateCity()
    }
    
    // MARK: update location
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
    
    
    // MARK: update city
    func updateCity()
    {
        let MyCordinates : [String : String] = ["q": SearchBox.text!, "appid" :  myID];
        
        GetWeatherData(url: url, MyCordinates: MyCordinates)
        
    }
    
    
    // func fail updating the location
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
        StatueLAbel.text = "Connection Failure!";
    }
    
    
    //MARK: Get weather data
    
    func GetWeatherData(url: String, MyCordinates: [String:String])
    {
        AF.request(url, method: .get , parameters: MyCordinates).responseJSON
            {
                response in
                
                if(response.value != nil)
                {
                    let resultJSON : JSON = JSON(response.value!)
                    
                    print(resultJSON)
                    self.UpdateView(result: resultJSON);
                }
                    
                else
                {
                    print("Network problem")
                    self.StatueLAbel.text = "Network Problem"
                    
                }
                
        }
    }
    
    
    
    //MARK: update GUI
    
    func UpdateView(result : JSON)
    {
        print(result)
        MyData.Temprature = result["main"]["temp"].intValue - 273;
        MyData.City = result["name"].string!;
        MyData.Condition = result["weather"][0]["id"].intValue;
        MyData.WeatherIcon = MyData.updateWeatherIcon(condition: MyData.Condition);
        
        TempratureLabel.text = "\(MyData.Temprature)";
        StatueLAbel.text = MyData.City;
        WeatherIcon.image = UIImage(named: MyData.WeatherIcon);
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateCity();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchBox.endEditing(true)
        updateCity()
        return true
    }
    
    
    @IBAction func reloadLocation(_ sender: UIButton) {
        LocationManager.requestLocation()
    }
    
    
}

