//
//  QueryOverallAlarmViewModel.swift
//  
//
//  Created by Qinyuan Liu on 1/13/17.
//
//

import UIKit

class QueryOverallAlarmViewModel: BaseViewModel {
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
               
                                    var alarmList:AlarmList = sleepCareBLL.GetAlarmByUser(curpartcode,loginName:loginName, userCode: "", userNameLike: self._userNameCondition, bedNumberLike: self._bedNumberCondition, schemaCode: self.SelectedAlarmTypeCode, alarmTimeBegin:self.AlarmDateBeginCondition, alarmTimeEnd: self.AlarmDateEndCondition, from: nil, max: nil)
                    
                    
                    var index:Int = 1
                    
                    for alarmInfo in alarmList.alarmInfoList
                    {
                        //放入报警列表
                        var item:QueryAlarmItem = QueryAlarmItem()
                        item.Number = index
                        item.AlarmType = alarmInfo.SchemaCode
                        item.AlarmTime = (alarmInfo.AlarmTime as NSString).substringFromIndex(5)
                        item.AlarmContent = alarmInfo.SchemaContent
                        item.AlarmCode = alarmInfo.AlarmCode
                       item.BedNumber = alarmInfo.BedNumber
                        item.UserName = alarmInfo.UserName
                        item.PartName = alarmInfo.PartName
                        
                        index++
                        self.AlarmInfoList.append(item)
                    }
                    
                    self.tableView.reloadData()
                }
                
          
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
    
  
    var _bedNumberCondition:String = ""
    dynamic var BedNumberCondition:String{
        get
        {
            return self._bedNumberCondition
        }
        set(value)
        {
            self._bedNumberCondition = value
        }
    }
    
    var _userNameCondition:String = ""
    dynamic var UserNameCondition:String{
        get
        {
            return self._userNameCondition
        }
        set(value)
        {
            self._userNameCondition = value
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
    var _alarmInfoList:Array<QueryAlarmItem> = Array<QueryAlarmItem>()
    // 报警信息列表
    dynamic var AlarmInfoList:Array<QueryAlarmItem>{
        get
        {
            return self._alarmInfoList
        }
        set(value)
        {
            self._alarmInfoList = value
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
