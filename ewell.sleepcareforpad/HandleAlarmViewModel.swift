//
//  HandleAlarmViewModel.swift
//  
//
//  Created by Qinyuan Liu on 5/16/16.
//
//
import UIKit
class HandleAlarmViewModel:BaseViewModel {
 
    
    var _alarmCode:String = ""
    dynamic var AlarmCode:String{
        get
        {
            return self._alarmCode
        }
        set(value)
        {
            self._alarmCode=value
        }
        
    }
    var _transferResult:String = ""
    dynamic var TransferResult:String{
        get
        {
            return self._transferResult
        }
        set(value)
        {
            self._transferResult=value
        }
        
    }
    var _remark:String = ""
    dynamic var Remark:String{
        get
        {
            return self._remark
        }
        set(value)
        {
            self._remark=value
        }
        
    }
 

    
    
    
    //处理报警：删除对应的todoitem，删除这条报警信息，从alarmlist中删除
    func HandleAlarmAction(_transferType:String)->Bool
    {
      
    
        var flag:Bool = true
        try {
            ({

                let session = Session.GetSession()!
                 SleepCareBussiness().HandleAlarm(self.AlarmCode, transferType: _transferType,loginName:session.LoginUser!.LoginName,transferResult:self.TransferResult,remark:self.Remark)
                
              //  AlarmHelper.GetAlarmInstance().DeleteAlarmByCode(self.AlarmCode)
               
                
                
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                    flag = false
                },
                finally: {
                    
                }
            )}
        return flag
    }
    
   


}