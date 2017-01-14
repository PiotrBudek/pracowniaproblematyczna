//
//  Wykres.swift
//  PracowniaProblematyczna
//
//  Created by Michał Banaszyński on 13/01/17.
//  Copyright © 2017 Piotr Budek. All rights reserved.
//

import UIKit
import SwiftChart
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
        startAnimating(CGSize(width: 50, height: 50), message: "Pobieranie danych...", messageFont: UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight), type: NVActivityIndicatorType.ballRotateChase, color: .black, minimumDisplayTime: 2000)
        ref.child("XArray").observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            var xValues: [(x: Float, y: Float)] = []
            if let arrays = snapshot.value as? [[Float]] {
                for index in 0...arrays.first!.count - 1 {
                    let xValue = arrays.last![index]
                    let yValue = arrays.first![index]
                    xValues.append((x: xValue, y: yValue))
                }
            }
            let chart = Chart(frame: CGRect.zero)
            let data = ChartSeries(data: xValues)
            chart.add(data)
            chart.xLabels = [0, 7.5, 12, 0]
            chart.xLabelsFormatter = {String(Int($1)) + "s"}
            self.wykresView.addSubview(chart)
            chart.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(150)
            })
            let xLabel = UILabel()
            xLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
            xLabel.text = "Przyspieszenie wzdłuż osi x"
            xLabel.textAlignment = .center
            self.wykresView.addSubview(xLabel)
            xLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top).offset(150)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(20)
            })
        })
        
        ref.child("YArray").observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            var xValues: [(x: Float, y: Float)] = []
            if let arrays = snapshot.value as? [[Float]] {
                for index in 0...arrays.first!.count - 1 {
                    let xValue = arrays.last![index]
                    let yValue = arrays.first![index]
                    xValues.append((x: xValue, y: yValue))
                }
            }
            let chart = Chart(frame: CGRect.zero)
            let data = ChartSeries(data: xValues)
            chart.add(data)
            chart.xLabels = [0, 7.5, 12, 0]
            chart.xLabelsFormatter = {String(Int($1)) + "s"}
            self.wykresView.addSubview(chart)
            chart.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top).offset(210)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(150)
            })
            let xLabel = UILabel()
            xLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
            xLabel.text = "Przyspieszenie wzdłuż osi y"
            xLabel.textAlignment = .center
            self.wykresView.addSubview(xLabel)
            xLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top).offset(210 + 150)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(20)
            })
        })

        ref.child("ZArray").observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            var xValues: [(x: Float, y: Float)] = []
            if let arrays = snapshot.value as? [[Float]] {
                for index in 0...arrays.first!.count - 1 {
                    let xValue = arrays.last![index]
                    let yValue = arrays.first![index]
                    xValues.append((x: xValue, y: yValue))
                }
            }
            let chart = Chart(frame: CGRect.zero)
            let data = ChartSeries(data: xValues)
            chart.xLabels = [0, 7.5, 12, 0]
            chart.xLabelsFormatter = {String(Int($1)) + "s"}
            chart.add(data)
            self.wykresView.addSubview(chart)
            chart.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top).offset(420)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(150)
            })
            let xLabel = UILabel()
            xLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightUltraLight)
            xLabel.text = "Przyspieszenie wzdłuż osi z"
            xLabel.textAlignment = .center
            self.wykresView.addSubview(xLabel)
            xLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.wykresView.snp.top).offset(420 + 150)
                make.left.equalTo(self.wykresView.snp.left)
                make.right.equalTo(self.wykresView.snp.right)
                make.height.equalTo(20)
            })
        })

        self.stopAnimating()
    }
    
}
