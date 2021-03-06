//
//  SleepQualityPandectView.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/16.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class SleepQualityPandectView:UIView,UITableViewDelegate,UITableViewDataSource,SelectDateEndDelegate
{
    // 控件定义
    // 分析起始时间
    @IBOutlet weak var lblAnalysTimeBegin: UILabel!
    // 分析结束时间
    @IBOutlet weak var lblAnalysTimeEnd: UILabel!
    // 查询按钮
    @IBOutlet weak var btnSearch: UIButton!
    // 上一页按钮
    @IBOutlet weak var btnPreview: UIButton!
    // 下一页按钮
    @IBOutlet weak var btnNext: UIButton!
    // 当前页码
    @IBOutlet weak var lblCurrentPageIndex: UILabel!
    // 总页数
    @IBOutlet weak var lblTotalPageCount: UILabel!
    // 睡眠质量总览View
    @IBOutlet weak var viewSleepQuality: UIView!
    
    @IBOutlet weak var rightViewPad: UIView!
    @IBOutlet weak var rightViewPhone: UIView!

    @IBAction func NextForPhone(sender:AnyObject){
        self.qualityViewModel.Next()
    }
    
    @IBAction func LastForPhone(sender:AnyObject){
        self.qualityViewModel.Preview()
    }
    
    // 属性
    var qualityViewModel:SleepcareQualityPandectViewModel = SleepcareQualityPandectViewModel()
    
    let identifier = "CellIdentifier"
    var tabViewSleepQuality: UITableView!
    var screenWidth:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    
    var _previewBtnEnable:Bool = false
    // 分析结束时间
    var PreviewBtnEnable:Bool{
        get
        {
            return self._previewBtnEnable
        }
        set(value)
        {
            self._previewBtnEnable=value
            self.btnPreview.enabled = value
        }
    }
    
    var _nextBtnEnable:Bool = false
    // 分析结束时间
    var NextBtnEnable:Bool{
        get
        {
            return self._nextBtnEnable
        }
        set(value)
        {
            self._nextBtnEnable=value
            self.btnNext.enabled = value
        }
    }

    
    // 界面初始化
    func viewInit(userCode:String)
    {
        //上下页button
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            self.rightViewPad.hidden = false
            self.rightViewPhone.hidden = true
        }
        else{
        self.rightViewPad.hidden = true
            self.rightViewPhone.hidden = false
        }
        
        
        self.qualityViewModel = SleepcareQualityPandectViewModel(userCode: userCode)
        // 按钮定义
        self.btnSearch.rac_command = qualityViewModel.searchCommand
        self.btnPreview.rac_command = qualityViewModel.previewCommand
        self.btnNext.rac_command = qualityViewModel.nextCommand

        self.btnSearch.setImage(UIImage(named: "searchBtn"), forState: UIControlState.Normal)
        self.btnSearch.setImage(UIImage(named: "searchBtnChecked"), forState: UIControlState.Highlighted)
        self.btnPreview.setImage(UIImage(named:"previewBtnNormal"), forState: UIControlState.Normal)
        self.btnPreview.setImage(UIImage(named:"previewBtnDisable"), forState: UIControlState.Disabled)
        self.btnPreview.setImage(UIImage(named:"previewBtnChecked"), forState: UIControlState.Highlighted)
        self.btnNext.setImage(UIImage(named:"nextBtnNormal"), forState: UIControlState.Normal)
        self.btnNext.setImage(UIImage(named:"nextBtnDisable"), forState: UIControlState.Disabled)
        self.btnNext.setImage(UIImage(named:"nextBtnChecked"), forState: UIControlState.Highlighted)
        
        //属性绑定
        RACObserve(self.qualityViewModel, "AnalysisTimeBegin") ~> RAC(self.lblAnalysTimeBegin, "text")
        RACObserve(self.qualityViewModel, "AnalysisTimeEnd") ~> RAC(self.lblAnalysTimeEnd, "text")
        RACObserve(self.qualityViewModel, "CurrentPageIndex") ~> RAC(self.lblCurrentPageIndex, "text")
        RACObserve(self.qualityViewModel, "TotalPageCount") ~> RAC(self.lblTotalPageCount, "text")
        RACObserve(self.qualityViewModel, "PreviewBtnEnable") ~> RAC(self, "PreviewBtnEnable")
        RACObserve(self.qualityViewModel, "NextBtnEnable") ~> RAC(self, "NextBtnEnable")
        
        self.lblAnalysTimeBegin.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "initDatePicker")
        self.lblAnalysTimeBegin .addGestureRecognizer(singleTap)
        
        self.lblAnalysTimeEnd.userInteractionEnabled = true
        var singleTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "initDatePicker1")
        self.lblAnalysTimeEnd .addGestureRecognizer(singleTap1)
        
        self.lblAnalysTimeBegin.layer.borderColor = UIColor.blackColor().CGColor
        self.lblAnalysTimeBegin.layer.borderWidth = 1
        self.lblAnalysTimeEnd.layer.borderColor = UIColor.blackColor().CGColor
        self.lblAnalysTimeEnd.layer.borderWidth = 1
        
        // 初始化TableView
        self.screenWidth = 1024 - 50
        self.screenHeight = 600
        
       
        // 实例当前的睡眠质量总览tableView
        self.tabViewSleepQuality = UITableView(frame: CGRectMake(0, 0, self.screenWidth, self.screenHeight), style: UITableViewStyle.Plain)
        // 设置tableView默认的行分隔符为空
        self.tabViewSleepQuality!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabViewSleepQuality!.delegate = self
        self.tabViewSleepQuality!.dataSource = self
        self.tabViewSleepQuality!.tag = 1
        self.tabViewSleepQuality!.backgroundColor = UIColor.clearColor()
        // 注册自定义的TableCell
        //        self.tabViewSleepQuality!.registerNib(UINib(nibName: "AlarmTableViewCell", bundle:nil), forCellReuseIdentifier: identifier)
        self.viewSleepQuality.addSubview(self.tabViewSleepQuality)
        self.qualityViewModel.tableView = self.tabViewSleepQuality
    }
    
    
    // 返回Table的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section != 0)
        {
            return qualityViewModel.SleepQualityList.count
        }
        else
        {
            return 12
        }
    }
    // 返回Table的分组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 创建睡眠质量总览tableView的列头
        var headViewSleepQuality:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  100, 44))
        lblNumber.text = "序号"
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor.blackColor().CGColor
        lblNumber.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblAnalysTime = UILabel(frame: CGRectMake(100, 0, self.screenWidth - 100 - 120 * 3, 44))
        lblAnalysTime.text = "分析时段"
        lblAnalysTime.font = UIFont.boldSystemFontOfSize(18)
        lblAnalysTime.textAlignment = .Center
        lblAnalysTime.layer.borderWidth = 1
        lblAnalysTime.layer.borderColor = UIColor.blackColor().CGColor
        lblAnalysTime.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblAvgHR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 3, 0, 120, 44))
        lblAvgHR.text = "平均心率"
        lblAvgHR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgHR.textAlignment = .Center
        lblAvgHR.layer.borderWidth = 1
        lblAvgHR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgHR.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblAvgRR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 2, 0, 120, 44))
        lblAvgRR.text = "平均呼吸"
        lblAvgRR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgRR.textAlignment = .Center
        lblAvgRR.layer.borderWidth = 1
        lblAvgRR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgRR.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        
        var lblTurnOverTimes = UILabel(frame: CGRectMake(self.screenWidth - 120, 0, 120, 44))
        lblTurnOverTimes.text = "翻身次数"
        lblTurnOverTimes.font = UIFont.boldSystemFontOfSize(18)
        lblTurnOverTimes.textAlignment = .Center
        lblTurnOverTimes.layer.borderWidth = 1
        lblTurnOverTimes.layer.borderColor = UIColor.blackColor().CGColor
        lblTurnOverTimes.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        headViewSleepQuality.addSubview(lblNumber)
        headViewSleepQuality.addSubview(lblAnalysTime)
        headViewSleepQuality.addSubview(lblAvgHR)
        headViewSleepQuality.addSubview(lblAvgRR)
        headViewSleepQuality.addSubview(lblTurnOverTimes)
        return headViewSleepQuality
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        
        cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        cell?.userInteractionEnabled = false
        
        var lblNumber = UILabel(frame: CGRectMake(0, 0,  100, 44))
        lblNumber.font = UIFont.boldSystemFontOfSize(18)
        lblNumber.textAlignment = .Center
        lblNumber.layer.borderWidth = 1
        lblNumber.layer.borderColor = UIColor.blackColor().CGColor
        lblNumber.backgroundColor = UIColor.whiteColor()
        
        var lblAnalysTime = UILabel(frame: CGRectMake(100, 0, self.screenWidth - 100 - 120 * 3, 44))
        lblAnalysTime.font = UIFont.boldSystemFontOfSize(18)
        lblAnalysTime.textAlignment = .Center
        lblAnalysTime.layer.borderWidth = 1
        lblAnalysTime.layer.borderColor = UIColor.blackColor().CGColor
        lblAnalysTime.backgroundColor = UIColor.whiteColor()
        
        var lblAvgHR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 3, 0, 120, 44))
        lblAvgHR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgHR.textAlignment = .Center
        lblAvgHR.layer.borderWidth = 1
        lblAvgHR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgHR.backgroundColor = UIColor.whiteColor()
        
        var lblAvgRR = UILabel(frame: CGRectMake(self.screenWidth - 120 * 2, 0, 120, 44))
        lblAvgRR.font = UIFont.boldSystemFontOfSize(18)
        lblAvgRR.textAlignment = .Center
        lblAvgRR.layer.borderWidth = 1
        lblAvgRR.layer.borderColor = UIColor.blackColor().CGColor
        lblAvgRR.backgroundColor = UIColor.whiteColor()
        
        var lblTurnOverTimes = UILabel(frame: CGRectMake(self.screenWidth - 120, 0, 120, 44))
        lblTurnOverTimes.font = UIFont.boldSystemFontOfSize(18)
        lblTurnOverTimes.textAlignment = .Center
        lblTurnOverTimes.layer.borderWidth = 1
        lblTurnOverTimes.layer.borderColor = UIColor.blackColor().CGColor
        lblTurnOverTimes.backgroundColor = UIColor.whiteColor()
        
        if(self.qualityViewModel.SleepQualityList.count > indexPath.row)
        {
            lblNumber.text = String(self.qualityViewModel.SleepQualityList[indexPath.row].Number)
            lblAnalysTime.text = self.qualityViewModel.SleepQualityList[indexPath.row].AnalysisTimeSpan
            lblAvgHR.text = self.qualityViewModel.SleepQualityList[indexPath.row].AvgHR
            lblAvgRR.text = self.qualityViewModel.SleepQualityList[indexPath.row].AvgRR
            lblTurnOverTimes.text = self.qualityViewModel.SleepQualityList[indexPath.row].TurnTimes
        }
        
        
        cell?.addSubview(lblNumber)
        cell?.addSubview(lblAnalysTime)
        cell?.addSubview(lblAvgHR)
        cell?.addSubview(lblAvgRR)
        cell?.addSubview(lblTurnOverTimes)
        
        return cell!
    }
    
    func initDatePicker()
    {
        self.initDatePicker(1)
    }
    
    func initDatePicker1()
    {
        self.initDatePicker(2)
    }

    
    func initDatePicker(timeTag:Int)
    {
       
        var devicebounds:CGRect = self.frame
       if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
        devicebounds = UIScreen.mainScreen().bounds
        }
        //设置日期弹出窗口
        var alertview:DatePickerView = DatePickerView(frame:devicebounds)
        alertview.detegate = self
        alertview.tag = timeTag
        self.addSubview(alertview)
    }
    
    func SelectDateEnd(sender:UIView,dateString:String)
    {
        if(sender.tag == 1)
        {
            self.qualityViewModel.AnalysisTimeBegin = dateString
        }
        else
        {
            self.qualityViewModel.AnalysisTimeEnd = dateString
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
   }
