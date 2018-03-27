//
//  WeatherConfigViewController.swift
//  WeatherApp
//
//  Created by Ravi Pinamacha on 6/21/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//
import Foundation
import UIKit

extension  CurrentLocationViewController {
    
    func viewConfig(cName:String
        ,temp:String
        ,tempmini:String,tempmax:String
        , desc:String, cDate:String)
    {
        self.cityName.text = cName
        self.temp.text = temp
        self.tempMini.text = tempmini
        self.tempMax.text = tempmax
        self.weatherDescription.text = desc
        self.currentDate.text = cDate

        
    }
   
    
}
