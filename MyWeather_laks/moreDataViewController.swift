//
//  moreDataViewController.swift
//  MyWeather_laks
//
//  Created by Ravi Pinamacha on 7/20/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//

import UIKit

class moreDataViewController: UIViewController {
    var getCityName :String = ""
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var rain: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var humidity: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(getCityName)
        ApiManager.instance.FetchWeather(city: getCityName.replacingOccurrences(of: " ", with: "%20")) {(json) in
            
            let main = json["main"] as! NSDictionary
            let humidity = main["humidity"] as! Int
            let weatherArray = json["weather"] as! NSArray
            let weather = weatherArray[0] as! NSDictionary
     
            //sunrise and sunset
            let sys = json["sys"] as! NSDictionary
            let sunrise = sys["sunrise"] as! Double
            let sunset = sys["sunset"] as! Double
            //wind
            let wind = json["wind"] as! NSDictionary
            guard  let  windSpeed = wind["speed"] as? Double else {return}
            // let rain = json["rain"] as! String
            //rain
            //var showRain: Bool = true;
            var showRain = 0 ;
            var rain3h :Double = 0.0
            if  let rain =  json["rain"] as? NSDictionary {
                rain3h = rain["3h"] as! Double
            }else {
                showRain = 0
           
            }
            
            //to update date as mainthread
            DispatchQueue.main.async {
                self.viewConfigMoreData(
                    wind:"\(windSpeed) Mph",
                    showRain:"Int(showRain)",
                    rain:"\(String(rain3h))",
                    sunrise:timeforDisplay(unixDateTime: sunrise),
                    sunset:timeforDisplay(unixDateTime: sunset),
                    humidity:"\(humidity) %"
                )
              
                
            }
            
            
        }
        
        
        ///for date display
        func currentDate(unixDateTime : Double) -> String {
            
            let date = NSDate(timeIntervalSince1970: unixDateTime)
            
            let dayTimePeriodFormatter = DateFormatter()
            // dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            dayTimePeriodFormatter.dateFormat = "EE dd MMM "                       //sun 02 jun
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            
            return dateString
        }
        
        ///for time display 02:30 PM
        func timeforDisplay(unixDateTime : Double) -> String {
            
            let date = NSDate(timeIntervalSince1970: unixDateTime)
            
            let dayTimePeriodFormatter = DateFormatter()
            // dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            dayTimePeriodFormatter.dateFormat = "hh:mm a "                       //sun 02 jun
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            
            return dateString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension  moreDataViewController {
    
    func viewConfigMoreData(wind:String, showRain:String,rain:String, sunrise:String,sunset:String,humidity:String
        ) {
        
                self.wind.text = wind
//                self.rain.isHidden = !showRain
                self.rain.text = showRain
                self.rain.text = rain
                self.sunrise.text = sunrise
                self.sunset.text = sunset
                self.humidity.text = humidity
        
    }
    
    
}

