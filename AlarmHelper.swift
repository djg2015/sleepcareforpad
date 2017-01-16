//
//  IAlarmHelper.swift
//  ewell.sleepcareforpad
//
//  Created by Qinyuan Liu on 12/17/15.
//  Copyright (c) 2015 djg. All rights reserved.
//
import Foundation
import ObjectiveC
import AudioToolbox

class AlarmHelper:NSObject, WaringAttentionDelegate {
    
    private static var alarmInstance: AlarmHelper? = nil
    private var _wariningCaches:Array<AlarmInfo>!
    var setalarmlabelDelegate:SetAlarmWarningLabelDelegate!
    private var IsOpen:Bool = false
    //-------------------类字段--------------------------
    //未处理报警总数
//    var _warningcouts:Int = 0
//    dynamic var Warningcouts:Int{
//        get
//        {
//            return self._warningcouts
//        }
//        set(value)
//        {
//            self._warningcouts = value
//        }
//    }
    
    //所有未处理报警code
    var _codes:Array<String> = Array<String>()
    dynamic var Codes:Array<String>{
        get
        {
            return self._codes
        }
        set(value)
        {
            self._codes = value
        }
    }
    
    //未处理报警列表
    var _warningList:Array<QueryAlarmItem>=Array<QueryAlarmItem>()
    dynamic var WarningList:Array<QueryAlarmItem>{
        get
        {
            return self._warningList
        }
        set(value)
        {
            self._warningList = value
        }
    }
    
    private override init(){
        
    }
    
    class func GetAlarmInstance()->AlarmHelper{
        if self.alarmInstance == nil {
            self.alarmInstance = AlarmHelper()
            //实时数据处理代理设置
            var xmppMsgManager = XmppMsgManager.GetInstance()
            xmppMsgManager?._waringAttentionDelegate = self.alarmInstance
            //开启警告信息
            self.alarmInstance!._wariningCaches = Array<AlarmInfo>()
            
            
        }
        return self.alarmInstance!
    }
    
    //------------------------------------开始／结束报警器-------------------------------------
    //开始报警提醒
    func BeginWaringAttention(){

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        
        //        //清除已经overdue的todoitem
        //        for item in TodoList.sharedInstance.allItems(){
        //            if item.isOverdue {
        //                TodoList.sharedInstance.removeItemByID(item.UUID)
        //            }
        //        }
        
        
        self.IsOpen = true
        //初始化，加入上次退出app时未处理的报警信息到warningList／codes
        self.ReloadUnhandledWarning()
        
        //初始化定时器,获取实时报警
        self.setAlarmTimer()
        
    }
    
