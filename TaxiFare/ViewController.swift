//
//  ViewController.swift
//  TaxiFare
//
//  Created by leeyuno on 09/07/2019.
//  Copyright © 2019 leeyuno. All rights reserved.
//

import CoreLocation
import UIKit

/*
 기본요금: 3800원(~2km)
 시간요금: 100원(31초) - 1초 3.22원정도
 거리요금: 100원(132m) - 1미터 0.75원 정도
 #1초가 약 4.2m 금액
 할증기본: 4600원(~2km)
 할   증: 20%(기본, 시간, 거리)
 10원단위 반올림
 */

class ViewController: UIViewController {
    @IBOutlet weak var overChargeLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var meterLabel: UILabel!
    
    var nowFare: Int = 3000
    var basicMeter: Int = 2000
    let manager = CLLocationManager()
    var currentSpeed: Int = 0
    
    var timer: Timer!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        timer.fire()
        
        meterLabel.text = "\(basicMeter)m"
        fareLabel.text = "\(nowFare)원"
        
        overCharge()
    }
    
    private func configureCoreLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.startUpdatingLocation()
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButton(_ sender: UIButton) {
        if startButton.currentTitle == "출발" {
            start()
            startButton.setTitle("정지", for: .normal)
        } else if startButton.currentTitle == "정지" {
            stop()
            startButton.setTitle("출발", for: .normal)
        }
    }
    
    private func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(charge), userInfo: nil, repeats: true)
    }
    
    let payView = UIView()
    let label = UILabel()
    let button = UIButton()
    
    private func stop() {
        payView.translatesAutoresizingMaskIntoConstraints = false
        payView.backgroundColor = UIColor.white
        payView.layer.masksToBounds = true
        payView.layer.cornerRadius = 10
        
        view.addSubview(payView)
        
        payView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        payView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        payView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        payView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.6).isActive = true
        
        label.attributedText = NSAttributedString(string: "요금은 \(nowFare)원 입니다", attributes: [.font: UIFont.systemFont(ofSize: 25.0, weight: .medium), .foregroundColor: UIColor.black])
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(end), for: .touchUpInside)
//        button.setTitle("결제완료", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "결제완료", attributes: [.font: UIFont.systemFont(ofSize: 20.0, weight: .bold), .foregroundColor: UIColor(red:0.04, green:0.38, blue:1.00, alpha:1.0)]), for: .normal)
        button.setTitleColor(UIColor(red:0.04, green:0.38, blue:1.00, alpha:1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        payView.addSubview(button)
        payView.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: payView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: payView.centerYAnchor, constant: -30).isActive = true
        
        button.centerXAnchor.constraint(equalTo: payView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: payView.centerYAnchor, constant: 30).isActive = true
        
        basicMeter = 500
        meterLabel.text = String(basicMeter) + "m"
        timer.invalidate()
    }
    
    @objc private func end() {
        nowFare = 0
        basicMeter = 500
        fareLabel.text = "0원"
        meterLabel.text = "2000m"
        
        label.removeFromSuperview()
        button.removeFromSuperview()
        payView.removeFromSuperview()
    }
    
    @objc private func charge() {
        if basicMeter <= 0 {
            basicMeter = 2000
            nowFare += 100
            fareLabel.text = "\(nowFare)원"
        } else {
            basicMeter -= 4
        }
//
        meterLabel.text = String(basicMeter) + "m"
//        nowFare += 100
//        fareLabel.text = "\(nowFare)원"
    }
    
    private func overCharge() {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
//        print(dateFormatter.string(from: date))
        
//        let startTime = "17:00:00"
//        let endTime = "19:00:00"
//
//        let startTime1 = dateFormatter.date(from: startTime)!
//        let endTime1 = dateFormatter.date(from: endTime)!
//
//
//        let time = dateFormatter.string(from: date)
//        let time1 = dateFormatter.date(from: time)!
//
//        print(time1.timeIntervalSince(startTime1))
//        print(time1.timeIntervalSince(endTime1))
        
//        print(startTime1?.timeIntervalSince(time1))
//        print(endTime1?.timeIntervalSince(time1))
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.speed ?? 0.0)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

