//
//  QueryOverallAlarmViewController.swift
//  
//
//  Created by Qinyuan Liu on 1/13/17.
//
//

import UIKit

class QueryOverallAlarmViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,SelectDateEndDelegate{

    // 查询按钮
    @IBOutlet weak var btnQuery: UIButton!
    // 报警类型
    @IBOutlet weak var btnPopDown: UIImageView!
    // 报警类型查询条件
    @IBOutlet weak var txtAlarmType: UITextField!
    
    @IBOutlet weak var txtUserNameLike: UITextField!
    
     @IBOutlet weak var txtBedNumberLike: UITextField!
    // 报警日期起始日期
    @IBOutlet weak var lblAlarmDateBegin: UILabel!
    // 报警日期结束日期
    @IBOutlet weak var lblAlarmDateEnd: UILabel!
    // 报警信息View
    @IBOutlet weak var viewAlarm: UIView!
    // 报警类型
    var popDownListAlarmType:PopDownList!
    
    // 界面模板
    var _queryOverallAlarmViewModel:QueryOverallAlarmViewModel = QueryOverallAlarmViewModel()
    // 屏幕宽高
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    let identifier = "AlarmCellIdentifier"
    var tabViewAlarm: UITableView!

    override func viewWillAppear(animated: Bool) {
        self._queryOverallAlarmViewModel.SearchAlarm()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 设置查询按钮的样式
        self.btnQuery.setImage(UIImage(named: "searchBtn"), forState: UIControlState.Normal)
        self.btnQuery.setImage(UIImage(named: "searchBtnChecked"), forState: UIControlState.Highlighted)
        // 设置下拉
        self.btnPopDown.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "popDownTouch")
        self.btnPopDown .addGestureRecognizer(singleTap)
        self.popDownListAlarmType = PopDownList(datasource: self._queryOverallAlarmViewModel.AlarmTypeList, dismissHandler: self.ChoosedAlarmTypeItem)
        
        // 设置报警日期起始/结束时间控件属性
        self.lblAlarmDateBegin.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DatePickerBegin")
        self.lblAlarmDateBegin .addGestureRecognizer(singleTap1)
        
        self.lblAlarmDateEnd.userInteractionEnabled = true
        var singleTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DatePickerEnd")
        self.lblAlarmDateEnd .addGestureRecognizer(singleTap2)
        
        
        // 加载数据的tableView
        self.screenWidth = self.viewAlarm.frame.size.width
        self.screenHeight = self.viewAlarm.frame.size.height
        
