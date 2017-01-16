//
//  QueryAlarmViewMode.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/30.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
import UIKit

class QueryAlarmViewModel:BaseViewModel
{
    var searchAlarm: RACCommand?
    var tableView:UITableView = UITableView()
    
    override init()
    {
        super.init()
        
        // 初始化时间
        self.AlarmDateBeginCondition = Date.today().addDays(-10).description(format: "yyyy-MM-dd")
        self.AlarmDateEndCondition = Date.today().description(format: "yyyy-MM-dd")
        
        self.searchAlarm = RACCommand(){
            
            (any:AnyObject!) -> RACSignal in
            return self.SearchAlarm()
        }
    }
    
   
    func SearchAlarm() -> RACSignal{
        try {
            ({
               
                let session = Session.GetSession()
                if session != nil{
                //清空报警列表
                self.AlarmInfoList.removeAll(keepCapacity: true)
                //获取最新在离床报警
                let sleepCareBLL = SleepCareBussiness()
                let curpartcode = session!.CurPartCode
                let loginName = session!.LoginUser!.LoginName
                let usercode = session!.CurUserCode
                    
                    var historyAlarmlist:HistoryAlarmList = sleepCareBLL.GetPartUsersAlarmList(self.AlarmDateBeginCondition, analysisDateEnd: self.AlarmDateEndCondition, userCode: usercode, selectAlarmType: self._selectedAlarmStatusCode, selectTransferType: self._selectedAlarmTypeCode)
               
                    
                var index:Int = 1
                for alarmItem in historyAlarmlist.alarmItemList
                {
                    //放入报警列表
                    var item:QueryHistoryAlarmItem = QueryHistoryAlarmItem()
                    item.Number = index
                    item.AlarmType = alarmItem.AlarmType
                    item.AlarmTime = (alarmItem.AlarmTime as NSString).substringFromIndex(5)
                    item.AlarmContent = alarmItem.Content
                    item.AlarmCode = alarmItem.AlarmCode
                    item.HandleTime = alarmItem.HandleTime
                    item.HandleStatus = alarmItem.HandleStatus
                    
                    index++
                    self.AlarmInfoList.append(item) 
                }
                
               self.tableView.reloadData()
               }
                
                //testdata
//                                    var item:QueryHistoryAlarmItem = QueryHistoryAlarmItem()
//                
//                                    item.Number = 1
//                                    item.AlarmType = "离床报警"
//                                    item.AlarmTime = "2011-01-01 19:10:10"
//                                    item.AlarmContent = "离床超过30分钟"
//                                    item.AlarmCode = "0000001"
//                item.HandleStatus = "未处理"
//                item.HandleTime = "2011-01-01 19:10:10"
//                                    self.AlarmInfoList.append(item)
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        return RACSignal.empty()
    }
    
        
    
    var _alarmDateBeginCondition:String = ""
    // 报警日期起始查询条件
    dynamic var AlarmDateBeginCondition:String{
        get
        {
            return self._alarmDateBeginCondition
        }
        set(value)
        {
            self._alarmDateBeginCondition = value
        }
    }
    
    var _alarmDateEndCondition:String = ""
    // 报警日期结束查询条件
    dynamic var AlarmDateEndCondition:String{
        get
        {
            return self._alarmDateEndCondition
        }
        set(value)
        {
            self._alarmDateEndCondition = value
        }
    }
    
    var _selectedAlarmStatus:String = "全部"
    // 选择的报警状态
    dynamic var SelectedAlarmStatus:String{
        get
        {
            return self._selectedAlarmStatus
        }
        set(value)
        {
            self._selectedAlarmStatus = value
        }
    }
    
    var _selectedAlarmStatusCode:String = ""
    // 选择的报警状态
    dynamic var SelectedAlarmStatusCode:String{
        get
        {
            return self._selectedAlarmStatusCode
        }
        set(value)
        {
            self._selectedAlarmStatusCode = value
        }
    }
    
    var _selectedAlarmType:String = "全部"
    // 选择的报警类型编号
    dynamic var SelectedAlarmType:String{
        get
        {
            return self._selectedAlarmType
        }
        set(value)
        {
            self._selectedAlarmType = value
        }
    }
    
    var _selectedAlarmTypeCode:String = ""
    // 选择的报警类型编号
    dynamic var SelectedAlarmTypeCode:String{
        get
        {
            return self._selectedAlarmTypeCode
        }
        set(value)
        {
            self._selectedAlarmTypeCode = value
        }
    }

    
    // 属性定义
    var _alarmInfoList:Array<QueryHistoryAlarmItem> = Array<QueryHistoryAlarmItem>()
    // 报警信息列表
    dynamic var AlarmInfoList:Array<QueryHistoryAlarmItem>{
        get
        {
            return self._alarmInfoList
        }
        set(value)
        {
            self._alarmInfoList = value
        }
    }
    
    var _alarmStatusList:Array<DownListModel> = Array<DownListModel>()
    dynamic var AlarmStatusList:Array<DownListModel>{
        get
        {
            var item:DownListModel = DownListModel()
            item.key = ""
            item.value = "全部"
            _alarmStatusList.append(item)
            
            item = DownListModel()
            item.key = "1"
            item.value = "未处理"
            _alarmStatusList.append(item)

            
            item = DownListModel()
            item.key = "2"
            item.value = "已处理"
            _alarmStatusList.append(item)
            
           
            
            item = DownListModel()
            item.key = "3"
            item.value = "误报警"
            _alarmStatusList.append(item)
            
            
            
            return _alarmStatusList
        }
    }
            
    var _alarmTypeList:Array<DownListModel> = Array<DownListModel>()
    dynamic var AlarmTypeList:Array<DownListModel>{
        get
        {
            var item:DownListModel = DownListModel()
            item.key = ""
            item.value = "全部"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_TEMPERATURE"
            item.value = "体温报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_HEARTBEAT"
            item.value = "心率报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BREATH"
            item.value = "呼吸报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BEDSTATUS"
            item.value = "在离床报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_FALLINGOUTOFBED"
            item.value = "坠床风险报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_BEDSORE"
            item.value = "褥疮风险报警"
            _alarmTypeList.append(item)
            
            item = DownListModel()
            item.key = "ALM_CALL"
            item.value = "呼叫报警"
            _alarmTypeList.append(item)
            
            return _alarmTypeList
        }
    }
}

class QueryHistoryAlarmItem
{
    //属性定义
    var _number:Int = 0
    // 序号
    dynamic var Number:Int{
        get
        {
            return self._number
        }
        set(value)
        {
            self._number=value
        }
    }
    
    var _alarmCode:String = ""
    // 报警编号
    dynamic var AlarmCode:String{
        get
        {
            return self._alarmCode
        }
        set(value)
        {
            self._alarmCode = value
        }
    }
    
    var _alarmType:String = ""
    // 报警类型
    dynamic var AlarmType:String{
        get
        {
            return self._alarmType
        }
        set(value)
        {
            self._alarmType = value
        }
    }
    
    var _alarmTime:String = ""
    // 报警时间
    dynamic var AlarmTime:String{
        get
        {
            return self._alarmTime
        }
        set(value)
        {
            self._alarmTime = value
        }
    }
    
    var _alarmContent:String = ""
    // 报警内容
    dynamic var AlarmContent:String{
        get
        {
            return self._alarmContent
        }
        set(value)
        {
            self._alarmContent = value
        }
    }
    
    var _handleTime:String = ""
    dynamic var HandleTime:String{
        get
        {
            return self._handleTime
        }
        set(value)
        {
            self._handleTime = value
        }
    }
    
    var _handleStatus:String = ""
    dynamic var HandleStatus:String{
        get
        {
            return self._handleStatus
        }
        set(value)
        {
            self._handleStatus = value
        }
    }
   }
