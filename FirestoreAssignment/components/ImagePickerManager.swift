//
//  ImagePickerManager.swift
//  FirestoreAssignment
//
//  Created by AcePlus Admin on 10/26/19.
//  Copyright © 2019 SLH. All rights reserved.
//
import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var picker = UIImagePickerController();
	var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
	var viewController: UIViewController?
	var pickImageCallback : ((UIImage) -> ())?;
	
	override init(){
		super.init()
	}
	
	func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
		pickImageCallback = callback;
		self.viewController = viewController;
		
		let cameraAction = UIAlertAction(title: "Camera", style: .default){
			UIAlertAction in
			self.openCamera()
		}
		let gallaryAction = UIAlertAction(title: "Gallary", style: .default){
			UIAlertAction in
			self.openGallery()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
			UIAlertAction in
		}
		
		// Add the actions
		picker.delegate = self
		alert.addAction(cameraAction)
		alert.addAction(gallaryAction)
		alert.addAction(cancelAction)
		alert.popoverPresentationController?.sourceView = self.viewController!.view
		viewController.present(alert, animated: true, completion: nil)
	}
	
	func openCamera(){
		alert.dismiss(animated: true, completion: nil)
		if(UIImagePickerController .isSourceTypeAvailable(.camera)){
			picker.sourceType = .camera
			self.viewController!.present(picker, animated: true, completion: nil)
		} else {
			let alertWarning = UIAlertController.init(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertController.Style.alert)
			alertWarning.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
			viewController?.present(alertWarning, animated: true, completion: nil)
		}
	}
	
	func openGallery(){
		alert.dismiss(animated: true, completion: nil)
		picker.sourceType = .photoLibrary
		self.viewController!.present(picker, animated: true, completion: nil)
	}
	
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	// For Swift 4.2
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[.originalImage] as? UIImage else {
			fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
		}
		pickImageCallback?(image)
	}
	
	
	
	@objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
	}
	
}
