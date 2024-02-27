//
//  CameraViewController.swift
//  Covid19_Tracker
//
//  Created by Hasara Yaddehige on 6/3/20.
//  Copyright © 2020 Harshana Rathnamalala. All rights reserved.
//

import UIKit
import AVFoundation

protocol recieve :class{
    func passDataBack(data: String)
}

protocol recieve1 :class{
    func passDataBack1(data: String)
}


class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
    var delegate: recieve!
    var delegate1: recieve1!
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var greenbar: UIView!
    @IBOutlet weak var barcode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            } else {
                self.failed()
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspect
            self.view.layer.addSublayer(self.avPreviewLayer)
         
            DispatchQueue.global(qos: .userInitiated).async{
                self.avCaptureSession.startRunning()
            }
            
            DispatchQueue.main.async {
                self.avPreviewLayer.frame = self.view.bounds
                self.view.bringSubviewToFront(self.greenbar)
            }
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            barcode.text = found(code: stringValue)
            
                   }
        
        dismiss(animated: true)
        
    }
    
    func found(code: String)->String {
       
        return code
    }
    var code = ""
    @IBAction func save_tapped(_ sender: Any) {
       
        code = barcode.text!
        self.delegate?.passDataBack(data: code)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func check_tapped(_ sender: Any) {
        code = barcode.text!
        self.delegate1?.passDataBack1(data: code)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
