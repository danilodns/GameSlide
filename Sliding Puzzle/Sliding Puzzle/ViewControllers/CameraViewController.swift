//
//  CameraViewController.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-10.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    var imagePicker: UIImagePickerController! =  UIImagePickerController()
    private var row = 0
    private var col = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height {
            self.stackView.axis = .horizontal
        } else {
            self.stackView.axis = .vertical
        }
    }
    
    /// Buttons' selection
    ///
    /// Button tag:
    ///
    /// 0. Take Photo button
    /// 1. Choose Photo button
    @IBAction func buttonAction(_ sender: Any) {
        switch (sender as! UIButton).tag {
        case 1:
            imagePicker.sourceType = .photoLibrary
        default:
            imagePicker.sourceType = .camera
        }
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func startGame(_ sender: Any) {
        let alertVc = SizeAlert.shared.selectSizeGame { (rows, cols) in
            self.col = cols
            self.row = rows
            self.performSegue(withIdentifier: "segueToMainGame", sender: self)
        }
        self.present(alertVc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMainGame" {
            let vc = segue.destination as! GameViewController
            vc.apiManager = GameAPI(image: imageView.image!, rows: row, cols: col)
        }
    }
    
    
}
