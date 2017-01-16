//
//  BasicinfoViewModel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class BasicinfoViewModel: BaseViewModel {
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
    
    var _name:String=""
    dynamic var Name:String{
        get
        {
            return self._name
        }
        set(value)
        {
            self._name=value
        }
    }
    
    var _tel:String=""
    dynamic var Tel:String{
        get
        {
            return self._tel
        }
        set(value)
        {
            self._tel=value
        }
    }
    
    var _address:String=""
    dynamic var Address:String{
        get
        {
            return self._address
        }
        set(value)
        {
            self._address=value
        }
    }
    
    var _sex:String=""
    dynamic var Sex:String{
        get
        {
            return self._sex
        }
        set(value)
        {
            self._sex=value
        }
    }
    
    var _bingli:String=""
    dynamic var Bingli:String{
        get
        {
            return self._bingli
        }
        set(value)
        {
            self._bingli=value
        }
    }
    
    override init(){
        super.init()
        
       
       self.LoadBasicInfo()
        self.LoadData()
        
        
    }

    //底部基本信息的data
    func LoadBasicInfo(){
        try {
            ({
        let session = Session.GetSession()
        if session != nil{
            let curpartcode = session!.CurPartCode
            let curusercode = session!.CurUserCode
            var basicInfo:UserBasicInfo = SleepCareBussiness().GetPartUsersBasicInfo(curpartcode, userCode: curusercode)
           
            self.Name = basicInfo.UserName
            self.Address = basicInfo.Address
            self.Sex = basicInfo.Sex
            self.Tel = basicInfo.Phone
            self.Bingli = basicInfo.CaseCode
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
    
    
    //chart的data
    func LoadData(){
        try {
            ({
        var tempValueY:Array<String> = []
        var tempValueY2:Array<String> = []
        var tempValueX: Array<String> = []
        for(var i = 0; i<10; i++){
            tempValueX.append(String(i))
            tempValueY.append(String(i*10))
            tempValueY2.append(String(i*2))
        }
        self.HRRRRange.ValueY = NSArray(objects:tempValueY,tempValueY2)
        self.HRRRRange.ValueX = tempValueX
        
       
                let session = Session.GetSession()
                if session != nil{
                  
                    let curusercode = session!.CurUserCode
                    // 如果是按小时查询yyyy-MM-dd HH:00:00
                    var date = NSDate()
                    var timeFormatter = NSDateFormatter()
                    timeFormatter.dateFormat = "yyy-MM-dd HH:00:00"
                    let strEndTime = timeFormatter.stringFromDate(date) as String
                     var date2 = NSDate().dateByAddingTimeInterval(-24*60*60)
                    //[NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
                    
                    let strStartTime = timeFormatter.stringFromDate(date2) as String
        SleepCareBussiness().GetPartUsersSignHistory(strStartTime, analysisDateEnd: strEndTime, userCode: curusercode, selectQueryType: "1")
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
    
    
}
//心率呼吸chart
class HRRRChart:NSObject{
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
