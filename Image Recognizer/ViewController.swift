//
//  ViewController.swift
//  Image Recognizer
//
//  Created by ahmed khaled on 06/07/2023.
//

import UIKit
import CoreML
import ImageIO
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]) {
        imageView.image = (info[.originalImage] as! UIImage)
        picker.dismiss(animated: true)
        
        let pickedImage = CIImage(image: (info[.originalImage] as! UIImage))
        detectImage(pickedImage!)
    }
    
    func detectImage(_ pickedImage: CIImage){
        let model = try? VNCoreMLModel(for: MobileNetV2().model)
        
        let request = VNCoreMLRequest(model: model!) { (request, error) in
            let results = request.results as? [VNClassificationObservation]
            print(results?.first)
        }
        
        let handler = VNImageRequestHandler(ciImage: pickedImage)
        do{
            try handler.perform([request])
        }catch {
            print("error")
        }
    }
    
}
