//
//  ViewImageSelfie.swift
//  CustomCamera
//
//  Created by ahmad shiddiq on 15/07/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import Foundation
import UIKit

class ViewImageSelfie: UIViewController,mainView{
    
    var dataViewImage: UIImage!
    var dataImage: Data!
    
    let buttonOk: UIButton = {
        let btnOk = UIButton()
        btnOk.translatesAutoresizingMaskIntoConstraints = false
        btnOk.setTitle("Ok", for: .normal)
        btnOk.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btnOk.backgroundColor = UIColor.zrgb(red: 231, green: 9, blue: 31)
        btnOk.layer.cornerRadius = 8
        return btnOk
    }()
    
    let buttonReply: UIButton = {
        let btnreplay = UIButton()
        btnreplay.translatesAutoresizingMaskIntoConstraints = false
        btnreplay.setTitle("Replay", for: .normal)
        btnreplay.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btnreplay.setTitleColor(.red, for: .normal)
        return btnreplay
    }()
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .gray
        return imageview
    }()
    
    let titleImage: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "GAMBAR"
        titleImage.font = UIFont.boldSystemFont(ofSize: 22)
        titleImage.textColor = .darkGray
        titleImage.textAlignment = .center
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    let descriptImage: UILabel = {
        let decriptionimage = UILabel()
        decriptionimage.text = "Apakah Image yang yang sudah Jelas ?"
        decriptionimage.textColor = .darkGray
        decriptionimage.font = UIFont.systemFont(ofSize: 14)
        decriptionimage.translatesAutoresizingMaskIntoConstraints = false
        decriptionimage.textAlignment = .center
        return decriptionimage
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        
        imageView.image = dataViewImage
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        view.addSubview(titleImage)
        titleImage.topAnchor.constraint(equalTo: self.view!.safeAreaLayoutGuide.topAnchor , constant: 30).isActive = true
        titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(descriptImage)
        descriptImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        descriptImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(buttonReply)
        buttonReply.topAnchor.constraint(equalTo: descriptImage.bottomAnchor, constant: 16).isActive = true
        buttonReply.widthAnchor.constraint(equalToConstant: 180).isActive = true
        buttonReply.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonReply.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(buttonOk)
        buttonOk.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        buttonOk.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        buttonOk.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        buttonOk.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupAction() {
        buttonOk.addTarget(self, action: #selector(actionOk), for: .touchUpInside)
        buttonReply.addTarget(self, action: #selector(actionReplay), for: .touchUpInside)
    }
    
    @objc func actionOk(){
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @objc func actionReplay(){
        let newViewController = CustomCameraSelfieKtp()
        self.navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}
