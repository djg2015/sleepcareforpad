//
//  TizhengViewController.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class TizhengViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,SelectDateEndDelegate{
    @IBOutlet weak var lblTopname: UILabel!
    @IBOutlet weak var lblEquipmentID: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var dataview: UIView!
    
    @IBOutlet weak var lblStartTimeSpan: UILabel!
    @IBOutlet weak var lblEndTimeSpan: UILabel!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var lblFlag: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var textType: UITextField!
    @IBOutlet weak var btnType: UIButton!
    @IBAction func ChooseType(sender:UIButton){
    
        self.popDownList.Show(100, height: 80, uiElement: self.lblFlag)
    }
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var textStatus: UITextField!
    @IBOutlet weak var btnStatus: UIButton!
    @IBAction func ChooseStatus(sender:UIButton){
        
        self.popDownList2.Show(80, height: 120, uiElement: self.lblFlag)
    }
    
    
    var tizhengViewModel:TizhengViewModel!
    var alertviewBegin:DatePickerView!
    var alertviewEnd:DatePickerView!
    
     var popDownList:PopDownList!
    var popDownList2:PopDownList!
    
    var tabViewTizheng: UITableView!
    var tabViewLeavebed: UITableView!
    var tableWidth:CGFloat = 0.0
    var tableHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  self.dataview.frame = CGRectMake(35, 120, UIScreen.mainScreen().bounds.width-70, UIScreen.mainScreen().bounds.height-185)
        
        self.tableWidth = self.dataview.frame.size.width
        self.tableHeight = self.dataview.frame.size.height
        
        // 实例当前tabViewTizheng
        self.tabViewTizheng = UITableView(frame: CGRectMake(0,0,self.tableWidth,self.tableHeight), style: UITableViewStyle.Plain)
        self.tabViewTizheng.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewTizheng.delegate = self
        self.tabViewTizheng.dataSource = self
        self.tabViewTizheng.tag = 1
        self.tabViewTizheng.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)

          // tabViewLeavebed
        self.tabViewLeavebed = UITableView(frame: CGRectMake(0,0,self.tableWidth,self.tableHeight), style: UITableViewStyle.Plain)
        self.tabViewLeavebed.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewLeavebed.delegate = self
        self.tabViewLeavebed.dataSource = self
        self.tabViewLeavebed.tag = 2
       self.tabViewLeavebed.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        self.dataview.addSubview(self.tabViewTizheng)
        self.dataview.addSubview(self.tabViewLeavebed)
        self.tabViewTizheng.hidden = false
        self.tabViewLeavebed.hidden = true
        
        // 加载数据
       self.tizhengViewModel = TizhengViewModel()
        self.rac_settings()
       self.tizhengViewModel.tableView = tabViewTizheng
        self.tizhengViewModel.tableView2 = tabViewLeavebed
        
        
        self.lblTopname.text = Session.GetSession()!.CurUserName
        self.lblEquipmentID.text = Session.GetSession()!.CurEquipmentID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 1)
        {
            return self.tizhengViewModel.TizhengList.count
        }
        else
        {
            return self.tizhengViewModel.LeavebedList.count
        }
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView.tag == 1)
        {
            // 创建历史体征tableView的列头
            var headViewTizheng:UIView = UIView(frame: CGRectMake(0, 0, self.tableWidth, 44))
            var lblIndex = TableLabel(frame: CGRectMake(0, 0,  self.tableWidth/10 , 44))
            lblIndex.text = "序号"
            var lblBingli = TableLabel(frame: CGRectMake(self.tableWidth/10, 0, self.tableWidth/10, 44))
            lblBingli.text = "病历号"
            var lblName = TableLabel(frame: CGRectMake(self.tableWidth/5, 0, self.tableWidth/10, 44))
            lblName.text = "姓名"
            var lblBednumber = TableLabel(frame:CGRectMake(self.tableWidth/10*3, 0, self.tableWidth/10, 44))
            lblBednumber.text = "床位号"
            var lblTime = TableLabel(frame:CGRectMake(self.tableWidth/5*2, 0, self.tableWidth/10*3, 44))
            lblTime.text = "分析时段"
            var lblHR = TableLabel(frame:CGRectMake(self.tableWidth/10*7, 0, self.tableWidth/10, 44))
            lblHR.text = "心率"
            var lblRR = TableLabel(frame:CGRectMake(self.tableWidth/5*4, 0, self.tableWidth/10, 44))
            lblRR.text = "呼吸"
            var lblTurntimes = TableLabel(frame:CGRectMake(self.tableWidth/10*9, 0, self.tableWidth/10, 44))
            lblTurntimes.text = "翻身次数"
            
            headViewTizheng.addSubview(lblIndex)
            headViewTizheng.addSubview(lblBingli)
             headViewTizheng.addSubview(lblName)
             headViewTizheng.addSubview(lblBednumber)
            headViewTizheng.addSubview(lblTime)
            headViewTizheng.addSubview(lblHR)
            headViewTizheng.addSubview(lblRR)
            headViewTizheng.addSubview(lblTurntimes)
           
            
            return headViewTizheng
        }
        else
        {
            var headViewTurnOver:UIView = UIView(frame: CGRectMake(0, 0, self.tableWidth, 44))
            var lblIndex = TableLabel(frame: CGRectMake(0, 0,  self.tableWidth/10 , 44))
            lblIndex.text = "序号"
            var lblBingli = TableLabel(frame: CGRectMake(self.tableWidth/10, 0, self.tableWidth/10, 44))
            lblBingli.text = "病历号"
            var lblName = TableLabel(frame: CGRectMake(self.tableWidth/5, 0, self.tableWidth/10, 44))
            lblName.text = "姓名"
            var lblBednumber = TableLabel(frame:CGRectMake(self.tableWidth/10*3, 0, self.tableWidth/10, 44))
            lblBednumber.text = "床位号"
            var lblTime = TableLabel(frame:CGRectMake(self.tableWidth/5*2, 0, self.tableWidth/2, 44))
            lblTime.text = "分析时段"
            var lblStatus = TableLabel(frame:CGRectMake(self.tableWidth/10*9, 0, self.tableWidth/10, 44))
            lblStatus.text = "状态"
            
            headViewTurnOver.addSubview(lblIndex)
            headViewTurnOver.addSubview(lblBingli)
            headViewTurnOver.addSubview(lblName)
            headViewTurnOver.addSubview(lblBednumber)
             headViewTurnOver.addSubview(lblTime)
             headViewTurnOver.addSubview(lblStatus)
            
            return headViewTurnOver
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if(tableView.tag == 1)
        {
            var tizhengTableCell = tableView.dequeueReusableCellWithIdentifier("tizhengcell") as? UITableViewCell
            tizhengTableCell = UITableViewCell(style: .Default, reuseIdentifier: "tizhengcell")
            tizhengTableCell?.userInteractionEnabled = false
            
            var lblCellIndex = TableDataLabel(frame:CGRectMake(0,0, self.tableWidth/10,44))
            var lblCellBingli = TableDataLabel(frame:CGRectMake(self.tableWidth/10,0, self.tableWidth/10,44))
            var lblCellName = TableDataLabel(frame:CGRectMake(self.tableWidth/5,0, self.tableWidth/10,44))
            var lblCellBednumber = TableDataLabel(frame:CGRectMake(self.tableWidth/10*3,0, self.tableWidth/10,44))
             var lblCellTime = TableDataLabel(frame:CGRectMake(self.tableWidth/5*2,0, self.tableWidth/10*3,44))
            var lblCellHR = TableDataLabel(frame:CGRectMake(self.tableWidth/10*7,0, self.tableWidth/10,44))
            var lblCellRR = TableDataLabel(frame:CGRectMake(self.tableWidth/5*4,0, self.tableWidth/10,44))
            var lblCellTurntimes = TableDataLabel(frame:CGRectMake(self.tableWidth/10*9,0, self.tableWidth/10,44))
            
            lblCellIndex.text = String(indexPath.row)
            lblCellBingli.text = self.tizhengViewModel.TizhengList[indexPath.row].BingliCode
            lblCellName.text = self.tizhengViewModel.TizhengList[indexPath.row].PatientName
            lblCellBednumber.text = self.tizhengViewModel.TizhengList[indexPath.row].BedNumber
            lblCellTime.text = self.tizhengViewModel.TizhengList[indexPath.row].AnalysisTime
            lblCellHR.text = self.tizhengViewModel.TizhengList[indexPath.row].AvgHR
            lblCellRR.text = self.tizhengViewModel.TizhengList[indexPath.row].AvgRR
            lblCellTurntimes.text = self.tizhengViewModel.TizhengList[indexPath.row].TurnTimes
            
           tizhengTableCell?.addSubview(lblCellIndex)
            tizhengTableCell?.addSubview(lblCellBingli)
            tizhengTableCell?.addSubview(lblCellName)
            tizhengTableCell?.addSubview(lblCellBednumber)
             tizhengTableCell?.addSubview(lblCellTime)
            tizhengTableCell?.addSubview(lblCellHR)
            tizhengTableCell?.addSubview(lblCellRR)
            tizhengTableCell?.addSubview(lblCellTurntimes)
            
            return tizhengTableCell!
        }
        else
        {
            var leavebedTableCell = tableView.dequeueReusableCellWithIdentifier("leavebedcell") as? UITableViewCell
            leavebedTableCell = UITableViewCell(style: .Default, reuseIdentifier: "leavebedcell")
            leavebedTableCell?.userInteractionEnabled = false
            
            var lblCellIndex = TableDataLabel(frame:CGRectMake(0,0, self.tableWidth/10,44))
            var lblCellBingli = TableDataLabel(frame:CGRectMake(self.tableWidth/10,0, self.tableWidth/10,44))
            var lblCellName = TableDataLabel(frame:CGRectMake(self.tableWidth/5,0, self.tableWidth/10,44))
            var lblCellBednumber = TableDataLabel(frame:CGRectMake(self.tableWidth/10*3,0, self.tableWidth/10,44))
             var lblCellTime = TableDataLabel(frame:CGRectMake(self.tableWidth/5*2,0, self.tableWidth/2,44))
             var lblCellStatus = TableDataLabel(frame:CGRectMake(self.tableWidth/10*9,0, self.tableWidth/10,44))
            
            
            lblCellIndex.text = String(indexPath.row)
            lblCellBingli.text = self.tizhengViewModel.LeavebedList[indexPath.row].BingliCode
            lblCellName.text = self.tizhengViewModel.LeavebedList[indexPath.row].PatientName
            lblCellBednumber.text = self.tizhengViewModel.LeavebedList[indexPath.row].BedNumber
            lblCellTime.text = self.tizhengViewModel.LeavebedList[indexPath.row].BeginTime + "~" + self.tizhengViewModel.LeavebedList[indexPath.row].EndTime
            lblCellStatus.text = self.tizhengViewModel.LeavebedList[indexPath.row].Status
           
            
            leavebedTableCell?.addSubview(lblCellIndex)
            leavebedTableCell?.addSubview(lblCellBingli)
            leavebedTableCell?.addSubview(lblCellName)
             leavebedTableCell?.addSubview(lblCellBednumber)
            leavebedTableCell?.addSubview(lblCellTime)
            leavebedTableCell?.addSubview(lblCellStatus)
            
            return leavebedTableCell!
        }
    }

    
    func rac_settings(){
         self.btnSearch.rac_command = tizhengViewModel.searchCommand
        
        
        var dataSource = Array<DownListModel>()
        var item = DownListModel()
        item.key = "按小时"
        item.value = "按小时"
        dataSource.append(item)
        item = DownListModel()
        item.key = "按天"
        item.value = "按天"
        dataSource.append(item)
        self.popDownList = PopDownList(datasource: dataSource, dismissHandler: self.ChoosedType)
        RACObserve(self.tizhengViewModel, "ChoosedSearchType") ~> RAC(self.textType, "text")
        
        var dataSource2 = Array<DownListModel>()
        var item2 = DownListModel()
        item2.key = "不限"
        item2.value = "不限"
        dataSource2.append(item2)
        item2 = DownListModel()
        item2.key = "在床"
        item2.value = "在床"
        dataSource2.append(item2)
         item2 = DownListModel()
        item2.key = "离床"
        item2.value = "离床"
        dataSource2.append(item2)
        self.popDownList2 = PopDownList(datasource: dataSource2, dismissHandler: self.ChoosedStatus)
        RACObserve(self.tizhengViewModel, "ChoosedSearchStatus") ~> RAC(self.textStatus, "text")
        
        
        //属性绑定
        RACObserve(self.tizhengViewModel, "FuncSelectedIndex") ~> RAC(self.segment, "selectedSegmentIndex")
        self.segment.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext{
            _ in
            self.tizhengViewModel.SelectChange(self.segment.selectedSegmentIndex)
            if(self.tizhengViewModel.FuncSelectedIndex == 0)
            {
                self.tabViewTizheng.hidden = false
                self.tabViewLeavebed.hidden = true
                self.typeView.hidden = false
                self.statusView.hidden = true
            }
            else
            {
                self.tabViewTizheng.hidden = true
                self.tabViewLeavebed.hidden = false
                 self.typeView.hidden = true
                self.statusView.hidden = false
            }
        }
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DatePickerBegin")
        self.lblStartTimeSpan.addGestureRecognizer(singleTap)
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DatePickerEnd")
        self.lblEndTimeSpan.addGestureRecognizer(singleTap1)
        
        RACObserve(self.tizhengViewModel, "AnalysisTimeBegin") ~> RAC(self.lblStartTimeSpan, "text")
        RACObserve(self.tizhengViewModel, "AnalysisTimeEnd") ~> RAC(self.lblEndTimeSpan, "text")
        
        
    }
    
    //-------------自定义方法处理---------------
    func DatePickerBegin()
    {
        if alertviewBegin == nil{
            alertviewBegin = DatePickerView(frame:UIScreen.mainScreen().bounds)
            alertviewBegin.detegate = self
            alertviewBegin.tag = 1
        }
        self.view.addSubview(alertviewBegin)
        
    }
    
    func DatePickerEnd()
    {
        if alertviewEnd == nil{
            alertviewEnd = DatePickerView(frame:UIScreen.mainScreen().bounds)
            alertviewEnd.detegate = self
            alertviewEnd.tag = 2
            
        }
        self.view.addSubview(alertviewEnd)
    }
    
    
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        if(sender.tag == 1)
        {
            self.tizhengViewModel.AnalysisTimeBegin = dateString
        }
        else
        {
            self.tizhengViewModel.AnalysisTimeEnd = dateString
        }
    }

    //选中查询类型
    func ChoosedType(downListModel:DownListModel){
       self.tizhengViewModel.ChoosedSearchType = downListModel.value
    }

    //选中查询类型
    func ChoosedStatus(downListModel:DownListModel){
        self.tizhengViewModel.ChoosedSearchStatus = downListModel.value
    }
    
}


