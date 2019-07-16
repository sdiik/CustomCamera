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

class CustomCameraKtp: UIViewController, mainView, AVCapturePhotoCaptureDelegate{
    
    var captureSession: AVCaptureSession!
    var input: AVCaptureDeviceInput!
    var output: AVCapturePhotoOutput!
    var videoPreviewLayout: AVCaptureVideoPreviewLayer!
    var chooseCamera: AVCaptureDevice!
    
    var cropImageRectCorner = UIRectCorner()
    var cropImageRect = CGRect()
    
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
        self.title = "Camera KTP"
        
        chooseCamera = cameraWithPosition(position: .back)
        
        setupView()
        setupAction()
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
        }catch let error{
            print("----- Error Unable to initialize back camera : \(error.localizedDescription)")
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else{ return }
        
        let orgImage: UIImage = UIImage(data: imageData)!
        let originalSize : CGSize
        let visibleLayerFrame = cropImageRect
        
        let metaRect  = (videoPreviewLayout?.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame)) ?? CGRect.zero
        
        if (orgImage.imageOrientation == .left || orgImage.imageOrientation == .right){
            originalSize = CGSize(width: orgImage.size.height, height: orgImage.size.width)
        }else{
            originalSize = orgImage.size
        }
        
        let cropRect: CGRect = CGRect(x: metaRect.origin.x * originalSize.width, y: metaRect.origin.y * originalSize.height, width:  metaRect.size.width * originalSize.width, height: metaRect.size.height * originalSize.height).integral
        
        if let finalCgImage = orgImage.cgImage?.cropping(to: cropRect){
            let image = UIImage(cgImage: finalCgImage, scale: 1.0, orientation: orgImage.imageOrientation)
            dataViewImage = image
            dataImage = image.pngData()
        }
        
        let newsViewController = ViewImageKtp()
        newsViewController.dataImage = dataImage
        newsViewController.dataViewImage = dataViewImage
        self.navigationController?.pushViewController(newsViewController, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupLivePreview(){
        let imageView = setupGuideLineArea()
        let viewAtas = UIView()
        let viewBawah = UIView()
        let viewKanan = UIView()
        let viewKiri = UIView()
        
        videoPreviewLayout = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayout.videoGravity = .resizeAspectFill
        videoPreviewLayout.connection?.videoOrientation = .portrait
        viewCapture.layer.addSublayer(videoPreviewLayout)
        
        viewCapture.addSubview(imageView)
        
        viewCapture.addSubview(viewAtas)
        viewAtas.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 4).isActive = true
        viewAtas.trailingAnchor.constraint(equalTo: viewCapture.trailingAnchor, constant: 0).isActive = true
        viewAtas.leadingAnchor.constraint(equalTo: viewCapture.leadingAnchor, constant: 0).isActive = true
        viewAtas.topAnchor.constraint(equalTo: viewCapture.topAnchor, constant: 0).isActive = true
        viewAtas.translatesAutoresizingMaskIntoConstraints = false
        viewAtas.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        viewCapture.addSubview(viewBawah)
        viewBawah.bottomAnchor.constraint(equalTo: viewCapture.bottomAnchor, constant: 0).isActive = true
        viewBawah.trailingAnchor.constraint(equalTo: viewCapture.trailingAnchor, constant: 0).isActive = true
        viewBawah.leadingAnchor.constraint(equalTo: viewCapture.leadingAnchor, constant: 0).isActive = true
        viewBawah.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -4).isActive = true
        viewBawah.translatesAutoresizingMaskIntoConstraints = false
        viewBawah.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        viewCapture.addSubview(viewKanan)
        viewKanan.bottomAnchor.constraint(equalTo:  viewBawah.topAnchor, constant: 0).isActive = true
        viewKanan.trailingAnchor.constraint(equalTo: viewCapture.trailingAnchor, constant: 0).isActive = true
        viewKanan.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4).isActive = true
        viewKanan.topAnchor.constraint(equalTo: viewAtas.bottomAnchor, constant: 0).isActive = true
        viewKanan.translatesAutoresizingMaskIntoConstraints = false
        viewKanan.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        viewCapture.addSubview(viewKiri)
        viewKiri.bottomAnchor.constraint(equalTo: viewBawah.topAnchor, constant: 0).isActive = true
        viewKiri.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4).isActive = true
        viewKiri.leadingAnchor.constraint(equalTo: viewCapture.leadingAnchor, constant: 0).isActive = true
        viewKiri.topAnchor.constraint(equalTo: viewAtas.bottomAnchor, constant: 0).isActive = true
        viewKiri.translatesAutoresizingMaskIntoConstraints = false
        viewKiri.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        cropImageRect = imageView.frame
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.sync {
                self.videoPreviewLayout.frame = self.viewCapture.bounds
            }
        }
    }
    
    func setupGuideLineArea() -> UIImageView{
        let edgeInsert: UIEdgeInsets = UIEdgeInsets.init(top: 22, left: 22, bottom: 22, right: 22)
        
        let resizableImage = (UIImage(named: "guideCard")?.resizableImage(withCapInsets: edgeInsert, resizingMode: .stretch))!
        let imageSize = CGSize(width: viewCapture.frame.size.width-50, height: 200)
        cropImageRectCorner = [.allCorners]
        
        let imageView = UIImageView(image: resizableImage)
        imageView.frame.size = imageSize
        imageView.center = CGPoint(x: viewCapture.bounds.midX, y: viewCapture.bounds.midY)
        return imageView
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
        viewCapture.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewCapture.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewCapture.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewCapture.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        btnrotatecamera.addTarget(self, action: #selector(rotateKtp), for: .touchUpInside)
        btntakeImageView.addTarget(self, action: #selector(takeImageViewKtp), for: .touchUpInside)
        
        let takeImage = UITapGestureRecognizer(target: self, action: #selector(takeImageViewKtp))
        takeImageView.addGestureRecognizer(takeImage)
        takeImageView.isUserInteractionEnabled = true
    }
    
    @objc func takeImageViewKtp(){
        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        output.capturePhoto(with: setting, delegate: self)
    }
    
    @objc func rotateKtp(){
        swapCamera()
    }
    
    
}
