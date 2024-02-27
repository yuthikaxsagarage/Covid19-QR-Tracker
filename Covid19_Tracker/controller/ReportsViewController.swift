//
//  ReportsViewController.swift
//  Covid19_Tracker
//
//  Created by Harshana Rathnamalala on 5/7/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class ReportsViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    let realm = try! Realm()
    var patientList:Results<Patient>?
    var dates = [String]()
    var reps = [Int]()
    var patients = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = true
        barChartView.chartDescription?.text = "Quarntine persons per day"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        if let list = patientList{
            getDates(list: list)
        }
        if dates.count > 0 {
            getPatientsPerDayDictionary(dates: dates, list: patientList!)
        }
        repsPerDay()
        printData()
        setChart(dataPoints: dates, values: reps)
        customizeChart(dataPoints: dates, values: reps)
        reloadData()
    }
    
    //MARK: - load Patients
    func loadData() {
        patientList = realm.objects(Patient.self)
        
    }
    
    func reloadData() {
        reps = [Int]()
        if let list = patientList{
            getDates(list: list)
        }
        if dates.count > 0 {
            getPatientsPerDayDictionary(dates: dates, list: patientList!)
        }
        repsPerDay()
        printData()
        setChart(dataPoints: dates, values: reps)
        customizeChart(dataPoints: dates, values: reps)
    }
    
    //MARK: - Bar Charts
    func setChart(dataPoints: [String], values: [Int]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Qurantine Details")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    //MARK: - Pie Chart
    func customizeChart(dataPoints: [String], values: [Int]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: Double(values[i]), label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // 4. Assign it to the chart's data
        pieChartView.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    //MARK: - Making dataset
    func getDates(list: Results<Patient>) {
        for patient in list {
            if !dates.contains(dateFormat(patient.dateCreated!)) {
                dates.append(dateFormat(patient.dateCreated!))
            }
        }
    }
    
    func getPatientsPerDayDictionary(dates: [String], list: Results<Patient>) {
        var reps = 0
        for date in dates {
            for patient in list {
                if(date.contains(dateFormat(patient.dateCreated!))) {
                    reps += 1
                }
            }
            patients[date] = reps
        }
    }
    
    func repsPerDay() {
        var index = 0
        for val in patients.values {
            if patients.count > index  {
                reps.append(val)
                index += 1
            } else {
                break
            }
        }
    }
    
    func printData(){
        for item in dates {
            print(item)
        }
        for item in reps {
            print(item)
        }
    }
    
    func dateFormat(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
}