    //关闭报警提醒
    func CloseWaringAttention(){
        TodoList.sharedInstance.removeItemAll()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        self.Codes.removeAll()
        self.WarningList.removeAll()
        TodoList.sharedInstance.SetBadgeNumber(0)
        
    }
    
    
    //-----------------------------刷新报警列表，todolist-------------------------------
    //加入未处理的报警信息到warningList／codes/unreadcodes
    func ReloadUnhandledWarning(){
        try {
            ({
                var session = Session.GetSession()
                if (session != nil && session!.CurPartCode != ""){
                    var curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
                    //获取报警信息
                    var alarmList:AlarmList = SleepCareBussiness().GetAlarmByUser(session!.CurPartCode,loginName: session!.LoginUser!.LoginName, userCode: "", userNameLike: "", bedNumberLike: "", schemaCode: "", alarmTimeBegin:"2016-01-01", alarmTimeEnd: curDateString, from: nil, max: nil)
                    
                    var index:Int = 0
                    self.WarningList = Array<QueryAlarmItem>()
                    self.Codes = Array<String>()
                    TodoList.sharedInstance.removeItemAll()
                    
                    
                    for alarmItem in alarmList.alarmInfoList
                    {
                        //放入报警列表
                        var item:QueryAlarmItem = QueryAlarmItem()
                       
                        item.Number = index
                        item.AlarmType = alarmItem.SchemaCode
                        item.AlarmTime = (alarmItem.AlarmTime as NSString).substringFromIndex(5)
                        item.AlarmContent = alarmItem.SchemaContent
                        item.AlarmCode = alarmItem.AlarmCode
                        index++
                        self.WarningList.append(item)
                        //放入todolist
                        let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmItem.UserName + alarmItem.SchemaContent, UUID: alarmItem.AlarmCode)
                        TodoList.sharedInstance.addItem(todoItem)
                        //放入codes
                        self.Codes.append(alarmItem.AlarmCode)
                    }
               //     self.Warningcouts = self.WarningList.count
                    //外部图标上的badge number
                    TodoList.sharedInstance.SetBadgeNumber(self.WarningList.count)
                    
                    
                    if self.WarningList.count > 0{
                        self.AlertSound()
                        
                    }
                    
                    if self.setalarmlabelDelegate != nil{
                        self.setalarmlabelDelegate.SetAlarmWarningLabel(self.WarningList.count)
                    }
                }
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        
    }
    
    //有新报警的提示音：静音则震动提醒
    func AlertSound(){
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 1304
        //                        //获取声音地址
        //                        let path = NSBundle.mainBundle().pathForResource("msg", ofType: "wav")
        //                        //地址转换
        //                        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        //  AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //播放声音
        AudioServicesPlayAlertSound(soundID)
        
    }
    
    //-----------------------成功处理报警后，同步删除此报警在warninglist，codes，todolist中的记录---
    func DeleteAlarmInfoByCode(code:String){
        for (var i = 0; i<self.WarningList.count; i++){
            if self.WarningList[i].AlarmCode == code{
            self.WarningList.removeAtIndex(i)
                return
            }
        }
        for (var i = 0; i<self.Codes.count; i++){
            if self.Codes[i] == code{
                self.Codes.removeAtIndex(i)
                return
            }
        }
        TodoList.sharedInstance.removeItemByID(code)
     //   self.Warningcouts = self.WarningList.count
        if self.setalarmlabelDelegate != nil{
            self.setalarmlabelDelegate.SetAlarmWarningLabel(self.WarningList.count)
        }
    }
    
    
    
    //--------------------------------------定时器--------------------------------------------
    
    
    //实时报警处理线程
    func setAlarmTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "alarmTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程处理报警信息，赋值给todolist
    func alarmTimerFireMethod(timer: NSTimer) {
        if(self._wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self._wariningCaches[0] as AlarmInfo
            var session = Session.GetSession()
            
            if(session != nil && session!.CurPartCode == alarmInfo.PartCode){
                //检查alarmcode是否已存在
                if !self.IsCodeExist(alarmInfo.AlarmCode){
                    let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
                    var item:QueryAlarmItem = QueryAlarmItem()
                   
                    item.Number = self.WarningList.count
                    item.AlarmType = alarmInfo.SchemaCode
                    item.AlarmTime = (alarmInfo.AlarmTime as NSString).substringFromIndex(5)
                    item.AlarmContent = alarmInfo.SchemaContent
                    item.AlarmCode = alarmInfo.AlarmCode
                    
                    //往todolist／warninglist/codes里加
                    self.WarningList.append(item)
                 //   self.Warningcouts = self.WarningList.count
                    if !self.IsCodeExist(item.AlarmCode){
                        self.Codes.append(item.AlarmCode)
                    }
                    
                    TodoList.sharedInstance.addItem(todoItem)
                }
                
                if self.setalarmlabelDelegate != nil{
                    self.setalarmlabelDelegate.SetAlarmWarningLabel(self.WarningList.count)
                }
                
                self._wariningCaches.removeAtIndex(0)
                
                self.AlertSound()
            }
        }
        
    }
    
    
    
    
    //----------------------------------报警delegate-------------------------------------
    //获取原始报警数据warningcaches,通过bedcode过滤为需要的报警信息
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                //已处理，检查alarmcode是否在本地的codes，是则删掉这条报警
                //0:未处理;1:已处理,默认“”
                if alarmList.alarmInfoList[i].HandleFlag == "1"{
                    let code = alarmList.alarmInfoList[i].AlarmCode
                    if self.IsCodeExist(code){
                        var tempwarningList = self.WarningList
                        var codes = self.Codes
                        TodoList.sharedInstance.removeItemByID(code)
                        for(var i = 0; i < tempwarningList.count; i++){
                            if code == tempwarningList[i].AlarmCode{
                                tempwarningList.removeAtIndex(i)
                                self.WarningList = tempwarningList
                                break
                            }
                        }
                        for (var i = 0; i < codes.count; i++){
                            if code == codes[i]{
                                codes.removeAtIndex(i)
                                self.Codes = codes
                                break
                            }
                        }
                    }
                }
                    //新的报警信息，需加入到cashe
               // else if alarmList.alarmInfoList[i].HandleFlag == "0"{
                else{
                    self._wariningCaches.append(alarmList.alarmInfoList[i])
                }
            }//for
            if self.setalarmlabelDelegate != nil{
                self.setalarmlabelDelegate.SetAlarmWarningLabel(self.WarningList.count)
            }
        }
    }
    
    
    func IsCodeExist(code:String)->Bool{
        if !self._codes.isEmpty{
            for cc in self._codes{
                if code == cc{
                    return true
                }
            }
        }
        return false
    }
    
}

protocol SetAlarmWarningLabelDelegate{
    
    func SetAlarmWarningLabel(count:Int)
}


class QueryAlarmItem
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
    
    var _bedNumber:String = ""
    dynamic var BedNumber:String{
        get
        {
            return self._bedNumber
        }
        set(value)
        {
            self._bedNumber = value
        }
    }
    
    var _userName:String = ""
    dynamic var UserName:String{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName = value
        }
    }
    
    var _partName:String = ""
    dynamic var PartName:String{
        get
        {
            return self._partName
        }
        set(value)
        {
            self._partName = value
        }
    }
}

