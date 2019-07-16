//
//  ViewMain.swift
//  CustomCamera
//
//  Created by ahmad shiddiq on 15/07/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import Foundation
import UIKit

class ViewMain: UIViewController, mainView {
    let titleImage: UILabel = {
        let titleImage = UILabel()
        titleImage.text = "GAMBAR KTP DAN SELFIE"
        titleImage.font = UIFont.boldSystemFont(ofSize: 22)
        titleImage.textColor = .red
        titleImage.textAlignment = .center
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        return titleImage
    }()
    
    let buttonKtp: UIButton = {
        let btnktp = UIButton()
        btnktp.translatesAutoresizingMaskIntoConstraints = false
        btnktp.setTitle("Foto KTP", for: .normal)
        btnktp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btnktp.backgroundColor = UIColor.zrgb(red: 231, green: 9, blue: 31)
        btnktp.layer.cornerRadius = 8
        return btnktp
    }()
    
    let buttonselfie: UIButton = {
        let buttonselfie = UIButton()
        buttonselfie.translatesAutoresizingMaskIntoConstraints = false
        buttonselfie.setTitle("Foto Selfie KTP", for: .normal)
        buttonselfie.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonselfie.backgroundColor = UIColor.zrgb(red: 231, green: 9, blue: 31)
        buttonselfie.layer.cornerRadius = 8
        return buttonselfie
    }()

    let buttonKeluar: UIButton = {
        let buttonKeluar = UIButton()
        buttonKeluar.translatesAutoresizingMaskIntoConstraints = false
        buttonKeluar.setTitle("Keluar", for: .normal)
        buttonKeluar.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonKeluar.backgroundColor = UIColor.zrgb(red: 231, green: 9, blue: 31)
        buttonKeluar.layer.cornerRadius = 8
        return buttonKeluar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        
        buttonKeluar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonKeluar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        buttonKtp.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonKtp.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        buttonselfie.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonselfie.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        let stackMenu = UIStackView()
        stackMenu.axis = .vertical
        stackMenu.distribution = .equalSpacing
        stackMenu.alignment = .center
        stackMenu.spacing = 16
        stackMenu.translatesAutoresizingMaskIntoConstraints = false
        
        stackMenu.addArrangedSubview(buttonKtp)
        stackMenu.addArrangedSubview(buttonselfie)
        stackMenu.addArrangedSubview(buttonKeluar)

        view.addSubview(stackMenu)
        stackMenu.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackMenu.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        view.addSubview(titleImage)
        titleImage.bottomAnchor.constraint(equalTo: stackMenu.topAnchor, constant: -20).isActive = true
        titleImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setupAction() {
        buttonKeluar.addTarget(self, action: #selector(actionKeluar), for: .touchUpInside)
        buttonselfie.addTarget(self, action: #selector(actionSelfie), for: .touchUpInside)
        buttonKtp.addTarget(self, action: #selector(actionKtp), for: .touchUpInside)
    }
    
    @objc func actionKeluar(){
       var dialogMessage = UIAlertController(title: "Peringatan", message: "Anda yakin ingin keluar aplikasi ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            exit(0)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc func actionSelfie(){
        let newViewController = CustomCameraSelfieKtp()
        self.navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func actionKtp(){
        let newsViewController = CustomCameraKtp()
        self.navigationController?.pushViewController(newsViewController, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        
    }
}
