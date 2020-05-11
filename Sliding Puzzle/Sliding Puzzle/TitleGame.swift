//
//  TitleGame.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-04.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import Foundation
import UIKit

class BlockGame: UIImageView {
    var currentPosition: Int = 0
    var finalPosition: Int = 0
    init(finalPosition: Int, image: UIImage) {
            super.init(image: image)
            self.finalPosition = finalPosition
            //self.image = image
            
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(image: UIImage?) {
        super.init(image: image)
    }
}
