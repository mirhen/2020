//
//  CamViewController.swift
//  2020
//
//  Created by Miriam Hendler on 12/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import AVFoundation

class CamViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var wasteTypeView: UIView!
    @IBOutlet weak var wasteTypeImageView: UIImageView!
    @IBOutlet weak var wasteTypeLabel: UILabel!
    
    // Custom Variables
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // IBAction Functions
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.capturedImage.image = image
                    
                    //Test Imagga API
                    let imaggaAPI = ImaggaAPIWrapper()
                    imaggaAPI.getAllTags(image: image, callback: { (waste) in
                        self.previewPhotoUI()
                        if waste == .none {
                            self.wasteTypeImageView.image = nil
                            self.wasteTypeLabel.text = "not recyclable"
                        } else {
                            switch waste {
                            case .recycle:
                                self.wasteTypeLabel.text = "recyclable"
                            case .compost:
                                self.wasteTypeLabel.text = "compostable"
                            case .landfill:
                                self.wasteTypeLabel.text = "landfill"
                            default:
                                break
                            }
                        self.wasteTypeImageView.image = UIImage(named: "\(waste)_sym_icon")
                        }
                    })
                }
            })
        }
    }
    @IBAction func redoButtonPressed(_ sender: Any) {
        takePhotoUI()
    }
    
    // Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePhotoUI()
        setupCustomCamera()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    
    //MARK: Helper Functions
    
    func takePhotoUI() {
        redoButton.isHidden = true
        capturedImage.isHidden = true
        wasteTypeView.isHidden = true
        wasteTypeImageView.isHidden = true
        wasteTypeLabel.isHidden = true
        
        previewView.isHidden = false
        takePhotoButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    func previewPhotoUI() {
        redoButton.isHidden = false
        capturedImage.isHidden = false
        wasteTypeView.isHidden = false
        wasteTypeImageView.isHidden = false
        wasteTypeLabel.isHidden = false
        cancelButton.isHidden = false
        
        previewView.isHidden = true
        takePhotoButton.isHidden = true
    }
    
    func setupCustomCamera() {
        captureSession = AVCaptureSession()
        if UIImagePickerController.isSourceTypeAvailable(.camera)  {
            captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
            
            let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            var error: NSError?
            var input: AVCaptureDeviceInput!
            do {
                input = try AVCaptureDeviceInput(device: backCamera)
            } catch let error1 as NSError {
                error = error1
                input = nil
            }
            
            if error == nil && captureSession!.canAddInput(input) {
                captureSession!.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                if captureSession!.canAddOutput(stillImageOutput) {
                    captureSession!.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewView.layer.addSublayer(previewLayer!)
                    
                    captureSession!.startRunning()
                }
            }
        } else {
            print("no cam!")
        }
    }
    
    @IBAction func didPressTakeAnother(_ sender: AnyObject) {
        captureSession!.startRunning()
    }
    
}
