//
//  AddressCell.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/18/22.
//

import UIKit
import MapKit


class AddressCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(school: School?) {
        guard let school = school else {
            return
        }

        if let latitude = Double(school.latitude ?? ""), let longitude = Double(school.longitude ?? "") {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let schoolAnnotation = MKPointAnnotation()
            
            
            // Pan the map view with zoom relatively to 0.01 magnitude to see the school neighborhood
            let schoolRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(schoolRegion, animated: true)
            schoolAnnotation.coordinate = location
            mapView.addAnnotation(schoolAnnotation)
        }
        
        // Prepare the address by getting the st, city, state and zip code
        let address = prepareAddress(school: school)
        addressLabel.text = address
        
    }
    
    public func prepareAddress(school: School) -> String {
        
        var address = ""
        
        if let st = school.primary_address_line_1 {
            address += "\(st) \n"
            
            if let city = school.city {
                address += "\(city) \n"
            }
            
            if let state = school.state_code {
                var stateVal = state
                
                if let zip = school.zip {
                    stateVal = "\(stateVal), \(zip)"
                }
                
                address += "\(stateVal) \n"
            }
            
        }
        
        return address
        
    }
    
}
