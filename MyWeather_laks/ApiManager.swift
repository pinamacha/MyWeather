//
//  ApiManager.swift
//  MyWeather_laks
//
//  Created by Ravi Pinamacha on 6/23/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//

import Foundation
class ApiManager :  NSObject{
    static let instance  = ApiManager()
    
    //complettion handler in swift3 google
    
    //it is a singleton pattern
    func FetchWeather(city:String, completionHandler:@escaping (NSDictionary) -> ()) {
        
        guard  let weatherRequest:URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=imperial&APPID=54b8ef65e35a6c4311932e4e25c394dc") else {
            print("can not convert into url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: weatherRequest) { (wdata, response, err) in
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: wdata! , options: []) as? NSDictionary else {
                    print("fail to parse data")
                    return
                }
                completionHandler(json)
                print(json)
      
            
            }catch {
                print(err ?? "eeee" )
            }
            
        }
        task.resume()
        
        
    }
    
    func FetchWeather(lat:String,lon:String, completionHandler:@escaping (NSDictionary) -> ()) {
        
        guard  let weatherRequest:URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&APPID=23ff8f249f7f6e1a17574abdf06c1cc1") else {
            print("can not convert into url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: weatherRequest) { (wdata, response, err) in
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: wdata! , options: []) as? NSDictionary else {
                    print("fail to parse data")
                    return
                }
                completionHandler(json)
                print(json)
                
                
            }catch {
                print(err ?? "eeee" )
            }
            
        }
        task.resume()
        
        
    }
        
        
   
}
