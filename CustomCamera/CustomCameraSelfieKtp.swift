//
//  CustomCameraKtp.swift
//  CustomCamera
//
//  Created by ahmad shiddiq on 14/07/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CustomCameraSelfieKtp: UIViewController, mainView, AVCapturePhotoCaptureDelegate{
    
    var captureSession: AVCaptureSession!
    var input: AVCaptureDeviceInput!
    var output: AVCapturePhotoOutput!
    var videoPreviewLayout: AVCaptureVideoPreviewLayer!
    var chooseCamera: AVCaptureDevice!
    
    var dataViewImage: UIImage!
    var dataImage: Data!
    
    let viewCapture: UIView = {
        let viewCapture = UIView()
        viewCapture.backgroundColor = UIColor.zrgb(red: 216, green: 216, blue: 216)
        viewCapture.clipsToBounds = true
        viewCapture.translatesAutoresizingMaskIntoConstraints = false
        return viewCapture
    }()
    
    let takeImageView: UIImageView = {
        let takeImage = UIImageView()
        takeImage.image = UIImage(named: "round")
        takeImage.tintColor = .white
        takeImage.backgroundColor = .clear
        takeImage.clipsToBounds = true
        takeImage.translatesAutoresizingMaskIntoConstraints = false
        takeImage.contentMode = .scaleAspectFit
        return takeImage
    }()
    
    let imageGuide: UIImageView = {
        let imageGuide = UIImageView()
        imageGuide.translatesAutoresizingMaskIntoConstraints = false
        imageGuide.backgroundColor = .clear
        imageGuide.image = UIImage(named: "layout_guide")
        imageGuide.contentMode = .scaleAspectFill
        return imageGuide
    }()
    
    let btntakeImageView: UIButton = {
        let btntakeImage = UIButton()
        btntakeImage.translatesAutoresizingMaskIntoConstraints = false
        btntakeImage.backgroundColor = .white
        btntakeImage.layer.cornerRadius = 30
        btntakeImage.layer.masksToBounds = true
        return btntakeImage
    }()
    
    let btnrotatecamera: UIButton = {
        let btnrotate = UIButton()
        btnrotate.translatesAutoresizingMaskIntoConstraints = false
        btnrotate.contentMode = .center
        btnrotate.clipsToBounds = true
        btnrotate.imageView?.contentMode = .scaleAspectFit
        btnrotate.setBackgroundImage(UIImage(named: "rotate"), for: .normal)
        return btnrotate
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = .black
        self.title = "Camera Selfie KTP"
        
       
        setupView()
        setupAction()
        
         chooseCamera = cameraWithPosition(position: .back)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        do{
            let input = try AVCaptureDeviceInput(device: chooseCamera)
            output = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(output){
                captureSession.addInput(input)
                captureSession.addOutput(output)
                setupLivePreview()
            }
            
        }catch let error {
            print("------ Error  Unable to initialize back camera :\(error.localizedDescription)")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        dataImage = imageData
        dataViewImage = UIImage(data: dataImage)
        dataViewImage.jpegData(compressionQuality: 0.5)
        
        let newsViewController = ViewImageSelfie()
        newsViewController.dataImage = dataImage
        newsViewController.dataViewImage = dataViewImage
        self.navigationController?.pushViewController(newsViewController, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupLivePreview(){
        videoPreviewLayout = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayout.videoGravity = .resizeAspectFill
        videoPreviewLayout.connection?.videoOrientation = .portrait
        viewCapture.layer.addSublayer(videoPreviewLayout)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.sync {
                self.videoPreviewLayout.frame = self.viewCapture.bounds
            }
        }
    }
    
    fileprivate func swapCamera(){
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration()}
        
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        }else{
            newDevice = captureDevice(with: .back)
        }
        
        var deviceInput: AVCaptureDeviceInput!
        do{
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        }catch let error{
            print("------- error Device Input ----->", error.localizedDescription)
            return
        }
        
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position)-> AVCaptureDevice?{
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        for device in discoverySession.devices{
            if device.position == position{
                return device
            }
        }
        return nil
    }
    
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    
    func setupView(){
        self.view.backgroundColor = .white
        view.addSubview(viewCapture)
        viewCapture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        viewCapture.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewCapture.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewCapture.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(imageGuide)
        imageGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(takeImageView)
        takeImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        takeImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        takeImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        takeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        takeImageView.addSubview(btntakeImageView)
        btntakeImageView.heightAnchor.constraint(equalTo: takeImageView.heightAnchor, constant: -30).isActive = true
        btntakeImageView.widthAnchor.constraint(equalTo: takeImageView.widthAnchor, constant: -30).isActive = true
        btntakeImageView.centerXAnchor.constraint(equalTo: takeImageView.centerXAnchor).isActive = true
        btntakeImageView.centerYAnchor.constraint(equalTo: takeImageView.centerYAnchor).isActive = true
        
        view.addSubview(btnrotatecamera)
        btnrotatecamera.heightAnchor.constraint(equalToConstant: 60).isActive = true
        btnrotatecamera.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btnrotatecamera.centerYAnchor.constraint(equalTo: takeImageView.centerYAnchor).isActive = true
        btnrotatecamera.leadingAnchor.constraint(equalTo: takeImageView.trailingAnchor, constant: 30).isActive = true
    }
    
    func setupAction(){
        btnrotatecamera.addTarget(self, action: #selector(rotateSelfie), for: .touchUpInside)
        btntakeImageView.addTarget(self, action: #selector(takeImageViewSelfie), for: .touchUpInside)
        
        let takeImage = UITapGestureRecognizer(target: self, action: #selector(takeImageViewSelfie))
        takeImageView.addGestureRecognizer(takeImage)
        takeImageView.isUserInteractionEnabled = true
    }
    
    @objc func takeImageViewSelfie(){
        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        output.capturePhoto(with: setting, delegate: self)
    }
    
    @objc func rotateSelfie(){
        swapCamera()
    }
}
