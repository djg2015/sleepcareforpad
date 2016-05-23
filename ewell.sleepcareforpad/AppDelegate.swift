//
//  AppDelegate.swift
//  ewell.sleepcare
//
//  Created by djg on 15/8/21.
//  Copyright (c) 2015年 djg. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {
    
    var window: UIWindow?
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    var isBackRun:Bool = false
    
    //1由not running状态切换到inactive状态,程序初始化
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //延时启动界面
        NSThread.sleepForTimeInterval(1)
        
        InitPlistFile()


        return true
    }
    
    //2由inactive状态切换到active状态
    func applicationDidBecomeActive(application: UIApplication) {
        
        CheckRemoteNotice()
        
        //检查更新，每日一次
        var curUpdate = DateFormatterHelper.GetInstance().GetStringDateFromCurrent("yyyy-MM-dd")
        var updateflag = UpdateHelper.GetUpdateInstance().CheckLocalUpdateDate(curUpdate)
        //更新本地sleepcare.plist文件里updatedate
        SetValueIntoPlist("updatedate",curUpdate)
        if updateflag{
            UpdateHelper.GetUpdateInstance().PrepareConnection()
            //本地version对比store里最新的version大小
            UpdateHelper.GetUpdateInstance().CheckUpdate()
        }
        
        self.isBackRun = false
    }
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        return (Int)(UIInterfaceOrientationMask.LandscapeRight.rawValue)

    }
    

    func applicationWillResignActive(application: UIApplication) {
        
    }
    
  
    func applicationDidEnterBackground(application: UIApplication) {
        self.isBackRun = true
        
       
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果要后台运行,注册后台任务
        self.backgroundTask = application.beginBackgroundTaskWithExpirationHandler({
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
        
    }
    
    
    //5切换回本来的App时，由running状态切换到inactive状态
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    //6 应用终止，保存上次终止时的重要用户信息
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
        
        NSNotificationCenter.defaultCenter().postNotificationName("WarningClose", object: self)
    }
    
//    //接收本地通知
//    func application(application: UIApplication,
//        didReceiveLocalNotification notification: UILocalNotification) {
//            if(self.isBackRun){
//                //判断是否接收推送
//                NSNotificationCenter.defaultCenter().postNotificationName("TodoListShouldRefresh", object: self)
//                self.isBackRun = false
//            }
//    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void){
        
    }
    
    //接收远程推送通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

        
    }
    
    //成功注册通知后，获取device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var token:String = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        println("token==\(token)")
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "DeviceToken")
  
        OpenNotice()
        
    }
    
    //当推送注册失败时
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        }

}