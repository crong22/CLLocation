//
//  ViewController.swift
//  CLLocation
//
//  Created by 여누 on 6/22/24.
//

import UIKit
import Alamofire
import SnapKit
import CoreLocation
import MapKit
import Kingfisher

class ViewController: UIViewController {
    
    let dateLabel = UILabel()
    let areaButton = UIButton()
    let reButton = UIButton()
    let mainView = UIView()
    let tempLabel = UILabel()
    let humidityLable = UILabel()
    let windLabel = UILabel()
    let weatherImage = UIImageView()
    let textLabel = UILabel()
    var todayDate = Date()
    
    var list = Weather(main: weather(feels_like: 0.0, humidity: 0), weather: [], wind: wind(speed: 0.0))
    // 2. 위치매니저생성 : 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250/250, green: 173/250, blue: 124/250, alpha: 0.6)
        
        configureAdd()
        dateChange()
        configureUI()
        
        // 4. 클래스와 프로토콜 연결
        locationManager.delegate = self
        
    }
    func configureAdd() {
        view.addSubview(dateLabel)
        view.addSubview(areaButton)
        view.addSubview(reButton)
        view.addSubview(mainView)
        
        
        mainView.addSubview(tempLabel)
        mainView.addSubview(humidityLable)
        mainView.addSubview(windLabel)
        mainView.addSubview(weatherImage)
        mainView.addSubview(textLabel)
    }
    
    func dateChange()  -> String {
        let curDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "MM월 dd일 HH시 mm분"
        UserDefaults.standard.setValue(formatter.string(from: curDate), forKey: "currentDate")
        return formatter.string(from: curDate)
    }
    
    func configureUI() {
        let currentDate = UserDefaults.standard.string(forKey: "currentDate")
        dateLabel.text = currentDate!
        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .left
        dateLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
        }
        reButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        reButton.contentMode = .scaleToFill
        reButton.tintColor = .white
        reButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaInsets).offset(-20)
            make.height.equalTo(40)
        }
        reButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        
        
        if let titleLabel = areaButton.titleLabel {
            titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        }
        areaButton.contentMode = .scaleToFill
        areaButton.tintColor = .white
        areaButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaInsets).offset(20)
            make.height.equalTo(40)
        }
        
        tempLabel.backgroundColor = .white
        tempLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tempLabel.layer.cornerRadius = 5
        tempLabel.clipsToBounds = true
        tempLabel.textAlignment = .center
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(areaButton.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        humidityLable.backgroundColor = .white
        humidityLable.font = .systemFont(ofSize: 14, weight: .semibold)
        humidityLable.layer.cornerRadius = 5
        humidityLable.clipsToBounds = true
        humidityLable.textAlignment = .center
        humidityLable.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        windLabel.backgroundColor = .white
        windLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        windLabel.layer.cornerRadius = 5
        windLabel.clipsToBounds = true
        windLabel.textAlignment = .center
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLable.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        weatherImage.backgroundColor = .white
        weatherImage.layer.cornerRadius = 5
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(windLabel.snp.bottom).offset(10)
            make.height.equalTo(150)
            make.width.equalTo(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        textLabel.backgroundColor = .white
        textLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        textLabel.textAlignment = .center
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    
    @objc func locationButtonClicked() {
        print(#function)
        
        checkDeviceLocationAuthorization()
    }
    
    func callRequest(lat: Double, lon : Double) {
        print(#function)
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.weatherKey)&lang=kr&units=metric"
        print("url \(url)")
        AF.request(url,
                   method: .get)
                .responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case .success(let value):
                        print("SUCCESS")
                        self.list = value
                        self.tempLabel.text = " 지금은 \(value.main.feels_like)°C 에요  "
                        self.humidityLable.text = " \(value.main.humidity)% 만큼 습해요  "
                        self.windLabel.text = " \(value.wind.speed)m/s의 바람이 불어요  "
                        let imageIcon = value.weather[0].icon
                        print("이미지아이콘 : \(imageIcon)")
                        let url = URL(string: "https://openweathermap.org/img/wn/\(imageIcon)@2x.png")
                        print("주소 : \(url)")
                        self.weatherImage.kf.setImage(with: url)
                        self.textLabel.text = " 오늘도 행복한 하루 보내세요"
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                   }
}

extension ViewController {
    
    // 1 ) 사용자에게 권한 요청을 하기 위해서, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            // 2 ) 현재 사용자 위치 권환 상태 확인
            checkCurrentLocationAuthorization()
        }else {
            print("위치 서비스 OFF, 위치 권환 요청 X")
        }
    }

    
    // 2 ) 현재 사용자 위치 권환 상태 확인
    func checkCurrentLocationAuthorization() {
        var status = locationManager.authorizationStatus
        
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        switch status {
        case .notDetermined:
            print("이 권한에서만 권한 문구를 띄울 수 있음")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("iOS 설정 창으로 이동하라는 alert")
        case .authorizedWhenInUse:
            print("위치 정보 알려달라고 로직을 구성")
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            UserDefaults.standard.setValue(coordinate.latitude, forKey: "latitude")
            UserDefaults.standard.setValue(coordinate.longitude, forKey: "longitude")
            
            // 위도,경도 값으로 주소 얻기
            let findLocation: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geoCoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "Ko-kr") // Korea
            geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [self] (place, error) in
                if let address: [CLPlacemark] = place {
                    print("시(도): \(String(describing: address.last?.administrativeArea))")
                    print("구(군): \(String(describing: address.last?.subLocality))")
                    
                    var administrativeArea = address.last?.administrativeArea
                    let startIndex = administrativeArea?.index(administrativeArea!.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
                    let endIndex = administrativeArea?.index(administrativeArea!.startIndex, offsetBy: 2)// 사용자지정 끝인덱스
                    administrativeArea = String(administrativeArea![startIndex! ..< endIndex!])
                    let subLocality = address.last?.subLocality!
                    self.areaButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
                    self.areaButton.setTitle("  \(administrativeArea!), \(subLocality!)", for: .normal)
                    
                    
                    let latitude = UserDefaults.standard.double(forKey: "latitude")
                    let longitude = UserDefaults.standard.double(forKey: "longitude")
                    print("latitude \(latitude), longitude \(longitude)")
                    callRequest(lat: latitude, lon: longitude)
                }
            }
        }

        locationManager.stopUpdatingLocation()

    }
    
    // 6. 사용자 위치를 가지고 오지 못한 경우
    // 7. 사용자 권한 상태가 변경이 될 때(iOS14) + 인스턴스가 생성이 될 때도 호출이 된다.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "iOS14이상")
        checkDeviceLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function, "iOS14이하")
    }
}

