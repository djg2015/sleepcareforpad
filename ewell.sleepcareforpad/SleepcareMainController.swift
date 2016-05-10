//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class SleepcareMainController: BaseViewController,UIScrollViewDelegate,UISearchBarDelegate,JumpPageDelegate,ChoosePartDelegate {
    //界面控件
    @IBOutlet weak var curPager: Pager!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var lblMainName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtSearchChoosed: UITextField!
    @IBOutlet weak var lblWarining: UILabel!
    @IBOutlet weak var btnRefresh: UIButton!
    //床位状态
    @IBOutlet weak var lblBedCount: UILabel!
    @IBOutlet weak var lblBindBedCount: UILabel!
    @IBOutlet weak var lblOnBed: UILabel!
    @IBOutlet weak var lblLeaveBed: UILabel!
    @IBOutlet weak var lblEmptyBed: UILabel!
    //删选框
    @IBOutlet weak var checkOnBed: UIButton!
    @IBOutlet weak var checkLeaveBed: UIButton!
    @IBOutlet weak var checkUnnormal: UIButton!
    @IBOutlet weak var checkEmptyBed: UIButton!
    @IBOutlet weak var checkOffDuty: UIButton!
    //切换养老院
    @IBOutlet weak var btnChoose: UIButton!
    
    
    @IBAction func UnwindToMainController(segue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindToMainController2(segue:UIStoryboardSegue){
        
        
    }
    @IBAction func UnwindToMainController3(segue:UIStoryboardSegue){
        
        
    }
    
    //类字段
    var mainScroll:UIScrollView!
    var popDownList:PopDownList?
    var partDownList:PopDownList?
    var sleepcareMainViewModel:SleepcareMainViewModel?
    var choosepart:ChooseMainhouseController?
    var spinner:JHSpinnerView?
    var thread:NSThread!
    //支线程完成true
    var threadFlag:Bool = false
    
    //要显示的床位信息
    var ShowBedViews:Array<BedModel> = Array<BedModel>()
    
    //在离床状态变化引起的主页面床位刷新标志
    var RefreshFlag:Bool = false{
        didSet{
            if RefreshFlag{
            self.ReloadMainScrollView()
            }
        }
    }
    
    //当前科室下所有床位信息
    var BedViews:Array<BedModel>?{
        didSet{

            if !self.threadFlag{
                self.ReloadMainScrollView()
            }
            
            if self.spinner != nil{
                self.threadFlag = true
            }

        }
    }
    
    var WarningSet:Int = 0{
        didSet{
            if(self.WarningSet > 0){
               
                self.lblWarining.text = "有" + self.WarningSet.description + "条报警未处理,请点击查看"
            }
            else{
               self.lblWarining.text = ""
            }
        }
    }
    
    //实时统计在／离／空床数目
    var OnbedLabel:Int = 0{
        didSet{
            self.lblOnBed.text = String(OnbedLabel)
        }
    }
    var LeavebedLabel:Int = 0{
        didSet{
            self.lblLeaveBed.text = String(LeavebedLabel)
        }
    }
    var EmptybedLabel:Int = 0{
        didSet{
            self.lblEmptyBed.text = String(EmptybedLabel)
        }
    }
    
    
    var clearlogininfoDelegate:ClearLoginInfoDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainScroll = UIScrollView()
        self.mainScroll.frame = UIScreen.mainScreen().bounds
        self.mainScroll.frame.origin.y = 190
        self.mainScroll.frame.size.height = UIScreen.mainScreen().bounds.height - 260
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = false
        self.mainScroll.delegate = self
        self.mainScroll.bounces = false
        
        
        self.view.addSubview(self.mainScroll)
        
        self.curPager.frame.size.width = UIScreen.mainScreen().bounds.width
        
        //去掉搜索按钮背景
        for(var i = 0 ; i < self.search.subviews[0].subviews.count; i++) {
            if(self.search.subviews[0].subviews[i].isKindOfClass(NSClassFromString("UISearchBarBackground"))){
                self.search.subviews[0].subviews[i].removeFromSuperview()
            }
        }
        self.search.delegate = self
        self.curPager.detegate = self
        
        //若没有选择记住密码，则清空登录页面里的输入信息
        if self.clearlogininfoDelegate != nil{
            self.clearlogininfoDelegate!.ClearLoginInfo()
        }
        
        //若curpartcode为空，则弹窗让用户选择
        if Session.GetSession().CurPartCode == ""{
            self.mainNameTouch()
        }
        else{
            //远程通知
            OpenNotice()
        }
        
        rac_setting()
    }
    
    //查询按钮事件
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.sleepcareMainViewModel?.SearchByBedOrRoom(searchText)
    }
    
    //床位点击事件
    func BedSelected(bedModel:BedModel){
        try {
            ({
                //正常业务处理
             //   self.presentViewController(DialogFrameController(nibName: "DialogFrame", userCode: bedModel.UserCode!), animated: true, completion: nil)
                
                if bedModel.UserCode != nil{
                Session.GetSession().CurUserCode = bedModel.UserCode!
                
                self.performSegueWithIdentifier("ShowPatientDetail", sender: self)
                }
                },
                catch: { ex in
                    //异常处理
                    
                },
                finally: {
                    
                }
            )}
        
    }
    
    
    //属性绑定
    func rac_setting(){
        sleepcareMainViewModel = SleepcareMainViewModel()
        sleepcareMainViewModel?.controller = self
        RACObserve(self.sleepcareMainViewModel, "BedModelList") ~> RAC(self, "BedViews")
        RACObserve(self.sleepcareMainViewModel, "PageCount") ~> RAC(self.curPager, "pageCount")
        RACObserve(self.sleepcareMainViewModel, "MainName") ~> RAC(self.lblMainName, "text")
        RACObserve(self.sleepcareMainViewModel, "CurTime") ~> RAC(self.lblDateTime, "text")
        RACObserve(self.sleepcareMainViewModel, "BedCount") ~> RAC(self.lblBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "BindBedCount") ~> RAC(self.lblBindBedCount, "text")
        RACObserve(self.sleepcareMainViewModel, "ChoosedSearchType") ~> RAC(self.txtSearchChoosed, "text")
        RACObserve(self.sleepcareMainViewModel, "WariningCount") ~> RAC(self, "WarningSet")
        RACObserve(self.sleepcareMainViewModel, "OnbedCount") ~> RAC(self, "OnbedLabel")
        RACObserve(self.sleepcareMainViewModel, "LeavebedCount") ~> RAC(self, "LeavebedLabel")
        RACObserve(self.sleepcareMainViewModel, "EmptybedCount") ~> RAC(self, "EmptybedLabel")
       RACObserve(self.sleepcareMainViewModel, "RefreshFlag") ~> RAC(self, "RefreshFlag")
        
        //退出登录
        self.btnLogout!.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
            .subscribeNext {
                _ in
                self.clearlogininfoDelegate = nil
                //关闭报警和通知
                self.sleepcareMainViewModel?.CloseWaringAttention()
                 CloseNotice()
                //置空session，恢复登录前配置
                
                Session.ClearSession()
                 LOGINFLAG = false
                TodoList.sharedInstance.removeItemAll()
                //关闭页面，退回到login页面
                self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        
        //checkbox绑定手势操作
        self.checkEmptyBed.addTarget(self, action: "EmptyBedTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.checkOnBed.addTarget(self, action: "OnBedTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.checkLeaveBed.addTarget(self, action: "LeaveBedTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.checkUnnormal.addTarget(self, action: "UnnormalTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.checkOffDuty.addTarget(self, action: "OffDutyTouch", forControlEvents: UIControlEvents.TouchUpInside)
        
       
        
        //设置选择查找类型
        self.imgSearch.userInteractionEnabled = true
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageViewTouch")
        self.imgSearch .addGestureRecognizer(singleTap)
        
        var dataSource = Array<DownListModel>()
        var item = DownListModel()
        item.key = SearchType.byBedNum
        item.value = SearchType.byBedNum
        dataSource.append(item)
        item = DownListModel()
        item.key = SearchType.byRoomNum
        item.value = SearchType.byRoomNum
        dataSource.append(item)
        self.popDownList = PopDownList(datasource: dataSource, dismissHandler: self.ChoosedItem)
        
        //设置选择科室rolename
        var session = Session.GetSession()
        self.lblMainName.userInteractionEnabled = true
        var choosePart:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mainNameTouch")
        self.lblMainName .addGestureRecognizer(choosePart)
        
        //查看报警明细
        self.lblWarining.userInteractionEnabled = true
        var showWarining:UITapGestureRecognizer = UITapGestureRecognizer(target: self.sleepcareMainViewModel!, action: "showWarining")
        self.lblWarining .addGestureRecognizer(showWarining)
        
        //选择科室
        self.choosepart = ChooseMainhouseController(nibName: "ChoosePartName", bundle: nil)
        self.choosepart!.parentController = self
        self.choosepart!.choosepartDelegate = self
        
        self.btnChoose.addTarget(self, action: "mainNameTouch", forControlEvents: UIControlEvents.TouchUpInside)
        
    //筛选btn
        self.checkUnnormal.setImage(UIImage(named:"checkbox.png"), forState: UIControlState.Normal)
        self.checkUnnormal.setImage(UIImage(named:"checkboxchoosed.png"), forState: UIControlState.Selected)

        self.checkOnBed.setImage(UIImage(named:"checkbox.png"), forState: UIControlState.Normal)
        self.checkOnBed.setImage(UIImage(named:"checkboxchoosed.png"), forState: UIControlState.Selected)
        
        self.checkLeaveBed.setImage(UIImage(named:"checkbox.png"), forState: UIControlState.Normal)
        self.checkLeaveBed.setImage(UIImage(named:"checkboxchoosed.png"), forState: UIControlState.Selected)
        
        self.checkEmptyBed.setImage(UIImage(named:"checkbox.png"), forState: UIControlState.Normal)
        self.checkEmptyBed.setImage(UIImage(named:"checkboxchoosed.png"), forState: UIControlState.Selected)
        
        self.checkOffDuty.setImage(UIImage(named:"checkbox.png"), forState: UIControlState.Normal)
        self.checkOffDuty.setImage(UIImage(named:"checkboxchoosed.png"), forState: UIControlState.Selected)
        
       
    }
    
    
    //刷新
    @IBAction func Refresh(){
        if Session.GetSession().CurPartCode != ""{
            if self.spinner == nil{
                self.spinner  = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.whiteColor(), overlay:.Custom(CGRect(x:0,y:0,width:Int(UIScreen.mainScreen().bounds.width),height:Int(UIScreen.mainScreen().bounds.height)), CGFloat(0.0)), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.9))
                
                self.mainScroll.userInteractionEnabled = false
            }
            
            
            /*定时器，检查支线程是否完成
            */
            self.setTimer()
            
            //创建支线程
            self.thread = NSThread(target: self, selector: "RunThread", object: nil)
            //启动
            self.thread!.start()
        }
        else{
            showDialogMsg(ShowMessage(MessageEnum.NeedChoosePart))
        }
    }
    
    //支线程，完成刷新操作
    func RunThread(){
        var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
        let isLogin = xmppMsgManager!.RegistConnect()
        if(!isLogin){
            if self.spinner != nil{
                self.spinner!.dismiss()
                self.spinner = nil
            }
            
            
            showDialogMsg(ShowMessage(MessageEnum.ConnectFail))
        }
        else{
            self.ResetCheckbox()
            self.sleepcareMainViewModel!.SearchByBedOrRoom("")
        }
    }
    
    //定时器，检查支线程是否完成，完成后关闭spinner
    var realtimer:NSTimer!
    func setTimer(){
        realtimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "SpnnerTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    func SpnnerTimerFireMethod(timer: NSTimer) {
        if (self.threadFlag && self.spinner != nil){
            if self.thread != nil{
            self.thread!.cancel()
            }
             realtimer.invalidate()
            
            self.ReloadMainScrollView()
            
            self.mainScroll.userInteractionEnabled = true
            self.spinner!.dismiss()
            self.spinner = nil
            self.threadFlag = false
           
            
        }
    }
    
    func ResetCheckbox(){
            self.checkEmptyBed.selected = true
            self.checkOnBed.selected = true
         self.checkLeaveBed.selected = true
         self.checkUnnormal.selected = true
        self.checkOffDuty.selected = true
        
    }
    
    
    //将床位信息显示到主页面上
    func ReloadMainScrollView(){
        while (self.mainScroll.subviews.count > 0 ){
            self.mainScroll.subviews[0].removeFromSuperview()
        }
        
        if (self.BedViews != nil && self.sleepcareMainViewModel != nil){
            //通过bedviews做删选，放入ShowBedViews数组
            self.ShowBedViews = Array<BedModel>()
            let onbedViews:Array<BedModel> = self.checkOnBed.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.onbed}) : Array<BedModel>()
            let leavebedViews:Array<BedModel> = self.checkLeaveBed.selected ?  self.BedViews!.filter({$0.BedStatus == BedStatusType.leavebed}) : Array<BedModel>()
            let emptybedViews:Array<BedModel> = self.checkEmptyBed.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.emptybed}) : Array<BedModel>()
            let offdutyViews:Array<BedModel> = self.checkOffDuty.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.offduty}) : Array<BedModel>()
            let unnormalViews:Array<BedModel> = self.checkUnnormal.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.unnormal}) : Array<BedModel>()
            self.ShowBedViews = onbedViews + leavebedViews + emptybedViews + offdutyViews + unnormalViews
            
            //放入主页面中，实现分页
            let pageCount:Int = (self.ShowBedViews.count / 8) + ((self.ShowBedViews.count % 8) > 0 ? 1 : 0)
            
            //pagercount发生变化时才赋值给viewmodel，这样通知到pager进行更新
         //   if (pageCount != self.sleepcareMainViewModel?.PageCount){
              
            self.sleepcareMainViewModel?.PageCount = pageCount
              
           // }
            
            
            self.mainScroll.contentSize = CGSize(width: self.mainScroll.bounds.size.width * CGFloat(pageCount), height: self.mainScroll.bounds.size.height)
            self.mainScroll.contentOffset.x = 0
            
            if(pageCount > 0 ){
                for i in 1...pageCount{
                    let mainview1 = NSBundle.mainBundle().loadNibNamed("SleepCareCollectionView", owner: self, options: nil).first as! SleepCareCollectionView
                    mainview1.frame = CGRectMake(CGFloat((i-1) * Int(self.mainScroll.frame.width)) + 10, 0, self.mainScroll.frame.width, self.mainScroll.frame.size.height)
                    
                    mainview1.didSelecteBedHandler = self.BedSelected
                    var bedList = self.sleepcareMainViewModel?.GetBedsOfPage(i, count: 8,list:self.ShowBedViews, maxcount:self.ShowBedViews.count)
                    mainview1.reloadData(bedList!)
                    self.mainScroll.addSubview(mainview1)
                    self.mainScroll.bringSubviewToFront(mainview1)
                    
                }
            }
        }//bedviews非nil
    }
    
    
    func OnBedTouch(){
       
      self.checkOnBed.selected = !self.checkOnBed.selected
        self.ReloadMainScrollView()
    }
    
    func LeaveBedTouch(){
        
        self.checkLeaveBed.selected = !self.checkLeaveBed.selected
        self.ReloadMainScrollView()
    }
    
    func EmptyBedTouch(){
        self.checkEmptyBed.selected = !self.checkEmptyBed.selected
       self.ReloadMainScrollView()
    }
    func OffDutyTouch(){
       
       self.checkOffDuty.selected = !self.checkOffDuty.selected
       self.ReloadMainScrollView()
    }
    func UnnormalTouch(){
        self.checkUnnormal.selected = !self.checkUnnormal.selected
       self.ReloadMainScrollView()
    }
    
    
    //点击查询类型
    func imageViewTouch(){
        
        self.popDownList!.Show(150, height: 80, uiElement: self.imgSearch)
    }
    
    //选择科室，选择完后刷新科室下的病人bedviews
    func mainNameTouch(){
        
        if self.choosepart != nil{
            var kNSemiModalOptionKeys = [ KNSemiModalOptionKeys.pushParentBack: "NO", KNSemiModalOptionKeys.animationDuration: "0.2", KNSemiModalOptionKeys.shadowOpacity: "0.3"]
            
            self.presentSemiViewController(self.choosepart, withOptions: kNSemiModalOptionKeys)
            
            
            self.choosepart!.GetMainInfo()
        }
    }
    
    //选择某科室代理
    func ChoosePart(partcode:String,partname:String,mainname:String) {
        //恢复全选
        self.ResetCheckbox()
        //加载报警
        self.sleepcareMainViewModel?.ReloadAlarmInfo()
        //curpartcode改变，重开远程通知
        OpenNotice()
        //更新标题
        self.lblMainName.text = mainname + "—" + partname
        //刷新床位信息
        self.sleepcareMainViewModel?.SearchByBedOrRoom("")
    }
    
    //左右滑动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page = Int(scrollView.contentOffset.x / self.mainScroll.frame.width) + 1
        self.curPager.jump(page)
    }
    
    //代理
    func JumpPage(pageIndex:NSInteger){
        self.mainScroll.contentOffset.x = CGFloat(pageIndex - 1) * self.mainScroll.frame.width
        
    }
    
    //选中查询类型
    func ChoosedItem(downListModel:DownListModel){
        self.sleepcareMainViewModel?.ChoosedSearchType = downListModel.value
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol ClearLoginInfoDelegate{
    func ClearLoginInfo()
}
