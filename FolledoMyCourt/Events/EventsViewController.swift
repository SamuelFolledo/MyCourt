//
//  EventsViewController.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import AVKit

import Vision

class EventsViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .blue
        self.navigationController?.isNavigationBarHidden = true
        
//        view.addSubview(resultLabel)
        
    //setup camera
        captureSession.sessionPreset = .photo //so camera vivew is not full screen
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer) //add it to the view
        previewLayer.frame = view.frame //put it to full screen
        
        
    //now analyze images in video
        let dataOutput = AVCaptureVideoDataOutput() //u want to monitor the dataOutput everytime a frame is being captured by the camera
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue")) //make sure delegate conforms with the calss
        
        captureSession.addOutput(dataOutput)
        
//        let request = VNCoreMLRequest(model: <#T##VNCoreMLModel#>, completionHandler: <#T##VNRequestCompletionHandler?##VNRequestCompletionHandler?##(VNRequest, Error?) -> Void#>)
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>) //responsible for analyzing the images we see with a request
        
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) { //called everytime the camera is able to capture a frame
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return } //get the sampleBuffer first
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, error) in //its job is to pass it into the image request handler as an array
            
            //check error
            
            print("Finished request \(String(describing: finishedReq.results))")
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else {return} //is what the camera sees first
            
//            print("Identifier: \(firstObservation.identifier) + Confidence: \(firstObservation.confidence)") //the identifier and how confident
            DispatchQueue.main.async { //needed to avoid main thread error
                self.resultLabel.text = "\(firstObservation.identifier)  \(Int(firstObservation.confidence * 100))%"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request]) //cvPixelBuffer it can read the sampleBuffer
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    


}
