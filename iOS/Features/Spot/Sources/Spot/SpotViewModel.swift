//
//  CameraViewModel.swift
//  Spot
//
//  Created by 전민건 on 11/22/23.
//

import AVFoundation

import MSLogger

protocol ShotDelegate: AnyObject {
 
    func update(imageData: Data?)
    
}

final class SpotViewModel: NSObject {
    
    // MARK: - Type: SwapMode
    
    enum SwapMode {
        case front
        case back
        
        var device: AVCaptureDevice? {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                       for: .video,
                                                       position: self == .front ? .front : .back) else {
                MSLogger.make(category: .camera).error("해당 위치의 camera device가 존재하지 않습니다.")
                return nil
            }
            return device
        }
        
        var input: AVCaptureDeviceInput? {
            guard let device = self.device,
                  let input = try? AVCaptureDeviceInput(device: device) else {
                MSLogger.make(category: .camera).debug("해당 device로 input을 생성할 수 없습니다.")
                return nil
            }
            return input
        }
        
    }
    
    // MARK: - Properties
    
    weak var delegate: ShotDelegate?
    var swapMode: SwapMode = .back {
        didSet {
            self.configureSwapMode()
        }
    }
    let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    let session = AVCaptureSession()
    var input: AVCaptureDeviceInput?
    let output = AVCapturePhotoOutput()
    
}

// MARK: - Interface

internal extension SpotViewModel {
    
    func preset(screen: Positionable) {
        self.presetCamera(screen: screen)
    }
    
    func shot() {
        let settings = AVCapturePhotoSettings()
        self.output.capturePhoto(with: settings, delegate: self)
    }
    
    func swap() {
        self.swapMode = self.swapMode == .back ? .front : .back
    }
    
    func gallery() {
        guard let input = self.swapMode.input else {
            return
        }
        self.session.beginConfiguration()
        self.session.inputs.forEach { input in
            self.session.removeInput(input)
        }
        self.session.addInput(input)
        self.session.commitConfiguration()
    }
    
    func stopCamera() {
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
        }
    }
    
    func startCamera() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
}

// MARK: - Actions: Camera

private extension SpotViewModel {
    
    func presetCamera(screen: Positionable) {
        guard let input = self.swapMode.input else { return }
        self.session.sessionPreset = .photo
        self.session.addInput(input)
        self.session.addOutput(self.output)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        
        self.startCamera()
        DispatchQueue.main.async {
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = screen.bounds
            screen.layer.addSublayer(previewLayer)
        }
    }
    
    func configureSwapMode() {
        guard let input = self.swapMode.input else {
            return
        }
        self.session.beginConfiguration()
        self.session.inputs.forEach {
            self.session.removeInput($0)
        }
        self.session.addInput(input)
        self.session.commitConfiguration()
    }
    
}

// MARK: - Delegate: Camera

extension SpotViewModel: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            MSLogger.make(category: .camera).debug("image Data가 없습니다.")
            return
        }
        self.stopCamera()
        self.delegate?.update(imageData: imageData)
    }
    
}

