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
    @IBOutlet weak var lblBedCount: UILabel!
    @IBOutlet weak var lblBindBedCount: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var txtSearchChoosed: UITextField!
    @IBOutlet weak var uiWariningShow: UIView!
    @IBOutlet weak var lblWarining: UILabel!
    @IBOutlet weak var btnRefresh: UIButton!
    //床位状态
    @IBOutlet weak var lblOnBed: UILabel!
    @IBOutlet weak var lblLeaveBed: UILabel!
    @IBOutlet weak var lblEmptyBed: UILabel!
    //删选框
    @IBOutlet weak var checkOnBed: UIImageView!
    @IBOutlet weak var checkLeaveBed: UIImageView!
    @IBOutlet weak var checkUnnormal: UIImageView!
    @IBOutlet weak var checkEmptyBed: UIImageView!
    @IBOutlet weak var checkOffDuty: UIImageView!
    
    @IBOutlet weak var lblChoose: UILabel!
    //类字段
    var mainScroll:UIScrollView!
    var popDownList:PopDownList?
    var partDownList:PopDownList?
    var sleepcareMainViewModel:SleepcareMainViewModel?
    var choosepart:ChooseMainhouseController?
    var spinner:JHSpinnerView?
    var thread:NSThread?
    //支线程完成true
    var threadFlag:Bool = false
    
    //要显示的床位信息
    var ShowBedViews:Array<BedModel> = Array<BedModel>()
    
    //实时数据变化引起的主页面床位刷新标志
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
                self.uiWariningShow.hidden = false
                self.lblWarining.text = "有" + self.WarningSet.description + "条报警未处理,请点击查看"
            }
            else{
                self.uiWariningShow.hidden = true
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
        self.mainScroll.frame.origin.y = 200
        self.mainScroll.frame.size.height = UIScreen.mainScreen().bounds.height - 250
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
                self.presentViewController(DialogFrameController(nibName: "DialogFrame", userCode: bedModel.UserCode!), animated: true, completion: nil)
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
                //关闭openfire，置空session
                var xmppMsgManager:XmppMsgManager? = XmppMsgManager.GetInstance(timeout: XMPPStreamTimeoutNone)
                xmppMsgManager?.Close()
                Session.ClearSession()
                 LOGINFLAG = false
                
                TodoList.sharedInstance.removeItemAll()
                //关闭页面，退回到login页面
                self.dismissViewControllerAnimated(true, completion: nil)
                
        }
        
        //checkbox绑定手势操作
        var onbedTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "OnBedTouch")
        self.checkOnBed.addGestureRecognizer(onbedTap)
        var leavebedTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "LeaveBedTouch")
        self.checkLeaveBed.addGestureRecognizer(leavebedTap)
        var emptybedTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "EmptyBedTouch")
        self.checkEmptyBed.addGestureRecognizer(emptybedTap)
        var offdutyTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "OffDutyTouch")
        self.checkOffDuty.addGestureRecognizer(offdutyTap)
        var unnormalTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UnnormalTouch")
        self.checkUnnormal.addGestureRecognizer(unnormalTap)
        
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
        
        self.lblChoose.userInteractionEnabled = true
        var choosePart1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mainNameTouch")
        self.lblChoose.addGestureRecognizer(choosePart1)
        
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
        realtimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "SpnnerTimerFireMethod:", userInfo: nil, repeats:true);
        realtimer.fire()
    }
    
    func SpnnerTimerFireMethod(timer: NSTimer) {
        if (self.threadFlag && self.spinner != nil){
            self.mainScroll.userInteractionEnabled = true
            self.spinner!.dismiss()
            self.spinner = nil
            self.threadFlag = false
            realtimer.invalidate()
            
            self.ReloadMainScrollView()
        }
    }
    
    func ResetCheckbox(){
        if self.sleepcareMainViewModel != nil{
            self.sleepcareMainViewModel!.CheckUnnormal = true
            self.checkUnnormal.image = UIImage(named:"checkboxchoosed.png")
            self.sleepcareMainViewModel!.CheckOnBed = true
            self.checkOnBed.image = UIImage(named:"checkboxchoosed.png")
            self.sleepcareMainViewModel!.CheckLeaveBed = true
            self.checkLeaveBed.image = UIImage(named:"checkboxchoosed.png")
            self.sleepcareMainViewModel!.CheckEmptyBed = true
            self.checkEmptyBed.image = UIImage(named:"checkboxchoosed.png")
            self.sleepcareMainViewModel!.CheckOffDuty = true
            self.checkOffDuty.image = UIImage(named:"checkboxchoosed.png")
        }
    }
    
    
    //将床位信息显示到主页面上
    func ReloadMainScrollView(){
        while (self.mainScroll.subviews.count > 0 ){
            self.mainScroll.subviews[0].removeFromSuperview()
        }
        
        if (self.BedViews != nil && self.sleepcareMainViewModel != nil){
            //通过bedviews做删选，放入ShowBedViews数组
            self.ShowBedViews = Array<BedModel>()
            let onbedViews =  self.sleepcareMainViewModel!.CheckOnBed ? self.BedViews!.filter({$0.BedStatus == BedStatusType.onbed}) : Array<BedModel>()
            let leavebedViews = self.sleepcareMainViewModel!.CheckLeaveBed ?  self.BedViews!.filter({$0.BedStatus == BedStatusType.leavebed}) : Array<BedModel>()
            let emptybedViews = self.sleepcareMainViewModel!.CheckEmptyBed ? self.BedViews!.filter({$0.BedStatus == BedStatusType.emptybed}) : Array<BedModel>()
            let offdutyViews = self.sleepcareMainViewModel!.CheckOffDuty ? self.BedViews!.filter({$0.BedStatus == BedStatusType.offduty}) : Array<BedModel>()
            let unnormalViews = self.sleepcareMainViewModel!.CheckUnnormal ? self.BedViews!.filter({$0.BedStatus == BedStatusType.unnormal}) : Array<BedModel>()
            self.ShowBedViews = onbedViews + leavebedViews + emptybedViews + offdutyViews + unnormalViews
            
            //放入主页面中，实现分页
            let pageCount = (self.ShowBedViews.count / 8) + ((self.ShowBedViews.count % 8) > 0 ? 1 : 0)
            self.sleepcareMainViewModel?.PageCount = pageCount
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
        self.sleepcareMainViewModel!.CheckOnBed = !self.sleepcareMainViewModel!.CheckOnBed
        if self.sleepcareMainViewModel!.CheckOnBed{
            self.checkOnBed.image = UIImage(named:"checkboxchoosed.png")
        }
        else{
            self.checkOnBed.image = UIImage(named:"checkbox.png")
        }
        self.ReloadMainScrollView()
    }
    func LeaveBedTouch(){
        self.sleepcareMainViewModel!.CheckLeaveBed = !self.sleepcareMainViewModel!.CheckLeaveBed
        if self.sleepcareMainViewModel!.CheckLeaveBed{
            self.checkLeaveBed.image = UIImage(named:"checkboxchoosed.png")
        }
        else{
            self.checkLeaveBed.image = UIImage(named:"checkbox.png")
        }
        self.ReloadMainScrollView()
    }
    
    func EmptyBedTouch(){
        self.sleepcareMainViewModel!.CheckEmptyBed = !self.sleepcareMainViewModel!.CheckEmptyBed
        if self.sleepcareMainViewModel!.CheckEmptyBed{
            self.checkEmptyBed.image = UIImage(named:"checkboxchoosed.png")
        }
        else{
            self.checkEmptyBed.image = UIImage(named:"checkbox.png")
        }
       self.ReloadMainScrollView()
    }
    func OffDutyTouch(){
        self.sleepcareMainViewModel!.CheckOffDuty = !self.sleepcareMainViewModel!.CheckOffDuty
        if self.sleepcareMainViewModel!.CheckOffDuty{
            self.checkOffDuty.image = UIImage(named:"checkboxchoosed.png")
        }
        else{
            self.checkOffDuty.image = UIImage(named:"checkbox.png")
        }
       self.ReloadMainScrollView()
    }
    func UnnormalTouch(){
        self.sleepcareMainViewModel!.CheckUnnormal = !self.sleepcareMainViewModel!.CheckUnnormal
        if self.sleepcareMainViewModel!.CheckUnnormal{
            self.checkUnnormal.image = UIImage(named:"checkboxchoosed.png")
        }
        else{
            self.checkUnnormal.image = UIImage(named:"checkbox.png")
        }
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
