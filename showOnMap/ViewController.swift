//
//  ViewController.swift
//  showOnMap
//
//  Created by Маргарита on 06.04.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any)
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else{
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Getting Data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)

                
                //zooming in on annotation
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

