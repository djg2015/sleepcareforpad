//
//  SleepcareMainViewModel.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareMainViewModel:BaseViewModel,RealTimeDelegate,WaringAttentionDelegate,ReloadAlarmCountDelegate {
    //初始化
    override init() {
        super.init()
        //定时器
        self.CurTime = getCurrentTime()
        self.ChoosedSearchType = SearchType.byBedNum as String
        doTimer()
        var beds = Array<BedModel>()
        try {
            ({
                var session = Session.GetSession()
                let loginUser = session.LoginUser
                //获取title名称
                var partname = GetValueFromPlist("curPartname","sleepcare.plist")
                var mainname = GetValueFromPlist("curMainname","sleepcare.plist")
                if mainname == "" || partname == ""{
                    self.MainName = "选择场景"
                }
                else{
                    self.MainName = mainname + "—" + partname
                }
                
                //获取床位信息
                if session.CurPartCode != ""{
                    self.PartBedsSearch(session.CurPartCode, searchType: "", searchContent: "")
                }
                
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
        //实时数据处理代理设置
        var xmppMsgManager = XmppMsgManager.GetInstance()
        xmppMsgManager?._realTimeDelegate = self
        xmppMsgManager?._waringAttentionDelegate = self
        self.realTimeCaches = Dictionary<String,RealTimeReport>()
        self.setRealTimer()
        //开启警告信息
        self.wariningCaches = Array<AlarmInfo>()
        self.lock = NSLock()
        
        self.BeginWaringAttention()
    }
    
    //属性定义
    var realTimeCaches:Dictionary<String,RealTimeReport>?
    var wariningCaches:Array<AlarmInfo>!
    var lock:NSLock?
    
    var _refreshFlag:Bool = false
    dynamic var RefreshFlag:Bool{
        get
        {
            return self._refreshFlag
        }
        set(value)
        {
            self._refreshFlag=value
        }
    }
    
    //医院/养老院名称 +科室名
    var _mainName:String?
    dynamic var MainName:String?{
        get
        {
            return self._mainName
        }
        set(value)
        {
            self._mainName=value
        }
    }
    
    //当前时间
    var _curTime:String?
    dynamic var CurTime:String?{
        get
        {
            return self._curTime
        }
        set(value)
        {
            self._curTime=value
        }
    }
    
    //楼层号
    var _partCode:String?
    dynamic var PartCode:String?{
        get
        {
            return self._partCode
        }
        set(value)
        {
            self._partCode=value
        }
    }
    
    
    
    
    //床位总数
    var _bedCount:String?
    dynamic var BedCount:String?{
        get
        {
            return self._bedCount
        }
        set(value)
        {
            self._bedCount=value
        }
    }
    
    //绑定的床位总数
    var _bindBedCount:String?
    dynamic var BindBedCount:String?{
        get
        {
            return self._bindBedCount
        }
        set(value)
        {
            self._bindBedCount=value
        }
    }
    
    //查询类型
    var _searchType:String?
    dynamic var ChoosedSearchType:String?{
        get
        {
            return self._searchType
        }
        set(value)
        {
            self._searchType=value
        }
    }
    
    //查询内容
    var _searchTypeContent:String?
    dynamic var SearchTypeContent:String?{
        get
        {
            return self._searchTypeContent
        }
        set(value)
        {
            self._searchTypeContent=value
        }
    }
    
    //床位集合
    var _bedModelList:Array<BedModel> = []
    dynamic var BedModelList:Array<BedModel>{
        get
        {
            return self._bedModelList
        }
        set(value)
        {
            self._bedModelList=value
        }
    }
    
    //分页数
    var _pageCount:Int = 0
    dynamic var PageCount:Int{
        get
        {
            return self._pageCount
        }
        set(value)
        {
            self._pageCount=value
        }
    }
    
    //警告数
    var _wariningCount:Int = 0
    dynamic var WariningCount:Int{
        get
        {
            return self._wariningCount
        }
        set(value)
        {
            self._wariningCount=value
        }
    }
    
    
    //选择框
    var _checkOnBed:Bool = true
    dynamic var CheckOnBed:Bool{
        get
        {
            return self._checkOnBed
        }
        set(value)
        {
            self._checkOnBed=value
        }
    }
    var _checkLeaveBed:Bool = true
    dynamic var CheckLeaveBed:Bool{
        get
        {
            return self._checkLeaveBed
        }
        set(value)
        {
            self._checkLeaveBed=value
        }
    }
    var _checkEmptyBed:Bool = true
    dynamic var CheckEmptyBed:Bool{
        get
        {
            return self._checkEmptyBed
        }
        set(value)
        {
            self._checkEmptyBed=value
        }
    }
    var _checkOffDuty:Bool = true
    dynamic var CheckOffDuty:Bool{
        get
        {
            return self._checkOffDuty
        }
        set(value)
        {
            self._checkOffDuty=value
        }
    }
    var _checkUnnormal:Bool = true
    dynamic var CheckUnnormal:Bool{
        get
        {
            return self._checkUnnormal
        }
        set(value)
        {
            self._checkUnnormal=value
        }
    }
    
    var _onbedCount:Int=0
    dynamic var OnbedCount:Int{
        get
        {
            return self._onbedCount
        }
        set(value)
        {
            self._onbedCount=value
        }
    }
    var _leavebedCount:Int=0
    dynamic var LeavebedCount:Int{
        get
        {
            return self._leavebedCount
        }
        set(value)
        {
            self._leavebedCount=value
        }
    }
    var _emptybedCount:Int=0
    dynamic var EmptybedCount:Int{
        get
        {
            return self._emptybedCount
        }
        set(value)
        {
            self._emptybedCount=value
        }
    }
    
    
//    var _showbedViews:Array<BedModel> = Array<BedModel>()
//    dynamic var ShowBedViews:Array<BedModel>{
//        get
//        {
//            return self._showbedViews
//        }
//        set(value)
//        {
//            self._showbedViews=value
//        }
//
//    }
    
    //获取指定分页对应的床位集合
    func GetBedsOfPage(pageIndex:Int, count:NSInteger, list:Array<BedModel>, maxcount:Int) -> Array<BedModel> {
        var result = Array<BedModel>()
        for(var i = (pageIndex - 1) * count;(i < (pageIndex - 1) * count + count) && (i < maxcount); i++){
//            if(list.count <= i){
//                break
//            }
            result.append(list[i])
        }
        return result
    }
    
    //时间显示
    func doTimer(){
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFireMethod:", userInfo: nil, repeats:true);
        timer.fire()
    }
    
    func timerFireMethod(timer: NSTimer) {
        self.CurTime = getCurrentTime()
    }
    
    //实时数据显示
    func setRealTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "realtimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //实时在离床状态，呼吸和心率
    func realtimerFireMethod(timer: NSTimer) {
        if self.realTimeCaches != nil{
            for realTimeReport in self.realTimeCaches!.values{
                if(!self.BedModelList.isEmpty){
                    var bed = self.BedModelList.filter(
                        {$0.BedCode == realTimeReport.BedCode})
                    if(bed.count > 0){
                        let curBed:BedModel = bed[0]
                        
                        curBed.HR = realTimeReport.HR
                        curBed.RR = realTimeReport.RR
                        curBed.UserName = realTimeReport.UserName
                        curBed.UserCode = realTimeReport.UserCode
                        curBed.BedNumber = realTimeReport.BedNumber
                        
                        var refreshFlag:Bool = false
                        
                        if(realTimeReport.OnBedStatus == "在床"){
                            if curBed.BedStatus != BedStatusType.onbed{
                                refreshFlag = true
                                
                                self.OnbedCount++
                                if curBed.BedStatus == BedStatusType.leavebed{
                                    self.LeavebedCount--
                                }
                                else if curBed.BedStatus == BedStatusType.emptybed{
                                    self.EmptybedCount--
                                }
                            }
                            curBed.BedStatus = BedStatusType.onbed
                        }
                        else if(realTimeReport.OnBedStatus == "离床"){
                            
                             //curBed.HiddenValue = true
                            if curBed.BedStatus != BedStatusType.leavebed{
                                refreshFlag = true
                                self.LeavebedCount++

                                if curBed.BedStatus == BedStatusType.onbed{
                                    self.OnbedCount--
                                }
                                else if curBed.BedStatus == BedStatusType.emptybed{
                                    self.EmptybedCount--
                                }
                            }
                            curBed.BedStatus = BedStatusType.leavebed
                        }
                        else if(realTimeReport.OnBedStatus == "空床"){
                            if curBed.BedStatus != BedStatusType.emptybed{
                                refreshFlag = true
                                
                                self.EmptybedCount++
                                if curBed.BedStatus == BedStatusType.leavebed{
                                    self.LeavebedCount--
                                }
                                else if curBed.BedStatus == BedStatusType.onbed{
                                    self.OnbedCount--
                                }
                            }
                            curBed.BedStatus = BedStatusType.emptybed
                        }
                        else if(realTimeReport.OnBedStatus == "异常"){
                            if curBed.BedStatus != BedStatusType.unnormal{
                                refreshFlag = true
                            }
                            
                            if curBed.BedStatus == BedStatusType.leavebed{
                            self.LeavebedCount--
                            }
                            else if curBed.BedStatus == BedStatusType.onbed{
                                self.OnbedCount--
                            }
                            else if curBed.BedStatus == BedStatusType.emptybed{
                                self.EmptybedCount--
                            }
                            
                            curBed.BedStatus = BedStatusType.unnormal
                        }
                        else if(realTimeReport.OnBedStatus == "请假"){
                            if curBed.BedStatus != BedStatusType.offduty{
                                refreshFlag = true
                            }
                            
                            if curBed.BedStatus == BedStatusType.leavebed{
                                self.LeavebedCount--
                            }
                            else if curBed.BedStatus == BedStatusType.onbed{
                                self.OnbedCount--
                            }
                            else if curBed.BedStatus == BedStatusType.emptybed{
                                self.EmptybedCount--
                            }
                            
                            curBed.BedStatus = BedStatusType.offduty
                        }
                        
                        
                        if refreshFlag{
                        self.RefreshFlag = true
                        }
                        
                    }
                }
            }
        }
    }
    
    //开始报警提醒,刷新报警列表和报警通知
    private var IsOpen:Bool = false
    func BeginWaringAttention(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showWarining", name: "TodoListShouldRefresh", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "CloseWaringAttention", name: "WarningClose", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector:"ReConnect", name:"ReConnectInternetForPad", object: nil)
        
        self.ReloadAlarmInfo()
        
        self.IsOpen = true
        self.setWarningTimer()
    }
    
    //弹窗提示：重新连接或退出登录
    func ReConnect(){
        //弹窗提示是否重连网络
        SweetAlert(contentHeight: 300).showAlert(ShowMessage(MessageEnum.ConnectFail), subTitle:"提示", style: AlertStyle.None,buttonTitle:"退出登录",buttonColor: UIColor.colorFromRGB(0xAEDEF4),otherButtonTitle:"重新连接", otherButtonColor:UIColor.colorFromRGB(0xAEDEF4), action: self.ConnectAfterFail)
    }
    
    func ConnectAfterFail(isOtherButton: Bool){
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        if isOtherButton{
            self.CloseWaringAttention()
            xmppMsgManager?.Close()
            Session.ClearSession()
            
            let controller = LoginController(nibName:"LoginView", bundle:nil)
            self.JumpPage(controller)
        }
        else{
            var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
            let isLogin = xmppMsgManager!.RegistConnect()
            if(!isLogin){
                self.ReConnect()
            }
        }
    }
    
    // 获取未处理的报警信息，刷新todolist
    func ReloadAlarmInfo(){
        try {
            ({
                
                //获取最新在离床报警，从2016/1/1至今的所有未处理信息
                
                var sleepCareBLL = SleepCareBussiness()
                var curDateString = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
                if Session.GetSession().CurPartCode != ""{
                    var alarmList:AlarmList = sleepCareBLL.GetAlarmByUser(Session.GetSession().CurPartCode, userCode: "", userNameLike:"", bedNumberLike: "", schemaCode: ""
                        , alarmTimeBegin:"2016-01-01", alarmTimeEnd: curDateString, from: nil, max: nil)
                    
                    TodoList.sharedInstance.removeItemAll()
                    
                    for alarmItem in alarmList.alarmInfoList
                    {
                        
                        //放入todolist
                        let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmItem.UserName + alarmItem.SchemaContent, UUID: alarmItem.AlarmCode)
                        TodoList.sharedInstance.addItem(todoItem)
                        
                    }
                    self.WariningCount = TodoList.sharedInstance.allItems().count
                    TodoList.sharedInstance.SetBadgeNumber(self.WariningCount)
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
    
    
    //关闭报警提醒
    func CloseWaringAttention(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.IsOpen = false
        TodoList.sharedInstance.removeItemAll()
    }
    
    //实时报警处理线程
    func setWarningTimer(){
        var realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "warningTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    //线程获取当前养老院科室下的实时报警信息：放入todolist通知，报警数刷新
    func warningTimerFireMethod(timer: NSTimer) {
        if(self.wariningCaches.count > 0){
            let alarmInfo:AlarmInfo = self.wariningCaches[0] as AlarmInfo
            var session = Session.GetSession()
            if(session.CurPartCode == alarmInfo.PartCode){
                
                
                let todoItem = TodoItem(deadline: NSDate(timeIntervalSinceNow: 0), title: alarmInfo.UserName + alarmInfo.SchemaContent, UUID: alarmInfo.AlarmCode)
                TodoList.sharedInstance.addItem(todoItem)
                
                
                self.WariningCount = TodoList.sharedInstance.allItems().count
                //  self.WariningCount = self.WariningCount + 1
            }
            self.wariningCaches.removeAtIndex(0)
        }
    }
    
    //点击报警通知直接打开报警界面
    func showWarining() {
        let controller:QueryAlarmController!
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            controller = QueryAlarmController(nibName:"IQueryAlarmView", bundle:nil)
        }
        else{
            controller = QueryAlarmController(nibName:"QueryAlarmView", bundle:nil)
        }
        controller.alarmcountDelegate = self
        self.JumpPage(controller)
        self.WariningCount = TodoList.sharedInstance.allItems().count
        
    }
    
    //实时数据处理
    func GetRealTimeDelegate(realTimeReport:RealTimeReport){
        let key = realTimeReport.BedCode
        self.lock!.lock()
        
        if(self.realTimeCaches?.count > 0){
            var keys = self.realTimeCaches?.keys.filter({$0 == key})
            if(keys?.array.count == 0)
            {
                self.realTimeCaches?[key] = realTimeReport
            }
            else
            {
                self.realTimeCaches?.updateValue(realTimeReport, forKey: key)
            }
        }
        else{
            self.realTimeCaches?[key] = realTimeReport
        }
        self.lock!.unlock()
    }
    
    //报警数据处理
    func GetWaringAttentionDelegate(alarmList:AlarmList){
        if(self.IsOpen){
            for(var i = 0;i < alarmList.alarmInfoList.count;i++){
                self.wariningCaches.append(alarmList.alarmInfoList[i])
            }
            
        }
        
    }
    
    //按房间号或床位号搜索，参数为“”则查找全部
    func SearchByBedOrRoom(searchContent:String){
        var session = Session.GetSession()
        var searcgType = "2"
        if(self.ChoosedSearchType == SearchType.byRoomNum){
            searcgType = "1"
        }
        if session.CurPartCode != ""{
            self.PartBedsSearch(session.CurPartCode, searchType: searcgType, searchContent: searchContent)
        }
    }
    
    //房间床位查询设置
    private func PartBedsSearch(partCode:String,searchType:String,searchContent:String){
        // self.BedModelList = Array<BedModel>()
        let sleepCareBussiness = SleepCareBussiness()
        //获取医院下的床位信息
        var partInfo:PartInfo = sleepCareBussiness.GetPartInfoByPartCode(partCode, searchType: searchType, searchContent: searchContent, from: nil, max: nil)
        
        self.PartCode = partInfo.PartCode
        self.BedCount = partInfo.BedCount
        self.BindBedCount = partInfo.BindingCount
        
        
        var onbed = 0
        var leavebed = 0
        var emptybed = 0
        
        if partInfo.BedList.count > 0{
            var beds = Array<BedModel>()
            for(var i = 0;i < partInfo.BedList.count; i++) {
                var bed = BedModel()
                bed.UserName = partInfo.BedList[i].UserName
                bed.RoomNumber = partInfo.BedList[i].RoomNumber
                bed.BedCode = partInfo.BedList[i].BedCode
                bed.BedNumber = partInfo.BedList[i].BedNumber
                //若存在username，初始化状态为离线，收到实时数据后改变
                //         否则，初始化状态为emptybed
                if bed.UserName == ""{
                    bed.BedStatus = BedStatusType.emptybed
                    emptybed++
                }
                else if partInfo.BedList[i].OnBedStatus == "离床"{
                    bed.BedStatus = BedStatusType.leavebed
                    leavebed++
                }
                else if partInfo.BedList[i].OnBedStatus == "在床"{
                    bed.BedStatus = BedStatusType.onbed
                    onbed++
                }
                else if partInfo.BedList[i].OnBedStatus == "异常"{
                    bed.BedStatus = BedStatusType.unnormal
                }
                else if partInfo.BedList[i].OnBedStatus == "请假"{
                    bed.BedStatus = BedStatusType.offduty
                }
                else if partInfo.BedList[i].OnBedStatus == "空床"{
                    bed.BedStatus = BedStatusType.emptybed
                    emptybed++
                }
                else {
                    bed.BedStatus = BedStatusType.unline
                }
                
                bed.UserCode = partInfo.BedList[i].UserCode
                beds.append(bed)
            }
            self.BedModelList = beds
        }
        else{
            self.BedModelList = Array<BedModel>()
        }
        self.OnbedCount = onbed
        self.LeavebedCount = leavebed
        self.EmptybedCount = emptybed
        
    }
    
    //在报警页面查询了之后，在主页面刷新报警数
    func ReloadAlarmCount() {
        self.WariningCount = TodoList.sharedInstance.allItems().count
    }
}

struct SearchType{
    static var byBedNum = "按床位号"
    static var byRoomNum = "按房间号"
}


