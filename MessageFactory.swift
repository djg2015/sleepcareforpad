//
//  MessageFactory.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/17.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation

let tag_realtimedata:String="<RealTimeReport"
let tag_userinfo:String="<User"
let tag_roleList:String="<EPRoleList"
let tag_roleTreeList:String="<EPRoleTree"
let tag_partInfo:String="<PartInfo"
let tag_bedUser:String="<BedUser"
let tag_EMServiceException:String="<EMServiceException"
let tag_Result:String="<Result"
let tag_userBasicInfo:String = "<UserBasicInfo"
let tag_signHistoryReportList:String = "<EPSignHistoryReportList"
let tag_partuserLeaveBedReport:String = "<EPLeaveBedReportList"
let tag_nightReport:String = "<NightReport"
let tag_historyAlarmlist:String = "<EPPartUserAlarmList"
let tag_alarmList:String="<EPAlarmInfoList>"

//let tag_sleepCareReportList:String="<SleepCareReportList"
//let tag_sleepCareReport:String="<SleepCareReport"
//let tag_turnOverAnalysList:String="<TurnOverAnalysList"
//let tag_bedReportList:String="<BedReportList"
//let tag_mainInfo:String="<MainInfo"

class MessageFactory {
    //xmpp字符串节点
    
    class func GetMessageModel(message:Message) -> BaseMessage {
        if(message.content.hasPrefix(tag_realtimedata)){
            return RealTimeReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_userinfo)){
            return User.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_roleList)){
            return RoleList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_partInfo)){
            return SinglePartInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_bedUser)){
            return BedUser.XmlToMessage(message.subject, bodyXMl: message.content)
        }
//        else if(message.content.hasPrefix(tag_sleepCareReportList)){
//            return SleepCareReportList.XmlToMessage(message.subject, bodyXMl: message.content)
//        }
//        else if(message.content.hasPrefix(tag_sleepCareReport)){
//            return SleepCareReport.XmlToMessage(message.subject, bodyXMl: message.content)
//        }
//        else if(message.content.hasPrefix(tag_turnOverAnalysList)){
//            return TurnOverAnalysList.XmlToMessage(message.subject, bodyXMl: message.content)
//        }
        else if(message.content.hasPrefix(tag_alarmList)){
            return AlarmList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
//        else if(message.content.hasPrefix(tag_bedReportList)){
//            return BedReportList.XmlToMessage(message.subject, bodyXMl: message.content)
//        }
        else if(message.content.hasPrefix(tag_EMServiceException))
        {
            return EMServiceException.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_Result))
        {
            return Result.XmlToMessage(message.subject, bodyXMl: message.content)
        }
       
       
        else if(message.content.hasPrefix(tag_roleTreeList))
        {
           
            return RoleTreeList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_userBasicInfo))
        {
            
            return UserBasicInfo.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_signHistoryReportList))
        {
            
            return SignHistoryReportList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_partuserLeaveBedReport))
        {
            
            return PartLeaveBedReportList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_nightReport))
        {
            
            return NightReport.XmlToMessage(message.subject, bodyXMl: message.content)
        }
        else if(message.content.hasPrefix(tag_historyAlarmlist))
        {
            
            return HistoryAlarmList.XmlToMessage(message.subject, bodyXMl: message.content)
        }
//        else if(message.content.hasPrefix(tag_mainInfo)){
//            return PartInfoList.XmlToMessage(message.subject, bodyXMl: message.content)
//        }

            
        else
        {
            throw("-1", "请求发生错误，请重试！")
        }
        return BaseMessage.XmlToMessage(message.subject, bodyXMl: message.content)
    }
}