        // 实例当前的报警tableView
        self.tabViewAlarm = UITableView(frame: CGRectMake(0, 0, self.screenWidth, self.screenHeight), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewAlarm.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewAlarm.delegate = self
        self.tabViewAlarm.dataSource = self
        self.tabViewAlarm!.tag = 1
        self._queryOverallAlarmViewModel.tableView = self.tabViewAlarm
        self.viewAlarm.addSubview(self.tabViewAlarm)
        
       
        
        self.rac_setting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //属性绑定
    func rac_setting(){
       
        RACObserve(self._queryOverallAlarmViewModel, "SelectedAlarmType") ~> RAC(self.txtAlarmType, "text")
        RACObserve(self._queryOverallAlarmViewModel, "AlarmDateBeginCondition") ~> RAC(self.lblAlarmDateBegin, "text")
        RACObserve(self._queryOverallAlarmViewModel, "AlarmDateEndCondition") ~> RAC(self.lblAlarmDateEnd, "text")
        
      
        self.txtUserNameLike.rac_textSignal() ~> RAC(self._queryOverallAlarmViewModel, "UserNameCondition")
        self.txtBedNumberLike.rac_textSignal() ~> RAC(self._queryOverallAlarmViewModel, "BedNumberCondition")
        RACObserve(self._queryOverallAlarmViewModel, "UserNameCondition") ~> RAC(self.txtUserNameLike, "text")
        RACObserve(self._queryOverallAlarmViewModel, "BedNumberCondition") ~> RAC(self.txtBedNumberLike, "text")
        //事件绑定
        self.btnQuery.rac_command = _queryOverallAlarmViewModel.searchAlarm
    }
    
    // 弹出报警类型选择
    func popDownTouch()
    {
        self.popDownListAlarmType.Show(160, uiElement: self.btnPopDown)
    }
    
    func ChoosedAlarmTypeItem(downListModel:DownListModel){
        self._queryOverallAlarmViewModel.SelectedAlarmType = downListModel.value
        self._queryOverallAlarmViewModel.SelectedAlarmTypeCode = downListModel.key
    }
    
    
    
    var alertviewBegin:DatePickerView!
    var alertviewEnd:DatePickerView!
    
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
            self._queryOverallAlarmViewModel.AlarmDateBeginCondition = dateString
        }
        else
        {
            self._queryOverallAlarmViewModel.AlarmDateEndCondition = dateString
        }
    }
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _queryOverallAlarmViewModel.AlarmInfoList.count
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //选中某行操作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 创建睡眠质量总览tableView的列头
        var headViewAlarmInfo:UIView = UIView(frame: CGRectMake(0, 0, self.screenWidth, 44))
        
        var lblNumber = TableLabel(frame: CGRectMake(0, 0,  40, 44))
        lblNumber.text = "序号"
        var lblAlarmTime = TableLabel(frame: CGRectMake(40, 0, 160, 44))
        lblAlarmTime.text = "报警时间"
        var lblAlarmType = TableLabel(frame: CGRectMake(200, 0, 90, 44))
        lblAlarmType.text = "报警类型"
        var lblAlarmContent =  TableLabel(frame: CGRectMake(290, 0, self.screenWidth - 670, 44))
        lblAlarmContent.text = "报警内容"
        var lblBedNUmber = TableLabel(frame: CGRectMake(self.screenWidth - 390, 0, 80, 44))
        lblBedNUmber.text = "床位号"
        var lblPartName  = TableLabel(frame: CGRectMake(self.screenWidth - 310, 0, 160, 44))
        lblPartName.text = "科室"
        var lblOperate = TableLabel(frame: CGRectMake(self.screenWidth - 150, 0, 150, 44))
        lblOperate.text = "操作"
        
        headViewAlarmInfo.addSubview(lblNumber)
        headViewAlarmInfo.addSubview(lblAlarmTime)
        headViewAlarmInfo.addSubview(lblAlarmType)
        headViewAlarmInfo.addSubview(lblAlarmContent)
        headViewAlarmInfo.addSubview(lblBedNUmber)
        headViewAlarmInfo.addSubview(lblPartName)
        headViewAlarmInfo.addSubview(lblOperate)
        
        return headViewAlarmInfo
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        
        
        var lblNumber = TableDataLabel(frame: CGRectMake(0, 0,  40, 44))
        var lblAlarmTime = TableDataLabel(frame: CGRectMake(40, 0, 160, 44))
        var lblAlarmType = TableDataLabel(frame: CGRectMake(200, 0, 90, 44))
        var lblAlarmContent = TableDataLabel(frame: CGRectMake(290, 0, self.screenWidth - 680, 44))
        var lblBedNumber = TableDataLabel(frame: CGRectMake(self.screenWidth - 390, 0, 80, 44))
        var lblPartName = TableDataLabel(frame: CGRectMake(self.screenWidth - 310, 0, 160, 44))
        
        var lblOperate:UIView = UIView(frame:CGRectMake(self.screenWidth - 150, 0, 150, 44))
        lblOperate.layer.borderWidth = 1
        lblOperate.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        var btnHandle:UIButton = UIButton(frame:CGRectMake(10, 7, 45, 30))
        btnHandle.setTitle("处理", forState: .Normal)
        btnHandle.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnHandle.userInteractionEnabled = true
        lblOperate.addSubview(btnHandle)
        var btnErrorHandle:UIButton = UIButton(frame:CGRectMake(70, 7, 70, 30))
        btnErrorHandle.setTitle("误报警", forState: .Normal)
        btnErrorHandle.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btnErrorHandle.userInteractionEnabled = true
        lblOperate.addSubview(btnErrorHandle)
        
        
        if(self._queryOverallAlarmViewModel.AlarmInfoList.count > indexPath.row)
        {
            lblNumber.text = String(self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].Number)
            lblAlarmTime.text = self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].AlarmTime
            lblAlarmType.text = self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].AlarmType
            lblAlarmContent.text = self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].AlarmContent
            lblBedNumber.text = self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].BedNumber
            lblPartName.text = self._queryOverallAlarmViewModel.AlarmInfoList[indexPath.row].PartName
            
            btnHandle.addTarget(self, action: "OpenHandle:", forControlEvents: UIControlEvents.TouchUpInside)
            btnHandle.tag = indexPath.row
            btnErrorHandle.addTarget(self, action: "OpenErrorHandle:", forControlEvents: UIControlEvents.TouchUpInside)
            btnErrorHandle.tag = indexPath.row
            
        }
        
        
        cell?.addSubview(lblNumber)
        cell?.addSubview(lblBedNumber)
        cell?.addSubview(lblPartName)
        cell?.addSubview(lblAlarmType)
        cell?.addSubview(lblAlarmTime)
        cell?.addSubview(lblAlarmContent)
        cell?.addSubview(lblOperate)
        
        
        return cell!
    }

    func OpenHandle(sender:UIButton){
        // self.selectAlarmCode = self._queryAlarmViewModel.AlarmInfoList[sender.tag!].AlarmCode
        print(sender.tag)
    }
    func OpenErrorHandle(sender:UIButton){
        print(sender.tag)
    }
}
