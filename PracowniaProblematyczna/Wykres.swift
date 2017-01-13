//
//  Wykres.swift
//  PracowniaProblematyczna
//
//  Created by Michał Banaszyński on 13/01/17.
//  Copyright © 2017 Piotr Budek. All rights reserved.
//

import UIKit
import SwiftCharts
import Firebase
import SnapKit
import NVActivityIndicatorView

class Wykres: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var wykresView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateChart()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateChart() {
        let ref = FIRDatabase.database().reference()
        var xPoints = [(Double, Double)]()
        startAnimating(CGSize(width: 50, height: 50), message: "Pobieranie danych...", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight), type: NVActivityIndicatorType.ballRotateChase, color: .black, minimumDisplayTime: 2000)
        ref.child("XArray").observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            self.stopAnimating()
            if let arrays = snapshot.value as? [[Double]] {
                for index in 0...arrays.first!.count - 1 {
                    let xValue = Double(arrays.last![index])
                    let yValue = Double(arrays.first![index])
                    xPoints.append((xValue, yValue))
                }
            }
            let chartConfig = ChartConfigXY(xAxisConfig: ChartAxisConfig(from: -1, to: 1, by: 0.2), yAxisConfig:ChartAxisConfig(from: 0, to: 15000, by: 500))
            let chart = LineChart(frame: self.wykresView.frame, chartConfig: chartConfig, xTitle: "radiany", yTitle: "", lines: [])
            self.wykresView.addSubview(chart.view)
        })
        
    }
}
