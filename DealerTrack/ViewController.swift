//
//  XMCCameraViewController.swift
//  dojo-custom-camera
//
//  Created by David McGraw on 11/13/14.
//  Copyright (c) 2014 David McGraw. All rights reserved.
//

import UIKit
import AVFoundation

enum Status: Int {
    case Preview, Still, Error
}

class ViewController: UIViewController, XMCCameraDelegate {
    
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var vinoutput: UILabel!
    @IBOutlet weak var cameraCapture: UIButton!
    @IBOutlet weak var imageOut: UIImageView!
    
    var activityIndicator:UIActivityIndicatorView!
    
    var preview: AVCaptureVideoPreviewLayer?
    
    var camera: XMCCamera?
    var status: Status = .Preview
    var scanner: ScanningModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeCamera()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.establishVideoPreviewArea()
    }
    
    func initializeCamera() {
        self.camera = XMCCamera(sender: self)
        self.scanner = ScanningModel()
    }
    
    func establishVideoPreviewArea() {
        self.preview = AVCaptureVideoPreviewLayer(session: self.camera?.session)
        self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preview?.frame = self.cameraPreview.bounds
        self.cameraPreview.layer.addSublayer(self.preview!)
    }
    
    // MARK: Button Actions
    
    @IBAction func captureFrame(sender: AnyObject) {
        //addActivityIndicator()
        self.camera?.captureStillImage({ (image) -> Void in
                if image != nil {
                    let scaledImage = self.scanner!.scaleImage(image!, maxDimension: 600)
                    let croppedImage = self.scanner!.cropToBounds(scaledImage, width: 600, height: 100)
                    self.imageOut.image = croppedImage
                    //self.performImageRecognition(croppedImage)
                    
                    self.vinoutput.text = self.scanner!.scanBarcode(croppedImage) as String
                    
                }
                
            })
        
    }
    
    // MARK: Camera Delegate
    
    func cameraSessionConfigurationDidComplete() {
        self.camera?.startCamera()
    }
    
    func cameraSessionDidBegin() {
        
    }
    
    func cameraSessionDidStop() {
        
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    
    
    
    
    
    
}