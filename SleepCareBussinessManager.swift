//
//  SleepCareBussinessManager.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/22.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//针对智能床业务模块全部接口定义
protocol SleepCareBussinessManager{
    // 2  获取登录信息，返回登录用户
    // 参数：LoginName->登录账户
    //      LoginPassword->登录密码
    func GetLoginInfo(LoginName:String,LoginPassword:String)->User
    
    // 3  根据角色父编码获取父编码下所有的角色包括当前父角色
    // 参数：parentRoleCode->父角色编码
    func ListRolesByParentCode(parentRoleCode:String)->RoleList
    
    //4  获取养老院和其下科室信息
    func TreeRolesByRoleCode(rolecode:String)->RoleTreeList

    
    // 5  根据科室/楼层编号 获取当前科室/楼层信息包括对应的床位信息
    // 参数：partCode->科室/楼层编码
    //      searchType->查找类型：1.按照房间号查询 2.按照床位号查询
    //      searchContent->房间号或者床位号
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetPartInfoByPartCode(partCode:String,loginName:String,searchType:String,searchContent:String,from:Int32?,max:Int32?)->SinglePartInfo
    
    // 6  根据床位编码获取当前床位用户的信息
    // 参数：partCode->科室/楼层编码
    //      bedCode->床位编码
    func GetUserByBedCode(partCode:String,bedCode:String)->BedUser
    
    // 7  根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：partCode->科室/楼层编码
    //      userCode->用户编码
    //      analysTimeBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysTimeEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
   // func GetSleepCareReportByUser(partCode:String,userCode:String,analysTimeBegin:String,analysTimeEnd:String,from:Int32?,max:Int32?)->SleepCareReportList
    
    // 8   根据科室/楼层编号、用户编号、分析日期多条件获取睡眠质量分析明细
    // 参数：userCode->用户编码
    //      analysDate->分析日期("yyyy-MM-dd"格式)
    // func QuerySleepQulityDetail(userCode:String,analysDate:String)->SleepCareReport
    
    // 9  根据科室/楼层编号、用户编号、分析时间段多条件获取睡眠质量总览
    // 参数：userCode->用户编码
    //      analysDateBegin->分析时段起始时间("yyyy-MM-dd"格式)
    //      analysDateEnd->分析时段结束时间("yyyy-MM-dd"格式)
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
   // func GetTurnOverAnalysByUser(userCode:String,analysDateBegin:String,analysDateEnd:String,from:Int32?,max:Int32?)->TurnOverAnalysList
    
    // 10  根据科室/楼层编号、用户编码、用户姓名模糊查找、床位号模糊查找、报警类型、报警时间段等多条件获取报警信息
    // 参数：partCode->科室/楼层编码
    //      userCode->用户编码
    //      userNameLike->用户名称模糊查找
    //      bedNumberLike->床位号模糊查找
    //      schemaCode->报警方案编码
    //      alarmTimeBegin->报警起始时间
    //      alarmTimeEnd->报警结束时间
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
    func GetAlarmByUser(partCode:String,loginName:String,userCode:String,userNameLike:String,bedNumberLike:String,schemaCode:String,alarmTimeBegin:String,alarmTimeEnd:String, from:Int32?,max:Int32?)-> AlarmList
    
    //11 异常
    
    
    // 12   根据科室/楼层编号、用户编码、用户姓名模糊查找、床位号模糊查找、离床时间段等多条件获取离床异常信息
    // 参数：partCode->科室/楼层编码
    //      userCode->用户编码
    //      userNameLike->用户名称模糊查找
    //      bedNumberLike->床位号模糊查找
    //      leaveBedTimeBegin->离床起始时间
    //      leaveBedTimeEnd->离床结束时间
    //      from->查询记录起始序号
    //      max->查询的最大记录条数
  //  func GetLeaveBedReport(partCode:String,userCode:String,userNameLike:String,bedNumberLike:String,leaveBedTimeBegin:String,leaveBedTimeEnd:String,from:Int32?,max:Int32?)-> BedReportList
    
    
    //13.	根据医院/养老院编号获取所有的科室/楼层
   // func GetPartInfoByMainCode(mainCode:String)->PartInfoList
    
    //14 推送
    
    // 15  处理报警信息
    // 参数：alarmCode-> 报警编号
    //      transferType-> 处理类型 002:处理 003:误警报
    func HandleAlarm(alarmCode:String,transferType:String,loginName:String,transferResult:String,remark:String)
    
    //16 推送
    
    //17  关闭远程通知
     func CloseNotification(token:String, loginName:String)-> Result
    
    
    //18  打开远程通知
    func OpenNotification(token:String, loginName:String,password:String,partCode:String)-> Result
    
    
    
   //19.	获取病区用户基础信息
    func GetPartUsersBasicInfo(partCode:String, userCode:String)->UserBasicInfo
    
    // 20.	查询病区用户历史体征
    // 按天、按小时统计 1表示按小时统计 2表示按天统计
    func GetPartUsersSignHistory(analysisDateBegin:String,analysisDateEnd:String,userCode:String, selectQueryType:String)->SignHistoryReportList
    
    
    //21.	查询病区用户历史在离床
    // 在离床状态 1表示离床 2表示在床
    func GetPartUsersLeaveBedReprot(analysisDateBegin:String,analysisDateEnd:String,userCode:String, selectBedStatus:String)->PartLeaveBedReportList
    
    //22.	查询病区用户指定日期的夜间分析报告
    func GetPartUsersNightReport(analysisDate:String, userCode:String)->NightReport
    
    
   // 23.	查询病区用户报警历史
    // 选中的报警类型，参考文档最后的报警类型
    // 选中的处理类型 1.未处理2.已处理3.误报警
    func GetPartUsersAlarmList(analysisDateBegin:String, analysisDateEnd:String, userCode:String, selectAlarmType:String, selectTransferType:String)->HistoryAlarmList
    
    
//    报警类型如下：
//    ALM_TEMPERATURE   体温报警
//    ALM_HEARTBEAT      心率报警
//    ALM_BREATH         呼吸报警'
//    ALM_BEDSTATUS		     在离床报警
//    ALM_FALLINGOUTOFBED	坠床风险报警
//    ALM_BEDSORE			褥疮风险报警
//    ALM_BEDSORE			褥疮风险报警
//    ALM_CALL  呼叫报警
}