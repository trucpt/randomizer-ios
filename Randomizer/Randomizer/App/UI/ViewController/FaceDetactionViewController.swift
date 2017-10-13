//
//  FaceDetactionViewController.swift
//  Randomizer
//
//  Created by nguyen ha on 10/11/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FaceDetactionViewController: PrimaryViewController {

    @IBOutlet weak var facesImageView: UIImageView!
    var facesImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onClickFaceDetection(_ sender: Any) {
        // Check Camera Permission
        let mediaType: String = AVMediaType.video.rawValue
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: mediaType))
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted {
            
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                //imagePickerController.sourceType = .camera
            //} else {
                imagePickerController.sourceType = .savedPhotosAlbum
            }
            imagePickerController.mediaTypes = ["public.image"]
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func analyze() {
        guard let facesCIImage = CIImage(image: facesImage!)
            else { fatalError("can't create CIImage from UIImage") }
        let detectFaceRequest: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        let detectFaceRequestHandler = VNImageRequestHandler(ciImage: facesCIImage, options: [:])
        
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
        } catch {
            print(error)
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation]
            else { fatalError("unexpected result type from VNDetectFaceRectanglesRequest") }
        
        self.addShapesToFace(forObservations: observations)
    }
    
    func addShapesToFace(forObservations observations: [VNFaceObservation]) {
        
        if let sublayers = facesImageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let imageRect = AVMakeRect(aspectRatio: (facesImage?.size)!, insideRect: facesImageView.bounds)
        
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * imageRect.width
            let h = observation.boundingBox.size.height * imageRect.height
            let x = observation.boundingBox.origin.x * imageRect.width
            let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - h
            
            print("----")
            print("W: ", w)
            print("H: ", h)
            print("X: ", x)
            print("Y: ", y)
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: w, height: h)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3
            return layer
        }
        
        for layer in layers {
            facesImageView.layer.addSublayer(layer)
        }
    }
}

extension FaceDetactionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.close()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        facesImage = image
        facesImageView.image = image
        analyze()
        picker.close()
    }
    
}
