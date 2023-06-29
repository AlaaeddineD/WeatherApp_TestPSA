//
//  CityDetailsViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit

class CityDetailsViewController: UIViewController {
    
    static let storyboardIdentifier = "CityDetailsView"
    
    //Outlets
    @IBOutlet weak var refreshAlertLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempIcon: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var snowLabel: UILabel!
    
    private var city: City
    
    init?(coder: NSCoder, city: City) {
        self.city = city
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:city:)` to initialize an `CityDetailsViewController` instance.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
