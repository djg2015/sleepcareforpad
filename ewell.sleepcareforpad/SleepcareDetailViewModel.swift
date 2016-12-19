//
//
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/19.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class SleepcareDetailViewModel: BaseViewModel {
    
    
    override init() {
        super.init()
    }
    //属性定义
    var userCode:String=""
    
    //深睡时长
    var _deepSleepSpan:String?
    dynamic var DeepSleepSpan:String?{
        get
        {
            return self._deepSleepSpan
        }
        set(value)
        {
            self._deepSleepSpan=value
        }
    }
    
    //浅睡时长
    var _lightSleepSpan:String?
    dynamic var LightSleepSpan:String?{
        get
        {
            return self._lightSleepSpan
        }
        set(value)
        {
            self._lightSleepSpan=value
        }
    }
    
    //在床时长
    var _onbedSpan:String?
    dynamic var OnbedSpan:String?{
        get
        {
            return self._onbedSpan
        }
        set(value)
        {
            self._onbedSpan=value
        }
    }
    
    //心率呼吸---------------
    var _hr:String?
    dynamic var HR:String?{
        get
        {
            return self._hr
        }
        set(value)
        {
            self._hr=value
        }
    }
    
    var _avgHR:String?
    dynamic var AvgHR:String?{
        get
        {
            return self._avgHR
        }
        set(value)
        {
            self._avgHR=value
        }
    }
    
    var _rr:String?
    dynamic var RR:String?{
        get
        {
            return self._rr
        }
        set(value)
        {
            self._rr=value
        }
    }
    
    var _avgRR:String?
    dynamic var AvgRR:String?{
        get
        {
            return self._avgRR
        }
        set(value)
        {
            self._avgRR=value
        }
    }
    
    //离床记录---------------
    var _leaveBedTimes:String?
    dynamic var LeaveBedTimes:String?{
        get
        {
            return self._leaveBedTimes
        }
        set(value)
        {
            self._leaveBedTimes=value
        }
    }
    
    var _maxLeaveBedSpan:String?
    dynamic var MaxLeaveBedSpan:String?{
        get
        {
            return self._maxLeaveBedSpan
        }
        set(value)
        {
            self._maxLeaveBedSpan=value
        }
    }
    
    var _leaveSuggest:String?
    dynamic var LeaveSuggest:String?{
        get
        {
            return self._leaveSuggest
        }
        set(value)
        {
            self._leaveSuggest=value
        }
    }
    
    //翻身记录---------------
    var _trunTimes:String?
    dynamic var TrunTimes:String?{
        get
        {
            return self._trunTimes
        }
        set(value)
        {
            self._trunTimes=value
        }
    }
    
    var _turnOverRate:String?
    dynamic var TurnOverRate:String?{
        get
        {
            return self._turnOverRate
        }
        set(value)
        {
            self._turnOverRate=value
        }
    }
    
    var _signReports:Array<SignReport>?
    dynamic var SignReports:Array<SignReport>?{
        get
        {
            return self._signReports
        }
        set(value)
        {
            self._signReports=value
        }
    }
    
    var _sleepCareReports:Array<SleepCareReport>?
    dynamic var SleepCareReports:Array<SleepCareReport>?{
        get
        {
            return self._sleepCareReports
        }
        set(value)
        {
            self._sleepCareReports=value
        }
    }
    //自定义方法
    //加载初始数据
    func LoadData( date:String){
        try {
            ({
              var session = Session.GetSession()
                if session != nil{
                self.userCode = session!.CurUserCode
                let sleepCareBussiness = SleepCareBussiness()
                //获取查询日期对应的自然周开始日期
                let begin = self.GetStartOfWeekForDate(date)
                let end  = begin.addDays(6)
               
                
                
                var sleepCareReport:SleepCareReport = sleepCareBussiness.QuerySleepQulityDetail(self.userCode, analysDate: date)
                self.DeepSleepSpan = sleepCareReport.DeepSleepTimeSpan
                self.LightSleepSpan = sleepCareReport.LightSleepTimeSpan
                self.OnbedSpan = sleepCareReport.OnBedTimeSpan
                self.HR = sleepCareReport.HR
                self.RR = sleepCareReport.RR
                self.AvgHR = sleepCareReport.AVGHR
                self.AvgRR = sleepCareReport.AVGRR
                self.LeaveBedTimes = sleepCareReport.LeaveBedCount
                self.MaxLeaveBedSpan = sleepCareReport.MaxLeaveTimeSpan
                self.LeaveSuggest = sleepCareReport.LeaveBedSuggest
                self.TrunTimes = sleepCareReport.TurnOverTime
                self.TurnOverRate = sleepCareReport.TurnOverRate
                self.SignReports = sleepCareReport.SignReports
                
                
                
                var sleepcareList = sleepCareBussiness.GetSleepCareReportByUser(session!.CurPartCode, userCode: self.userCode, analysTimeBegin: begin.description(format: "yyyy-MM-dd"), analysTimeEnd: end.description(format: "yyyy-MM-dd"), from: 1, max: 7)
                
                if(sleepcareList.sleepCareReportList.count > 0){
                    self.SleepCareReports = Array<SleepCareReport>()
                    var curSleepCareReports = sleepcareList.sleepCareReportList
                    for i in 0...(curSleepCareReports.count - 1){
                        curSleepCareReports[i].ReportDate = self.GetChineseWeekDay(curSleepCareReports[i].ReportDate)
                        var bedSource = curSleepCareReports[i].OnBedTimeSpan
                        curSleepCareReports[i].onBedTimeSpanALL = (bedSource.split(":")[0] as NSString).doubleValue + (bedSource.split(":")[1] as NSString).doubleValue / 60
                        var sleepSource1 = (curSleepCareReports[i].DeepSleepTimeSpan.split(":")[0]  as NSString).doubleValue
                            + (curSleepCareReports[i].LightSleepTimeSpan.split(":")[0]  as NSString).doubleValue
                        var sleepsource2 = (curSleepCareReports[i].DeepSleepTimeSpan.split(":")[1]  as NSString).doubleValue
                            + (curSleepCareReports[i].LightSleepTimeSpan.split(":")[1]  as NSString).doubleValue
                        curSleepCareReports[i].SleepTimeSpanALL = sleepSource1 + sleepsource2 / 60
                    }
                    self.SleepCareReports = curSleepCareReports
                }
                }
                },
                catch: { ex in
                    //异常处理,获取不到数据，则清空页面数据信息
                    self.DeepSleepSpan = ""
                    self.LightSleepSpan = ""
                    self.OnbedSpan = ""
                    self.HR = ""
                    self.RR = ""
                    self.AvgHR = ""
                    self.AvgRR = ""
                    self.LeaveBedTimes = ""
                    self.MaxLeaveBedSpan = ""
                    self.LeaveSuggest = ""
                    self.TrunTimes = ""
                    self.TurnOverRate = ""
                    self.SignReports = Array<SignReport>()
                     self.SleepCareReports = Array<SleepCareReport>()
                    
                    handleException(ex,showDialog: true)
                 
                },
                finally: {
                    
                }
            )}
        
    }
    


//获取查询日期对应的自然周开始日期
func GetStartOfWeekForDate(date:String) -> Date{
    var curDate = Date(string: date)
    var curindexofWeek = curDate.weekday()
    var span:Int = 0
    switch curindexofWeek{
    case Weekday.Sunday:
        span = 0
    case Weekday.Monday:
        span = 1
    case Weekday.Tuesday:
        span = 2
    case Weekday.Wednesday:
        span = 3
    case Weekday.Thursday:
        span = 4
    case Weekday.Friday:
        span = 5
    case Weekday.Saturday:
        span = 6
    }
    return curDate.addDays(-1 * span)
}

func GetChineseWeekDay(date:String) -> String{
    var curDate = Date(string: date)
    var curindexofWeek = curDate.weekday()
    switch curindexofWeek{
    case Weekday.Sunday:
        return "日"
    case Weekday.Monday:
        return "一"
    case Weekday.Tuesday:
        return "二"
    case Weekday.Wednesday:
        return "三"
    case Weekday.Thursday:
        return "四"
    case Weekday.Friday:
        return "五"
    case Weekday.Saturday:
        return "六"
    }
}
}
