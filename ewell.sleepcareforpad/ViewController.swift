//
//  ViewController.swift
//  QRReaderDemo
//
//  Created by Simon Ng on 23/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var scanView: UIView!
   
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var messageLabel:UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var alarmcode:String = ""
    var qrCode:String = ""
  //  var qrCodeFrameView:UIView?
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //---------- Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
    
        //--------- Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        //---------- Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       
            //self.scanView.layer.bounds
        
        //旋转横屏
        self.videoPreviewLayer?.transform = CATransform3DMakeRotation(CGFloat(M_PI/2), CGFloat(0), CGFloat(0), CGFloat(-1))
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = self.scanView.frame
       
        
       self.view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(lblScan)
        view.bringSubviewToFront(scanView)
        
        //--------------- Initialize QR Code Frame to highlight the QR code
//        qrCodeFrameView = UIView()
//        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
//        //当检测到二维码时，我们再改变它的尺寸，那么它就会变成一个绿色的方框了
//        qrCodeFrameView?.layer.borderWidth = 2
//        self.view.addSubview(qrCodeFrameView!)
//       self.view.bringSubviewToFront(qrCodeFrameView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //解析二维码
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection
        connection: AVCaptureConnection!) {
            
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects == nil || metadataObjects.count == 0 {
             //   qrCodeFrameView?.frame = CGRectZero
                messageLabel.text = "二维码识别中....."
                return
            }
            
            // Get the metadata object.如果是二维码，则获取边框并解析内容
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject =
                videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj
                    as AVMetadataMachineReadableCodeObject) as!
                AVMetadataMachineReadableCodeObject
          //     qrCodeFrameView?.frame = barCodeObject.bounds
          
                
                
                //获取解析的内容
                if metadataObj.stringValue != nil {
                    messageLabel.text = "二维码编号: " + metadataObj.stringValue
                    self.qrCode = metadataObj.stringValue
                    captureSession?.stopRunning()
                    
                    
                    self.CheckQRCode()
                }
            }
    }
    
    
    //验证当前扫描的二维码
    //返回false：弹窗提示错误
    //   true：显示处理表单。
    //         填写表单，成功提交后自动关闭本页面
    func CheckQRCode(){
        try{
            ({
               
            var alarmInfoByQR:AlarmInfoByScanQR = SleepCareBussiness().GetAlarmInfoByScancode(self.alarmcode,qrCode:self.qrCode,loginName:Session.GetSession()!.LoginUser!.LoginName)

            let handleTableView:HandleAlarmReportView = NSBundle.mainBundle().loadNibNamed("HandleAlarmReport", owner: self, options: nil).first as! HandleAlarmReportView
            handleTableView.frame = CGRectMake(0, 0, self.scanView.frame.width, self.scanView.frame.height)
                handleTableView.InitView(alarmInfoByQR.BedNumber, bedUserName: alarmInfoByQR.UserName, bedUserSex: alarmInfoByQR.UserSex, alarmType: alarmInfoByQR.SchemaCode,  alarmTime: alarmInfoByQR.AlarmTime, alarmContent: alarmInfoByQR.SchemaContent, alarmCode: alarmInfoByQR.AlarmCode,templates:alarmInfoByQR.Templates)
            handleTableView.parentController = self
            //移除扫描二维码，放入处理报警的表单
           
            self.scanView.addSubview(handleTableView)
            self.scanView.bringSubviewToFront(handleTableView)
                },
                catch: {ex in
                    //异常处理
                 //   handleException(ex,showDialog: true)
                let aa = SweetAlert(contentHeight: 300).showAlert((ex as NSException).reason!, subTitle:"提示", style: AlertStyle.None,buttonTitle:"确认",buttonColor: UIColor.colorFromRGB(0xAEDEF4), action:self.StartScan)
                
                },
                finally: {
                }
            )}
    
    }

    func StartScan(isOtherButton: Bool){
    captureSession?.startRunning()
    }

}

