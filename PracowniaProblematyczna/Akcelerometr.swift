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
import SwiftCharts

class Akcelerometr: UIViewController {
    
    // Referencje do obiektów interfejsu użytkownika
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            var xt: Double = 0
            var yt: Double = 0
            var zt: Double = 0
            // Sprawdzenie dostępności czujnika
            manager.startAccelerometerUpdates()
            if manager.isAccelerometerAvailable {
                var xArray: [[Double]] = [[], []]
                var yArray: [[Double]] = [[], []]
                var zArray: [[Double]] = [[], []]
                // Czas początkowy
                let startTime: Int = {
                    let startDate = Date()
                    let since1970 = startDate.timeIntervalSince1970
                    return Int(since1970 * 1000)
                }()
                
                // Czas odświeżania wartości z czujników
                manager.accelerometerUpdateInterval = 0.5
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
                        self.refToDatabase.child("X").setValue(xAxis)
                        xt += 0.5
                        self.wyswietlanieXt.text = "xt: \(xt)"
                        xArray[0].append(xAxis)
                        xArray[1].append(Double(xt))
                        self.refToDatabase.child("Xt").setValue(xt)
                        self.refToDatabase.child("XArray").setValue(xArray)
                        
                        // Y
                        let yAxis = round(acceleration.y * 10000)/10000
                        // Wyświetlenie na ekranie wartości Y
                        self.wyswietlanieY.text = "Y: \(yAxis)"
                        // Wysłanie na serwer wartości Y
                        self.refToDatabase.child("Y").setValue(yAxis)
                        yt += 0.5
                        self.wyswietlanieYt.text = "yt: \(yt)"
                        self.refToDatabase.child("Yt").setValue(yt)
                        
                        // Z
                        let zAxis = round(acceleration.z * 10000)/10000
                        // Wyświetlenie na ekranie wartości Z
                        self.wyswietlanieZ.text = "Z: \(zAxis)"
                        // Wysłanie na serwer wartości Z
                        self.refToDatabase.child("Z").setValue(zAxis)
                        zt += 0.5
                        self.wyswietlanieZt.text = "zt: \(zt)"
                        self.refToDatabase.child("Zt").setValue(zt)
                    }
                })
            }
        }
    }
    
}

