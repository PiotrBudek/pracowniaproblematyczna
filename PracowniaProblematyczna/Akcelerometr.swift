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

class Akcelerometr: UIViewController {
    
    // Referencje do obiektów interfejsu użytkownika
    @IBOutlet weak var wyswietlanieX: UILabel!
    @IBOutlet weak var wyswietlanieY: UILabel!
    @IBOutlet weak var wyswietlanieZ: UILabel!
    
    @IBOutlet weak var wyswietlanieXt: UILabel!
    @IBOutlet weak var wyswietlanieYt: UILabel!
    @IBOutlet weak var wyswietlanieZt: UILabel!
    
    // Wskaźnik do początkowego punktu bazy danych
    let refToDatabase = FIRDatabase.database().reference()
    
    // Tworzenie instancji obiektu klasy CMMotionManager w celu umożliwienia korzystania z akcelerometru/żyroskopu
    let manager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sprawdzenie dostępności czujnika
        if manager.isAccelerometerAvailable {
            
            // Czas odświeżania wartości z czujników
            manager.accelerometerUpdateInterval = 0.6
            // Rozpoczęcie procesu aktualizacji wartości czujników
            manager.startAccelerometerUpdates()
            // Utworzenie wątku do obróbki danych z czujników
            let queue = OperationQueue.current
            // Procedura odczytu danych w osobnym wątku
            manager.startAccelerometerUpdates(to: queue!, withHandler: { (data, error) in
                
                if let acceleration = data?.acceleration {
                    
                    // X
                    let xAxis = round(acceleration.x * 10000)/10000
                    // Wyświetlenie na ekranie wartości X
                    self.wyswietlanieX.text = "X - \(xAxis)"
                    // Wysłanie na serwer wartości X
                    self.refToDatabase.child("X").setValue(xAxis)
                    let xt = mach_absolute_time()
                    self.wyswietlanieXt.text = "xt - \(xt)"
                    self.refToDatabase.child("Xt").setValue(xt)
                    
                    // Y
                    let yAxis = round(acceleration.y * 10000)/10000
                    // Wyświetlenie na ekranie wartości Y
                    self.wyswietlanieY.text = "Y - \(yAxis)"
                    // Wysłanie na serwer wartości Y
                    self.refToDatabase.child("Y").setValue(yAxis)
                    let yt = mach_absolute_time()
                    self.wyswietlanieYt.text = "yt - \(yt)"
                    self.refToDatabase.child("Yt").setValue(yt)
                    
                    // Z
                    let zAxis = round(acceleration.z * 10000)/10000
                    // Wyświetlenie na ekranie wartości Z
                    self.wyswietlanieZ.text = "Z - \(zAxis)"
                    // Wysłanie na serwer wartości Z
                    self.refToDatabase.child("Z").setValue(zAxis)
                    let zt = mach_absolute_time()
                    self.wyswietlanieZt.text = "zt - \(zt)"
                    self.refToDatabase.child("Zt").setValue(zt)
                }
                
            })
        }
    }
}

