//
//  MapViewController.swift
//  FollowMe
//
//  Created by Harry Ng on 06/05/2017.
//  Copyright © 2017 devconcept. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpViewTwo: UIView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var locationManager: CLLocationManager?
    let popUpHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        popUpView.isHidden = true
        popUpView.layer.cornerRadius = 5
        popUpView.clipsToBounds = true
        
        popUpViewTwo.isHidden = true
        popUpViewTwo.layer.cornerRadius = 5
        popUpViewTwo.clipsToBounds = true
        
        infoButton.layer.cornerRadius = 5
        infoButton.clipsToBounds = true
        
    }
    
    @IBAction func infoButton_TouchUpInside(_ sender: Any) {
        
        if infoButton.currentTitle == "  Hide Coordinates" {
            animatePopUpOut()
        } else {
            animatePopUpIn()
        }
    }
    
    
    func animatePopUpIn() {
        
        popUpView.isHidden = false
        popUpViewTwo.isHidden = false
        
        let popUpHeight = UIScreen.main.bounds.size.height
        
        popUpView.transform = CGAffineTransform(translationX: 0, y: popUpHeight)
        popUpViewTwo.transform = CGAffineTransform(translationX: 0, y: popUpHeight)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.popUpView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.popUpViewTwo.transform = CGAffineTransform.identity
        }, completion: nil)
        
        infoButton.setTitle("  Hide Coordinates", for: .normal)
        
    }
    
    func animatePopUpOut() {
        popUpView.transform = CGAffineTransform.identity
        popUpViewTwo.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.popUpView.transform = CGAffineTransform(translationX: 0, y: self.popUpHeight)
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.popUpViewTwo.transform = CGAffineTransform(translationX: 0, y: self.popUpHeight)
        }, completion: nil)
        
        infoButton.setTitle("  Show Coordinates", for: .normal)
        
    }
    @IBAction func longPressGesture_Tapped(_ sender: Any) {
        locationManager?.startUpdatingLocation()
        mapView.removeAnnotations(mapView.annotations)
        
    }
    
    @IBAction func tapGesture_Tapped(_ sender: Any) {
        
        locationManager?.stopUpdatingLocation()
        
        let location = (sender as AnyObject).location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = coordinate
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(dropPin)
        
        
        
        latitudeLabel.text = String(describing: latitude)
        longitudeLabel.text = String(describing: longitude)

    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let value = manager.location?.coordinate
        let latitude = value?.latitude
        let longitude = value?.longitude
        latitudeLabel.text = String(describing: latitude!)
        longitudeLabel.text = String(describing: longitude!)
        
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

    }
    
}

extension MapViewController: MKMapViewDelegate {
}

