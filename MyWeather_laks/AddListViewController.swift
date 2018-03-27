//
//  AddListViewController.swift
//  MyWeather_laks
//
//  Created by Ravi Pinamacha on 6/22/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class AddListViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {

   
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
   
    var   locationManager = CLLocationManager()
    var city:String!
    var placearr:String!
    var citi_array =  Array<String>()
    //let defaults = UserDefaults.standard //defining user defaults
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        tableView.dataSource = self
        tableView.delegate = self

        if let tempArray = UserDefaults.standard.value(forKey: "savedArray") {
            citi_array = tempArray as! Array<String>
        }
        
       
        initGoogleMap()
       
       
    }
    
    func initGoogleMap(){
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        self.googleMapView.camera = camera
        self.googleMapView.delegate = self
        self.googleMapView.isMyLocationEnabled = true
        self.googleMapView.settings.myLocationButton = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    // locationmanager delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error while getting location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)
        self.googleMapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    
    //google map view delegate method
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapView.isMyLocationEnabled = true
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapView.isMyLocationEnabled = true
        if  (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    
    //google autocomplete delegate method
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       let camera = GMSCameraPosition.camera(withLatitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude), zoom: 12.0)
        self.googleMapView.camera = camera
       
        //placearr = place.formattedAddress
        placearr = place.name
        citi_array.append(placearr)
        
        UserDefaults.standard.set(citi_array, forKey: "savedArray")
        
               // print(UserDefaults.standard.value(forKey: "savedArray"))
        
                        DispatchQueue.main.async(execute: { () -> Void in
                            //reload your tableView
                            self.tableView.reloadData()
        
                        })
        
        // SearchFavorites.resignFirstResponder()
        
        self.dismiss(animated: true, completion: nil) //didmiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Auto Completion failed")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) //when cancel search
    }
   
     //search button action
  @IBAction func searchFav(_ sender: UIButton) {
    let autoCompleteController = GMSAutocompleteViewController()
    autoCompleteController.delegate = self
    self.locationManager.startUpdatingLocation()
   self.present(autoCompleteController, animated: true, completion: nil)
    
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citi_array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50

    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //below is the cell default style we r using
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = citi_array[indexPath.row]
        
        //this is cusomized cell by us with table view cell
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CitiesTableViewCell
//               cell.cityName.text = citi_array[indexPath.row]
//        
        return cell
       

        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let ind = indexPath.row //index oof selected row to delete
            citi_array.remove(at: ind)
          
            tableView.reloadData()
            
        }
        
    }
    
    //this is for segue asslistvc to currentvc
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         city = citi_array[indexPath.row]
        print(city)
       
        performSegue(withIdentifier: "cityName", sender: city)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cityName"){
            let destVc = segue.destination as! CurrentLocationViewController
            destVc.cityNamefrom = city!
            
        }
    }

}
