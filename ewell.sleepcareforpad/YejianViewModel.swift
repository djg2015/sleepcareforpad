//
//  YejianViewModel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class YejianViewModel: BaseViewModel {
   
    var _hrrrRange:HRRRChart=HRRRChart()
    dynamic var HRRRRange:HRRRChart{
        get
        {
            return self._hrrrRange
        }
        set(value)
        {
            self._hrrrRange=value
        }
    }
    
    
    var _leaveBedRange:LeaveBedChart = LeaveBedChart()
    dynamic var LeaveBedRange:LeaveBedChart{
        get
        {
            return self._leaveBedRange
        }
        set(value)
        {
            self._leaveBedRange=value
        }
    }
    
    
    
    //平均翻身
    var _avgturnover:String=""
    dynamic var Avgturnover:String{
        get
        {
            return self._avgturnover
        }
        set(value)
        {
            self._avgturnover=value
        }
    }
    var _avgturnover2:String=""
    dynamic var Avgturnover2:String{
        get
        {
            return self._avgturnover2
        }
        set(value)
        {
            self._avgturnover2=value
        }
    }

    //平均心率
    var _avghr:String=""
    dynamic var Avghr:String{
        get
        {
            return self._avghr
        }
        set(value)
        {
            self._avghr=value
        }
    }
    var _avghr2:String=""
    dynamic var Avghr2:String{
        get
        {
            return self._avghr2
        }
        set(value)
        {
            self._avghr2=value
        }
    }
    //平均呼吸
    var _avgrr:String=""
    dynamic var Avgrr:String{
        get
        {
            return self._avgrr
        }
        set(value)
        {
            self._avgrr=value
        }
    }
    var _avgrr2:String=""
    dynamic var Avgrr2:String{
        get
        {
            return self._avgrr2
        }
        set(value)
        {
            self._avgrr2=value
        }
    }
    
    //平均体温
    var _avgtemp:String=""
    dynamic var Avgtemp:String{
        get
        {
            return self._avgtemp
        }
        set(value)
        {
            self._avgtemp=value
        }
    }
    var _avgtemp2:String=""
    dynamic var Avgtemp2:String{
        get
        {
            return self._avgtemp2
        }
        set(value)
        {
            self._avgtemp2=value
        }
    }
    
    //睡眠时间段
    var _sleeptime:String=""
    dynamic var Sleeptime:String{
        get
        {
            return self._sleeptime
        }
        set(value)
        {
            self._sleeptime=value
        }
    }
    var _sleeptime2:String=""
    dynamic var Sleeptime2:String{
        get
        {
            return self._sleeptime2
        }
        set(value)
        {
            self._sleeptime2=value
        }
    }
    //翻身总次数
    var _totalturn:String=""
    dynamic var Totalturn:String{
        get
        {
            return self._totalturn
        }
        set(value)
        {
            self._totalturn=value
        }
    }
    var _totalturn2:String=""
    dynamic var Totalturn2:String{
        get
        {
            return self._totalturn2
        }
        set(value)
        {
            self._totalturn2=value
        }
    }
    
    //深睡时长
    var _deepsleep:String=""
    dynamic var Deepsleep:String{
        get
        {
            return self._deepsleep
        }
        set(value)
        {
            self._deepsleep=value
        }
    }
    var _deepsleep2:String=""
    dynamic var Deepsleep2:String{
        get
        {
            return self._deepsleep2
        }
        set(value)
        {
            self._deepsleep2=value
        }
    }
    //浅睡时长
    var _lightsleep:String=""
    dynamic var Lightsleep:String{
        get
        {
            return self._lightsleep
        }
        set(value)
        {
            self._lightsleep=value
        }
    }
    var _lightsleep2:String=""
    dynamic var Lightsleep2:String{
        get
        {
            return self._lightsleep2
        }
        set(value)
        {
            self._lightsleep2=value
        }
    }
    //在床时长
    var _onbed:String=""
    dynamic var Onbed:String{
        get
        {
            return self._onbed
        }
        set(value)
        {
            self._onbed=value
        }
    }
    var _onbed2:String=""
    dynamic var Onbed2:String{
        get
        {
            return self._onbed2
        }
        set(value)
        {
            self._onbed2=value
        }
    }
    
    //离床次数
   
    var _leavebed:String=""
    dynamic var Leavebed:String{
        get
        {
            return self._leavebed
        }
        set(value)
        {
            self._leavebed=value
        }
    }
    var _leavebed2:String=""
    dynamic var Leavebed2:String{
        get
        {
            return self._leavebed2
        }
        set(value)
        {
            self._leavebed2=value
        }
    }
    
    //系统分析
    var _analysis:String=""
    dynamic var Analysis:String{
        get
        {
            return self._analysis
        }
        set(value)
        {
            self._analysis=value
        }
    }
    
    override init(){
        super.init()
        
        
        self.LoadData()
        
        
    }

    func LoadData(){
    
    }
   
}

//在离床chart
class LeaveBedChart:NSObject{
    var _valueX:NSArray = NSArray()
    dynamic var ValueX:NSArray{
        get
        {
            return self._valueX
        }
        set(value)
        {
            self._valueX=value
        }
    }
    
    var _valueY:NSArray = NSArray()
    dynamic var ValueY:NSArray{
        get
        {
            return self._valueY
        }
        set(value)
        {
            self._valueY=value
        }
    }
    
    var flag:Bool = true  //标志有没有chart数据
}