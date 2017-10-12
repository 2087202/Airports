import UIKit
import MapKit

class AirportDetailViewController: UIViewController, MKMapViewDelegate {
    
    //MARK : properties
    @IBOutlet weak var switchDisplay: UISwitch!
    @IBOutlet weak var municipalityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var desAirportLabel: UILabel!
    @IBOutlet weak var airportName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stepper: UIStepper!
    
    var airport : Airport!
    let EHAM = CLLocation(latitude: 52.3076865, longitude: 4.767424099999971)
    var geodesicPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    var planeDirection: CLLocationDirection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        mapView.delegate = self
        airportName.text = self.airport.name
        countryLabel.text = airport.iso_country! + ","
        municipalityLabel.text = airport.municipality
        desAirportLabel.text = airport.icao
        
        // Code for flightpath
        var coordinates = [airport.location!, EHAM.coordinate]
        geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        let locationDes = CLLocation(latitude: airport.location.latitude, longitude: airport.location.longitude)
        let distance = EHAM.distance(from: locationDes);
        let annotation = MKPointAnnotation()
        annotation.title = NSLocalizedString("Plane", comment: "Plane marker")
        mapView.addAnnotation(annotation)
        mapView.add(geodesicPolyline)
        
        self.planeAnnotation = annotation
        self.updatePlanePosition()
        
        distanceLabel.text = String(format: "%.2f", distance) + "nm"
        
        setMapRegion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: map delegate functions
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 1.0
            return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let planeIdentifier = "Plane"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        annotationView.image = #imageLiteral(resourceName: "plane")
        
        annotationView.transform = annotationView.transform.rotated(by: CGFloat(degreesToRadians(degrees: planeDirection)))
        
        return annotationView
    }
    
    //MARK: private functions
    
    private func setMapRegion() {
        var regionRect = geodesicPolyline.boundingMapRect
        var wPadding = regionRect.size.width * 0.25
        var hPadding = regionRect.size.height * 0.25
        
        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        mapView.setRegion(MKCoordinateRegionForMapRect(regionRect), animated: true)
    }
    
    private func updatePlanePosition() {
        let step = 5
        guard planeAnnotationPosition + step < geodesicPolyline.pointCount
            else { return }
        
        let points = geodesicPolyline.points()
        self.planeAnnotationPosition += step
        let previousMapPoint = points[planeAnnotationPosition]
        planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)

        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.updatePlanePosition()
        }
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        let degrees = radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 360) + 90

        return degrees
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    @IBAction func displayMapView(_ sender: UISwitch) {
        if (switchDisplay.isOn) {
            mapView.mapType = MKMapType.standard
        } else {
            mapView.mapType = MKMapType.satellite
        }
    }
    
    
    
    
}
