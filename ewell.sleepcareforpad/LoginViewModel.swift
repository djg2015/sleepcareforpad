//
//  LoginViewModel.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/23
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class LoginViewModel: BaseViewModel,ClearLoginInfoDelegate{
    //属性定义
    var _userName:String?
    dynamic var UserName:String?{
        get
        {
            return self._userName
        }
        set(value)
        {
            self._userName=value
        }
    }
    
    var _userPwd:String?
    dynamic var UserPwd:String?{
        get
        {
            return self._userPwd
        }
        set(value)
        {
            self._userPwd=value
        }
    }
    
    var _isCheched:UIImage?
    dynamic var IsCheched:UIImage?{
        get
        {
            return self._isCheched
        }
        set(value)
        {
            self._isCheched=value
        }
    }
    
    var _ischechedBool:Bool = false
    var IschechedBool:Bool{
        get
        {
            return self._ischechedBool
        }
        set(value)
        {
            self._ischechedBool = value
            if(self._ischechedBool){
                self.IsCheched = UIImage(named: "checkboxchoosed.png")
            }
            else{
                self.IsCheched = UIImage(named: "checkbox.png")
            }
        }
    }
    
    var login: RACCommand?
    var remeberChecked: RACCommand?
    
    
    //构造函数
    override init(){
        super.init()
        
        login = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.Login()
        }
        
        remeberChecked = RACCommand() {
            (any:AnyObject!) -> RACSignal in
            return self.RemeberPwd()
        }
        
        
    }
    
   
    /**
    登录前操作，获取openfire地址等信息，获取成功则记录在本地plist文件中
    */
    func BeforeLogin(){
        try {
            ({
               OpenFireServerInfoHelper().CheckServerInfo()
                },
                catch: { ex in
                    //异常处理
                    handleException(ex,showDialog: true)
                },
                finally: {
                    
                }
            )}
        
    }

    
    //点击登录按钮操作
    func Login() -> RACSignal{
        try {
            ({
                //检查输入是否合法
                if(self.UserName == ""){
                    showDialogMsg(ShowMessage(MessageEnum.LoginnameNil))
                    return
                }
                if(self.UserPwd == ""){
                    showDialogMsg(ShowMessage(MessageEnum.PwdNil))
                    return
                }

                //获取openfire信息
                self.BeforeLogin()
                
            
                    //从服务器获取user信息，并设置当前session
                    let testBLL = SleepCareBussiness()
                    var user:User = testBLL.GetLoginInfo(self.UserName!, LoginPassword: self.UserPwd!)
                    Session.SetSession(user)
                    var session = Session.GetSession()
 
                    //登录成功，记住用户名密码处理
                    if(self.IschechedBool){
                        SetValueIntoPlist("loginusername", self.UserName!)
                        SetValueIntoPlist("loginuserpwd", self.UserPwd!)
                    }
                        //不记住，则清空
                    else{
                        SetValueIntoPlist("loginusername","")
                        SetValueIntoPlist("loginuserpwd", "")
                     
                    }
                    LOGINFLAG = true
                    
                    //获取当前账户下养老院和科室信息
                    GetMainAndPartInfo()
                   
                    
                    //当前partcode是否只有一个：1是，直接选为curpartcode；更新session和plist里的值
                    //                       否，plist中curpartcode是否为空：空，不做操作
                    //                                                    2非空：验证curpartcode是否符合权限：符合，不做操作
                    //                                                                                  3不符合，清空plist里的值
                
                if session != nil{
                let mainandpartInfo = session!.MainAndPartArrayList
                    if mainandpartInfo.count == 1{
                        let mainandpartDic = mainandpartInfo[0]
                        let partnames = mainandpartDic.partnames
                        if partnames.count == 1{
                            session!.CurMainName = mainandpartDic.name
                            session!.CurPartName = partnames[0].partname
                            session!.CurPartCode = partnames[0].partcode
                            SetValueIntoPlist("curPartcode",session!.CurPartCode)
                            SetValueIntoPlist("curPartname",session!.CurPartName)
                            SetValueIntoPlist("curMainname",session!.CurMainName)
                        }
                    }
                    else{
                    let temppartcode = GetValueFromPlist("curPartcode","sleepcare.plist")
                        if temppartcode != ""{
                        let partcodes = session!.PartcodeDictionary.keys
                            let codes = partcodes.filter({$0 == temppartcode})
                            if codes.array.count == 0{
                                SetValueIntoPlist("curPartcode","")
                                SetValueIntoPlist("curPartname","")
                                SetValueIntoPlist("curMainname","")
                            }
                            else{
                                session!.CurPartCode = temppartcode
                                session!.CurMainName = GetValueFromPlist("curMainname","sleepcare.plist")
                                session!.CurPartName = GetValueFromPlist("curPartname","sleepcare.plist")
                            }
                        }
                    }
                }
                 //跳转主页面
                    if self.controller != nil{
                 self.controller.performSegueWithIdentifier("MainView", sender: self.controller)
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
    
    //点击“记住密码”按钮操作
    func RemeberPwd() -> RACSignal{
        self.IschechedBool = !self.IschechedBool
        return RACSignal.empty()
        
    }
    
     //初始加载记住密码的相关配置数据
    func loadInitData(){
        self.UserName = GetValueFromPlist("loginusername","sleepcare.plist")
        self.UserPwd = GetValueFromPlist("loginuserpwd","sleepcare.plist")
        if(self.UserName == "" || self.UserPwd == ""){
            self.IschechedBool = false
        }
        else{
            self.IschechedBool = true
        }
    }
    
    func ClearLoginInfo(){
    self.UserName = ""
        self.UserPwd = ""
    }
}
