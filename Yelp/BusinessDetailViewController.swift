//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Hien Quang Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController {
    
    //MARK: - Outlets and Variables
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var business: Business!
    
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        mapView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundView = UIImageView(image: UIImage(named: "green"))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero) //remove separator of empty cell
        tableView.scrollEnabled = false
        tableView.separatorColor = UIColor.clearColor()
        
        //Configure map
        configureMapView()
        zoomToRegion()
    }

    // MARK: - Helpers
    struct CellIdentifiers{
        static let informationCell = "InformationCell"
        static let contactCell = "ContactCell"
    }
    
    func configureMapView(){
        //"Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong"
        
        if #available(iOS 9, *){
            mapView.showsScale = true
            mapView.showsCompass = true
            mapView.showsTraffic = true
        }
        
        mapView.addAnnotation(business)
    }
    
    func zoomToRegion(){
        let location = business.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location, 5000, 7000)
        mapView.setRegion(region, animated: true)
    }
    
}

extension BusinessDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.informationCell, forIndexPath: indexPath) as! InformrationCell
            cell.business = business
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.contactCell, forIndexPath: indexPath) as! ContactCell
            cell.business = business
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension BusinessDetailViewController: MKMapViewDelegate{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        //verify if the annotation object is a kind of
        if annotation.isKindOfClass(MKUserLocation){
            return nil
        }
        
        
        //reuse annotation
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftIconView.setImageWithURL(business.imageURL!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        //customize pin color
        if #available(iOS 9, *) {
            annotationView?.pinTintColor = AppThemes.textOrangeTheme
        } else {
            annotationView?.pinColor = MKPinAnnotationColor.Red
        }
        
        
        return annotationView
    }
}
