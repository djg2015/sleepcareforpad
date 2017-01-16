//
//  Session.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import Foundation
//用户登录信息
class Session {
    private init(){
    
    }
    
    private var _user:User?
    var LoginUser:User?{
        get
        {
            return self._user
        }
    }

    //当前选中的养老院Name
    private var _curMainName:String = ""
    var CurMainName:String{
        get{
            return self._curMainName
        }
        set(value){
            self._curMainName=value
        }
    }
    //当前选中的科室Name
    private var _curPartName:String = ""
    var CurPartName:String{
        get{
            return self._curPartName
        }
        set(value){
            self._curPartName=value
        }
    }
    
    //当前选中的科室code
    private var _curPartCode:String = ""
    var CurPartCode:String{
        get{
            return self._curPartCode
        }
        set(value){
            self._curPartCode=value
        }
    }
    
    
    //当前账户下所有养老院和其下科室名
    private var _mainAndPartArrayList:Array<Play> = Array<Play>()
    var MainAndPartArrayList:Array<Play>{
        get{
           
            return self._mainAndPartArrayList
        }
        set(value){
            self._mainAndPartArrayList=value
        }
    }
    
    //当前选中查看的病人usercode
    private var _curUserCode:String = ""
    var CurUserCode:String{
        get{
            return self._curUserCode
        }
        set(value){
            self._curUserCode=value
        }
    }
    
    private var _curUserName:String = ""
    var CurUserName:String{
        get{
            return self._curUserName
        }
        set(value){
            self._curUserName=value
        }
    }
    
    private var _curEquipmentID:String = ""
    var  CurEquipmentID:String{
        get{
            return self._curEquipmentID
        }
        set(value){
            self._curEquipmentID=value
        }
    }
   
    
//每个partcode对应的mainname，partname字典
    private var _partcodeDictionary:Dictionary<String,partandmainInfo> = Dictionary<String,partandmainInfo>()
    var PartcodeDictionary:Dictionary<String,partandmainInfo>{
        get{
            
            return self._partcodeDictionary
        }
        set(value){
            self._partcodeDictionary=value
        }
    }

   
    
    //当前选中的场景code
    private var _PartCodes:Array<Role> = Array<Role>()
    var PartCodes:Array<Role>{
        get{
            return self._PartCodes
        }
        set(value){
            self._PartCodes=value
        }
    }

    
    
    private static var instance:Session? = nil
    
    //设置登录用户信息
    class func SetSession(user:User){
        if(self.instance == nil){
        self.instance = Session()
        }
        self.instance!._user = user
    }
    
    class func ClearSession(){
        self.instance = nil
    }
    
    class func GetSession() -> Session? {
        if self.instance == nil{
            print("session is nil")
            return nil
        }
        return self.instance!
     
    }
}