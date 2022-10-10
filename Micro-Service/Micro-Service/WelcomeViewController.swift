
import UIKit
import CoreLocation

class WelcomeViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    
    var locationManager = CLLocationManager()
    
    var server = Server()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
        getUserLocation()
        server.printInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserLocation()

    }
}

extension WelcomeViewController {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sakura"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        view.backgroundColor = .systemPink
    }
    
    func layout() {
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension WelcomeViewController {
    func showAlertLocation() {
        let alert = UIAlertController(title: "Служба геолокации выключена", message: "Хотите включить?", preferredStyle: .alert)
        
        let settingsAcrion = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(settingsAcrion)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - Location
extension WelcomeViewController: CLLocationManagerDelegate {
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        }
    
    func getUserLocation() {
        if checkAuthorization() {
            setupManager()
        } else {
            showAlertLocation()
        }
    }
    
    func checkAuthorization() -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .notDetermined, .restricted: return false
        }    
    }
    
    // MARK:  location delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            print("latitude = \(lat), longitude = \(lon)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}

