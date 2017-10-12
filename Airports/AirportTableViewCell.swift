//
//  AirportTableViewCell.swift
//  Airports
//
//  Created by Joep on 28-09-17.
//  Copyright © 2017 Joep. All rights reserved.
//

import UIKit

class AirportTableViewCell: UITableViewCell {

    //MARK: properties
    
    @IBOutlet weak var imageViewAirport: UIImageView!
    @IBOutlet weak var airportIcao: UILabel!
    @IBOutlet weak var airportName: UILabel!
    @IBOutlet weak var airportLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
