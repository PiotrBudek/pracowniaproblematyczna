//
//  ViewController.swift
//  PracowniaProblematyczna
//
//  Created by Michal Banaszyński on 10/11/2016.
//  Copyright © 2016 Piotr Budek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreMotion

class Akcelerometr: UIViewController, UITextFieldDelegate {
    
    // Referencje do obiektów interfejsu użytkownika
    @IBOutlet weak var czestotliwośćTextField: UITextField!
    @IBOutlet weak var wyswietlanieX: UILabel!
    @IBOutlet weak var wyswietlanieY: UILabel!
    @IBOutlet weak var wyswietlanieZ: UILabel!
    
    @IBOutlet weak var wyswietlanieXt: UILabel!
    @IBOutlet weak var wyswietlanieYt: UILabel!
    @IBOutlet weak var wyswietlanieZt: UILabel!
    
    @IBOutlet weak var przejdzDoWykresu: UIButton!
    // Wskaźnik do początkowego punktu bazy danych
    let refToDatabase = FIRDatabase.database().reference()
    
    // Tworzenie instancji obiektu klasy CMMotionManager w celu umożliwienia korzystania z akcelerometru/żyroskopu
    let manager = CMMotionManager()
    var start: Bool!
    var czestotliwosc: Float = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        czestotliwośćTextField.delegate = self
        start = false
    }
    
    @IBAction func startStop(_ sender: Any) {
        let deadlineTime = DispatchTime.now() + 14.0
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [unowned self] in
            self.manager.stopAccelerometerUpdates()
            self.przejdzDoWykresu.isEnabled = true
        }
        if start == true {
            start = false
            self.przejdzDoWykresu.isEnabled = false
            manager.stopAccelerometerUpdates()
        } else {
            start = true
            var xt: Float = 0
            var yt: Float = 0
            var zt: Float = 0
            // Sprawdzenie dostępności czujnika
            manager.startAccelerometerUpdates()
            manager.accelerometerUpdateInterval = TimeInterval(NSNumber(value: self.czestotliwosc))
            if manager.isAccelerometerAvailable {
                var xArray: [[Float]] = [[], []]
                var yArray: [[Float]] = [[], []]
                var zArray: [[Float]] = [[], []]
                // Czas początkowy
                let startTime: Int = {
                    let startDate = Date()
                    let since1970 = startDate.timeIntervalSince1970
                    return Int(since1970 * 1000)
                }()
                
                // Czas odświeżania wartości z czujników
                // Rozpoczęcie procesu aktualizacji wartości czujników
                manager.startAccelerometerUpdates()
                // Utworzenie wątku do obróbki danych z czujników
                let queue = OperationQueue.current
                // Procedura odczytu danych w osobnym wątku
                manager.startAccelerometerUpdates(to: queue!, withHandler: { [unowned self](data, error) in
                    if let acceleration = data?.acceleration {
                        // X
                        let xAxis = round(acceleration.x * 10000)/10000
                        // Wyświetlenie na ekranie wartości X
                        self.wyswietlanieX.text = "X: \(xAxis)"
                        // Wysłanie na serwer wartości X
                        xt.add(self.czestotliwosc)
                        self.wyswietlanieXt.text = "xt: \(xt)"
                        xArray[0].append(Float(xAxis))
                        xArray[1].append(Float(xt))
                        self.refToDatabase.child("XArray").setValue(xArray)
                        
                        // Y
                        let yAxis = round(acceleration.y * 10000)/10000
                        // Wyświetlenie na ekranie wartości Y
                        self.wyswietlanieY.text = "Y: \(yAxis)"
                        // Wysłanie na serwer wartości Y
                        yt += self.czestotliwosc
                        self.wyswietlanieYt.text = "yt: \(yt)"
                        yArray[0].append(Float(yAxis))
                        yArray[1].append(Float(yt))
                        self.refToDatabase.child("YArray").setValue(yArray)
                        
                        // Z
                        let zAxis = round(acceleration.z * 10000)/10000
                        // Wyświetlenie na ekranie wartości Z
                        self.wyswietlanieZ.text = "Z: \(zAxis)"
                        // Wysłanie na serwer wartości Z
                        zt += self.czestotliwosc
                        self.wyswietlanieZt.text = "zt: \(zt)"
                        zArray[0].append(Float(zAxis))
                        zArray[1].append(Float(zt))
                        self.refToDatabase.child("ZArray").setValue(zArray)
                    }
                })
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            czestotliwosc = Float(text)!
        }
        return true
    }
}

