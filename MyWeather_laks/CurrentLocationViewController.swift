//
//  CurrentLocationViewController.swift
//  MyWeather_laks
//
//  Created by Ravi Pinamacha on 6/22/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//

import UIKit
import CoreLocation


class CurrentLocationViewController: UIViewController ,CLLocationManagerDelegate, UISearchBarDelegate {
  
    var addlist_vc : AddListViewController!
    var cityNamefrom :String = ""
    var currentCity :String = ""
    //if u forget to i nstiate this u get fatal error and
    //for this location manager u need to add wheninuseautorization in info.list
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var tempMini: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    
    @IBOutlet weak var citysearch: UISearchBar!
  
    
    @IBOutlet weak var more: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citysearch.delegate = self
        //dataView.isHidden = true
        //location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
     
    
        //tableview cell clicked...selected city  weather infromation
        if cityNamefrom != "" {
            locationManager.stopUpdatingLocation()
            currentCity = cityNamefrom
                print("current value  viewdidload")
              print(currentCity)
            getcityDataByName(name: cityNamefrom)
        }
        
        //this is for calling AddListViewController storyborad in to this current view controller
        addlist_vc = self.storyboard?.instantiateViewController(withIdentifier: "AddListViewController") as! AddListViewController
        
        //onswipe screen left and right
        let swipeRight =  UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        ///////......onswipe
        
    }
    
    //searchbar delegate method
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cityName = citysearch.text!
        if cityName == "" {
            locationManager.startUpdatingLocation()
        }else {
            locationManager.stopUpdatingLocation()
            currentCity = cityName
              print("current value  search")
            print(currentCity)
            getcityDataByName(name: cityName)
        }
    }
    
    
    // location manager  fun to update current location using latitude and longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        print(coord.latitude)
        print(coord.longitude)
        //getting using lon and lat...........................
        ApiManager.instance.FetchWeather(lat: "\(coord.latitude)", lon: "\(coord.longitude)") {(json) in
            let name = json["name"] as! String
            self.currentCity = name
            print("current value  currentlocation")
            print(self.currentCity)
            let main = json["main"] as! NSDictionary
            guard  let temp = main["temp"]  as? Double else {return}
            guard  let tempmini = main["temp_min"]  as? Double else {return}
            guard  let tempmax = main["temp_max"]  as? Double else {return}
            let weatherArray = json["weather"] as! NSArray
            let weather = weatherArray[0] as! NSDictionary
            let weatherIconCode = weather["icon"] as! String
            let weatherDescription = weather["description"] as! String
            //date from json
            let dt = json["dt"] as! Double
         
            //sunrise and sunset
                        //to update date as mainthread
            DispatchQueue.main.async {
                self.viewConfig(cName:json["name"]! as! String,
                                temp:"\(Int(temp.rounded())) °",
                    tempmini:"\(Int(tempmini.rounded())) °",
                    tempmax:"\(Int(tempmax.rounded())) °",
                    desc:weatherDescription,
                    cDate:self.currentDate(unixDateTime: dt))

                self.get_image("http://openweathermap.org/img/w/" + weatherIconCode + ".png", self.weatherIcon)
                
            }
        }
        //stop otherwise it willcome again and again
        locationManager.stopUpdatingLocation()
    }
    
    //get city data using city name
    func getcityDataByName(name : String){
        print(name)
       
        ApiManager.instance.FetchWeather(city: name.replacingOccurrences(of: " ", with: "%20")) {(json) in
        
           let main = json["main"] as! NSDictionary 
           

            guard  let temp = main["temp"]  as? Double else {return}
            guard  let tempmini = main["temp_min"]  as? Double else {return}
            guard  let tempmax = main["temp_max"]  as? Double else {return}
            let weatherArray = json["weather"] as! NSArray
            let weather = weatherArray[0] as! NSDictionary
            let weatherIconCode = weather["icon"] as! String
            let weatherDescription = weather["description"] as! String
            //date from json
            let dt = json["dt"] as! Double
           
            //data as main thread
            DispatchQueue.main.async {
                self.viewConfig(cName:json["name"]! as! String,
                                temp:"\(Int(temp.rounded())) °",
                                tempmini:"\(Int(tempmini.rounded())) °",
                                tempmax:"\(Int(tempmax.rounded())) °",
                                desc:weatherDescription,
                                cDate:self.currentDate(unixDateTime: dt))
               
                self.get_image("http://openweathermap.org/img/w/" + weatherIconCode + ".png", self.weatherIcon)
                
            }
          
        }
       
    }
    
  
 
    // More button action to show and hide view
    @IBAction func moreClicked(_ sender: UIButton) {
        
        performSegue(withIdentifier: "moreData", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moreData"){
            let destVc = segue.destination as! moreDataViewController
            destVc.getCityName = currentCity
           
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
        print(unixDateTime)
        let date = NSDate(timeIntervalSince1970: unixDateTime)
        
        let dayTimePeriodFormatter = DateFormatter()
        // dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.dateFormat = "hh:mm a "                       //sun 02 jun
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }

    //this  is for retriving image from url and display
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                
                if(image != nil)
                {
                    
                    DispatchQueue.main.async(execute: {
                        
                        imageView.image = image
                        imageView.alpha = 1.0 //alpha is 0 when animate view
                        
//                        UIView.animate(withDuration: 1.5, animations: {
//                            imageView.alpha = 0.5
//                        })
                        
                    })
                    
                }
                
            }
            
            
        })
        
        task.resume()
    }
    
    
    //gesture recognizer
    @objc func respondToGesture(gesture : UISwipeGestureRecognizer){
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            //show menu
            show_menu()
            print("right")
        case UISwipeGestureRecognizerDirection.left:
            //close menu
            close_on_swipe()
            print("left")
        default:
            break
        }
    }
    /////.........
    
    // add menu clicked
    @IBAction func menuAction(_ sender: UIBarButtonItem) {
        
        if AppDelegate.menu_bool {
            //show menu
            show_menu()
        }else{
            //close menu
            close_menu()
        }
    }
    
    func close_on_swipe(){
        if AppDelegate.menu_bool {
            //show menu
            // show_menu()
        }else{
            //close menu
            close_menu()
        }
    }
    /////........
    
    //show menu fuction
    
    func show_menu(){
        
        UIView.animate(withDuration: 0.3) { ()-> Void in
            self.addlist_vc.view.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.addlist_vc.view.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
            self.addChildViewController(self.addlist_vc)
            self.view.addSubview(self.addlist_vc.view)
            AppDelegate.menu_bool = false
            
        }
    }
    //.......
    
    // close menu function
    
    func close_menu(){
        UIView.animate(withDuration: 0.3, animations: {()-> Void in
            self.addlist_vc.view.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            
            self.addlist_vc.view.removeFromSuperview()
        }
        
        AppDelegate.menu_bool = true
    }
    /////.....................
    
    
    
}
