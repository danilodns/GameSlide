//
//  ViewController.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-04.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit
import DaniloFramework

class ViewController: UIViewController {
    private var nasaImage: UIImage?
    private var row: Int = 0
    private var col: Int = 0
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        let alert = SizeAlert.shared.selectSizeGame { (rows, cols) in
            self.row = rows
            self.col = cols
            self.performSegue(withIdentifier: "segueToMainGame", sender: sender)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let nasaApi = NasaImageAPI.init(apiKey: "4CYYAPIyKDOCeFynHy5x9hXlX2DNAUOgk8OOi6pX")
        nasaApi.getImageWithHandler { (imgData) in
            if let image = UIImage(data: imgData){
                DispatchQueue.main.async {
                    self.nasaImage = image
                }
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMainGame" {
            let vc = segue.destination as! GameViewController
            if nasaImage != nil && (sender as? UIButton)?.tag == 1 {
                vc.apiManager = GameAPI(image: nasaImage!, rows: row, cols: col)
            } else {
                vc.apiManager = GameAPI(image: #imageLiteral(resourceName: "defaultImage"), rows: row, cols: col)
            }
        }
    }
}

