//
//  CityDetailsViewController.swift
//  WeatherApp_TestPSA
//
//  Created by WG CONSULTING on 29/06/2023.
//

import UIKit

protocol CityDetailsVCProtocol{
    func showErrorAlertWithMessage(message: String)
    func presentData(alertLabelMessage: String,
                     cityName: String,
                     country: String,
                     temp: String,
                     icon: String,
                     feelsLike: String,
                     callTime: String,
                     callDate: String,
                     sunriseTime: String,
                     sunsetTime: String,
                     humidity: String,
                     windSpeed: String,
                     cloudiness: String,
                     rain: String,
                     snow: String
    )
    func showHideLoadingSpinner(show: Bool)
}

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
    
    private let viewModel: CityDetailsViewModel
    private let spinner = SpinnerViewController()
    
    init?(coder: NSCoder, city: City) {
        viewModel = CityDetailsViewModel(city: city)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:city:)` to initialize an `CityDetailsViewController` instance.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style:.plain,
            target: self,
            action: #selector(refreshCityWeatherData)
        )
        
        viewModel.delegate = self
        viewModel.decideWhatDataToShow(isRefreshing: false)
    }
    
    @objc func refreshCityWeatherData(){
        viewModel.decideWhatDataToShow(isRefreshing: true)
    }
}

//MARK: ViewModel delegation methods
extension CityDetailsViewController: CityDetailsVCProtocol{
    
    /// Afficher une alerte simple avec un message
    func showErrorAlertWithMessage(message: String) {
        let dialogAlert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        dialogAlert.addAction(alertAction)
        
        present(dialogAlert, animated: true)
    }
    
    ///Remplissez le champ avec les données de la ville
    func presentData(alertLabelMessage: String,
                     cityName: String,
                     country: String,
                     temp: String,
                     icon: String,
                     feelsLike: String,
                     callTime: String,
                     callDate: String,
                     sunriseTime: String,
                     sunsetTime: String,
                     humidity: String,
                     windSpeed: String,
                     cloudiness: String,
                     rain: String,
                     snow: String
    ){
        refreshAlertLabel.text = alertLabelMessage
        tempLabel.text = temp
        tempIcon.image = UIImage(named: icon)
        feelsLikeLabel.text = feelsLike
        cityLabel.text = cityName
        countryLabel.text = country
        timeLabel.text = callTime
        dateLabel.text = callDate
        humidityLabel.text = humidity
        windLabel.text = windSpeed
        cloudinessLabel.text = cloudiness
        sunriseLabel.text = sunriseTime
        sunsetLabel.text = sunsetTime
        rainLabel.text = rain
        snowLabel.text = snow
    }
    
    func showHideLoadingSpinner(show: Bool){
        if show {
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        }else {
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
        }
    }
}
