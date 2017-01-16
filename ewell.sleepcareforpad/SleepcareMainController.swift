//
//  SleepcareMainController.swift
//  ewell.sleepcareforpad
//
//  Created by djg on 15/9/23.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit


class SleepcareMainController: BaseViewController,UISearchBarDelegate,ChoosePartDelegate,SetAlarmWarningLabelDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    //界面控件
    //   @IBOutlet weak var curPager: Pager! JumpPageDelegate
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
    //页数
    @IBOutlet weak var lblCurrentPage: UILabel!
    @IBOutlet weak var lblMaxPage: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    
    @IBAction func UnwindToMainController(segue:UIStoryboardSegue){
        
    }
    @IBAction func UnwindToMainController2(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func UnwindToMainController3(segue:UIStoryboardSegue){
        
    }
    @IBAction func UnwindToMainController4(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func UnwindAlarmQuery(segue:UIStoryboardSegue){
        
        //       self.WarningSet = AlarmHelper.GetAlarmInstance().WarningList.count
    }
    
    
    //类字段
    var popDownList:PopDownList?
    var partDownList:PopDownList?
    var sleepcareMainViewModel:SleepcareMainViewModel?
    var choosepart:ChooseMainhouseController?
    var spinner:JHSpinnerView?
    var thread:NSThread!
    var isOpenAlarm:Bool = false
    // 刷新按钮支线程运行结束标志：true运行结束，false未结束或未运行
    var threadFlag:Bool = false
    var searchText:String = ""
    
    //要显示的床位信息
    var ShowBedViews:Array<BedModel> = Array<BedModel>()
    
    //在离床状态变化引起的主页面床位刷新标志
    var RefreshFlag:Bool = false{
        didSet{
            if (RefreshFlag && self.searchText == "")
            {
               self.ReloadMainScrollView()
            }
        }
    }
    
    var MaxPageCount:Int=0{
        didSet{
            self.lblMaxPage.text = "共" + String(MaxPageCount) + "页"
            
        }
        
    }
    
    var CurrentPageCount:Int=0{
        didSet{
            self.lblCurrentPage.text = "第" + String(CurrentPageCount) + "页"
        }
        
    }
    
    //当前科室下所有床位信息
    var BedViews:Array<BedModel>?
    
    var WarningSet:Int = 0{
        didSet{
            if(self.WarningSet > 0){
                
                self.lblWarining.text = "有" + self.WarningSet.description + "条报警未处理"
            
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
    
    //--------------------------初始化---------------------
    override func viewDidAppear(animated: Bool) {
        //刷新页面报警数
        self.WarningSet = AlarmHelper.GetAlarmInstance().WarningList.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.backgroundColor = UIColor.clearColor()
        var cellNib =  UINib(nibName: "SleepCareCollectionViewCell", bundle: nil)
        self.mainCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "bedcell")
        
        
        //去掉搜索按钮背景
        for(var i = 0 ; i < self.search.subviews[0].subviews.count; i++) {
            if(self.search.subviews[0].subviews[i].isKindOfClass(NSClassFromString("UISearchBarBackground"))){
                self.search.subviews[0].subviews[i].removeFromSuperview()
            }
        }
        self.search.delegate = self
        
        
        //若没有选择记住密码，则清空登录页面里的输入信息
        if self.clearlogininfoDelegate != nil{
            self.clearlogininfoDelegate!.ClearLoginInfo()
        }
        
        //页面元素绑定和创建
        rac_setting()
        
        //若curpartcode为空，则弹窗让用户选择
        if Session.GetSession() != nil{
            if (Session.GetSession()!.CurPartCode == ""){
                self.mainNameTouch()
            }
            else{
                //远程通知
                OpenNotice()
                //开启报警
                AlarmHelper.GetAlarmInstance().setalarmlabelDelegate = self
                AlarmHelper.GetAlarmInstance().BeginWaringAttention()
                self.isOpenAlarm = true
            }
            
        }
        
        self.ReloadMainScrollView()
    }
    
    
    //--------------------------------属性绑定--------------------------
    func rac_setting(){
        sleepcareMainViewModel = SleepcareMainViewModel()
        sleepcareMainViewModel?.controller = self
        RACObserve(self.sleepcareMainViewModel, "BedModelList") ~> RAC(self, "BedViews")
        //   RACObserve(self.sleepcareMainViewModel, "PageCount") ~> RAC(self, "MaxPageCount")
        
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
                AlarmHelper.GetAlarmInstance().CloseWaringAttention()
                CloseNotice()
                //置空session，恢复登录前配置
                LOGINFLAG = false
                Session.ClearSession()
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
        var showalarmQuery:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ShowAlarmQuery")
        self.lblWarining .addGestureRecognizer(showalarmQuery)
        
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
    
    //--------------------------------刷新操作-----------------------
    //点击刷新后的业务
    @IBAction func Refresh(){
        if Session.GetSession()!.CurPartCode != ""{
            if self.spinner == nil{
                self.spinner  = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.whiteColor(), overlay:.Custom(CGRect(x:0,y:0,width:Int(UIScreen.mainScreen().bounds.width),height:Int(UIScreen.mainScreen().bounds.height)), CGFloat(0.0)), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.9))
                
                self.mainCollectionView.userInteractionEnabled = false
            }
            
            //清空搜索内容
            if self.search.text != ""{
                self.search.text = ""
                self.searchText = ""
            }
            /*定时器，检查支线程：载入床位信息 是否完成
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
            self.threadFlag = true
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
            self.threadFlag = false
            realtimer.invalidate()
           
            self.ReloadMainScrollView()
            
            self.mainCollectionView.userInteractionEnabled = true
            self.spinner!.dismiss()
            self.spinner = nil
        }
    }
    
    //恢复全选
    func ResetCheckbox(){
        self.checkEmptyBed.selected = true
        self.checkOnBed.selected = true
        self.checkLeaveBed.selected = true
        self.checkUnnormal.selected = true
        self.checkOffDuty.selected = true
        
    }
    
    
    //---------------------------过滤删选显示的页面---------------------------
    func FilterBedViews()-> Array<BedModel>{
        var tempBedList = Array<BedModel>()
        let onbedViews:Array<BedModel> = self.checkOnBed.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.onbed}) : Array<BedModel>()
        let leavebedViews:Array<BedModel> = self.checkLeaveBed.selected ?  self.BedViews!.filter({$0.BedStatus == BedStatusType.leavebed}) : Array<BedModel>()
        let emptybedViews:Array<BedModel> = self.checkEmptyBed.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.emptybed}) : Array<BedModel>()
        let offdutyViews:Array<BedModel> = self.checkOffDuty.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.offduty}) : Array<BedModel>()
        let unnormalViews:Array<BedModel> = self.checkUnnormal.selected ? self.BedViews!.filter({$0.BedStatus == BedStatusType.unnormal}) : Array<BedModel>()
        tempBedList = onbedViews + leavebedViews + emptybedViews + offdutyViews + unnormalViews
        return tempBedList
        
    }
    
    //将床位信息显示到主页面上
    func ReloadMainScrollView(){
        if (self.BedViews != nil && self.sleepcareMainViewModel != nil){
            //通过bedviews做删选，放入ShowBedViews数组
            self.ShowBedViews = self.FilterBedViews()
            
            //放入主页面中，实现分页
            let pageCount:Int = (self.ShowBedViews.count / 8) + ((self.ShowBedViews.count % 8) > 0 ? 1 : 0)
            self.MaxPageCount = pageCount
            
            //  self.sleepcareMainViewModel?.PageCount = pageCount
            //查询后可能总页数<当前页数,则需要更新当前页数
            if self.CurrentPageCount > pageCount{
                self.CurrentPageCount = pageCount
            }
            
            //0
            if pageCount == 0{
                self.CurrentPageCount = 0
            }
            if (pageCount>0 && self.CurrentPageCount == 0){
                self.CurrentPageCount = 1
            }
            
            self.mainCollectionView.reloadData()
        }
    }
    
    //---------------------------页面点击，滑动操作-------------------
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
    
    
    //查询按钮事件,根据本地的showbedlist进行查询，不掉用服务器接口
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        self.searchText = searchText
        let searchResult:Array<BedModel> = self.sleepcareMainViewModel!.SearchByBedOrRoomFromLocal(searchText,localBedViews:self.FilterBedViews())
        self.ShowBedViews = searchResult
        
        let pageCount:Int = (self.ShowBedViews.count / 8) + ((self.ShowBedViews.count % 8) > 0 ? 1 : 0)
        //查询后可能总页数<当前页数,则需要更新当前页数
        self.MaxPageCount = pageCount
        if self.CurrentPageCount > pageCount{
            self.CurrentPageCount = pageCount
        }
        //0页数的特殊情况
        if pageCount == 0{
            self.CurrentPageCount = 0
        }
        if (pageCount>0 && self.CurrentPageCount == 0){
            self.CurrentPageCount = 1
        }
        
        self.mainCollectionView.reloadData()
    }
    
    //床位点击事件
    func BedSelected(bedModel:BedModel){
        try {
            ({
                
                if bedModel.UserCode != nil{
                    Session.GetSession()!.CurUserCode = bedModel.UserCode!
                    Session.GetSession()!.CurUserName = bedModel.UserName!
                     Session.GetSession()!.CurEquipmentID = bedModel.EquipmentID
                    
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
    
    
    
    //选择某科室代理
    func ChoosePart(partcode:String,partname:String,mainname:String) {
        //恢复全选
        self.ResetCheckbox()
        //curpartcode改变，重开远程通知
        OpenNotice()
        //开启报警
        if !self.isOpenAlarm{
            
            AlarmHelper.GetAlarmInstance().setalarmlabelDelegate = self
            AlarmHelper.GetAlarmInstance().BeginWaringAttention()
        }
        
        //更新标题
        self.lblMainName.text = mainname + "—" + partname
        //刷新床位信息
        self.sleepcareMainViewModel?.SearchByBedOrRoom("")
        self.ReloadMainScrollView()
    }
    
    //点击报警信息提示
    func ShowAlarmQuery(){
        self.performSegueWithIdentifier("AlarmQuery", sender: self)
        
    }
    
    //左右滑动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page = Int(scrollView.contentOffset.x / (scrollView.frame.width)) + 1
        if ((page == self.MaxPageCount - 1) && (scrollView.contentOffset.x % (scrollView.frame.width)>0)){
            page += 1
        }
        
        if self.MaxPageCount == 0{
            self.CurrentPageCount = 0
        }
        else if (self.CurrentPageCount != page ){
            self.CurrentPageCount = page
        }
        
    }
    
    
    //--------------------------床位信息显示collection view------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.ShowBedViews.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        
        var cell:SleepCareCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("bedcell", forIndexPath: indexPath) as! SleepCareCollectionViewCell
        
        cell.rebuilderUserInterface(self.ShowBedViews[indexPath.item])
        
        return cell
        
    }
    
    func collectionView(collectionView:UICollectionView,shouldSelecItemAtIndexPath indexPath:NSIndexPath)->Bool{
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        self.BedSelected(self.ShowBedViews[indexPath.item])
        
    }
    
    
    //----------------------实现各类代理--------------------------
    //选中查询类型
    func ChoosedItem(downListModel:DownListModel){
        self.sleepcareMainViewModel?.ChoosedSearchType = downListModel.value
    }
    
    //设置alarmlabel代理
    func SetAlarmWarningLabel(count: Int) {
        self.WarningSet = count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



protocol ClearLoginInfoDelegate{
    func ClearLoginInfo()
}
