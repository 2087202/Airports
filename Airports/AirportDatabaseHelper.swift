import Foundation
import SQLite
import MapKit

class AirportDatabaseHelper : NSObject {
    
    //MARK: properties
    
    var db : Connection!
    let airportTable = Table("airports")
    let name = Expression<String>("name")
    let elevation = Expression<Double?>("elevation")
    let longitude = Expression<Double?>("longitude")
    let latitude = Expression<Double?>("latitude")
    let iso_country = Expression<String>("iso_country")
    let municipality = Expression<String>("municipality")
    let icao = Expression<String>("icao")
    
    override init() {
        
        // path to airports database
        let path = Bundle.main.path(forResource: "airports", ofType: "sqlite")
        
        do {
            db = try Connection(path!)
            
        } catch {
            print(error)
        }
    }
    
    //MARK: Database functions
    
    public func groupAirportsBy() {
    
        do {
            
            let query = "SELECT * FROM airports ORDER BY iso_country"
            
            let airports = try db.prepare(query)
            
           // let array = Array(airports)
            
            
            
            for airport in airports {
                print(airport)
            }
        
        } catch {
            print(error)
        }
    }
    
    public func getSections() -> Array<String> {
       
        var sections = [String]()
        
        do {
        
        let countries = try db.prepare(airportTable.select(distinct: iso_country).order(iso_country))
        
            for country in countries {
               sections.append(country.get(iso_country))
            }
            
       
         
        } catch {
            print(error)
        }
         return sections
        
    }
    
    public func getAllAirports() -> Array<Airport> {
        
        var airports = [Airport]()
        
        do {
           
            for airport in try db.prepare(airportTable.order(iso_country)) {
                
                let ap = Airport()
                var lat = 0.0
                var long = 0.0
               
                ap.icao = airport.get(icao)
                ap.iso_country = airport.get(iso_country)
                
                if (airport.get(longitude) != nil) {
                    long = airport.get(longitude)!
                }
                
                if (airport.get(latitude) != nil) {
                   lat = airport.get(latitude)!
                }
             
                ap.setLocation(long: long, lat: lat)
                ap.municipality = airport.get(municipality)
                ap.name = airport.get(name)
                
                airports.append(ap)
            }
            
        } catch {
            print (error)
        }
        
        return airports
    }
}
