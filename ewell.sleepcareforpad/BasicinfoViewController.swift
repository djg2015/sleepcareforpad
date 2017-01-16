//
//  BasicinfoViewController.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class BasicinfoViewController: UIViewController {
    @IBOutlet weak var lblTopname: UILabel!
    @IBOutlet weak var lblEquipmentID: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTel: UILabel!
    @IBOutlet weak var lblBingli: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var chartView: UIView!
    var HrRrChartView = ChartView()
    
    
    var hrrrWarning:UILabel!
    
    var basicinfoViewModel:BasicinfoViewModel!
    
    var chartWidth:CGFloat = 0.0
    var chartHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.basicinfoViewModel  = BasicinfoViewModel()
        
        self.lblTopname.text = Session.GetSession()!.CurUserName
        self.lblEquipmentID.text = Session.GetSession()!.CurEquipmentID


        Settings()
        
        InitChartView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InitChartView(){
        self.chartWidth = self.chartView.frame.size.width
        self.chartHeight = self.chartView.frame.size.height
        
        hrrrWarning = TableLabel(frame: CGRectMake(0, 150, chartWidth, chartHeight))
        hrrrWarning.text = "没有心率和呼吸数据折线图"
     
        
        
        HrRrChartView.frame = CGRectMake(0, 0, chartWidth, chartHeight)
        if self.basicinfoViewModel.HRRRRange.flag{
            HrRrChartView.Type = "1"
            let titleNameList1 = "心率"
            let titleNameList2 = "呼吸"
            HrRrChartView.valueAll = self.basicinfoViewModel.HRRRRange.ValueY as [AnyObject]
            HrRrChartView.valueXList =  self.basicinfoViewModel.HRRRRange.ValueX as [AnyObject]
            HrRrChartView.valueTitleNames = NSArray(objects:titleNameList1,titleNameList2) as [AnyObject]
            HrRrChartView.addTrendChartView(CGRectMake(0, 0, chartWidth, chartHeight))
           self.chartView.addSubview(HrRrChartView)
        }
        else{
          self.chartView.addSubview(hrrrWarning)
        }

    }
    
    func Settings(){
        RACObserve(self.basicinfoViewModel, "Name") ~> RAC(self.lblName, "text")
        RACObserve(self.basicinfoViewModel, "Tel") ~> RAC(self.lblTel, "text")
        RACObserve(self.basicinfoViewModel, "Bingli") ~> RAC(self.lblBingli, "text")
        RACObserve(self.basicinfoViewModel, "Sex") ~> RAC(self.lblSex, "text")
        RACObserve(self.basicinfoViewModel, "Address") ~> RAC(self.lblAddress, "text")
    }
  

}
