//
//  SizeAlert.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-11.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit

class SizeAlert {
    
    static let shared = SizeAlert()
    
    func selectSizeGame(callback: @escaping (Int, Int) -> Void) -> UIAlertController {
        let alertVc = UIAlertController(title: "Select the size", message: nil, preferredStyle: .alert)
        
        for row in 3...5 {
            for col in row...5{
                let action = UIAlertAction(title: "\(row) x \(col)", style: .default) { (action) in
                    callback(row,col)
                }
                alertVc.addAction(action)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVc.addAction(cancel)
        return alertVc
    }
}
