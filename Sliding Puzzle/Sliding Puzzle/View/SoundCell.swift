//
//  SoundCell.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-11.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit

class SoundCell: UITableViewCell {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    /// Switch's selection
    ///
    /// Switch tag:
    ///
    /// 0. Move Block Switch
    /// 1. Win game Switch
    @IBAction func switchPressed(_ sender: Any) {
        let toggle = sender as! UISwitch
        
        switch toggle.tag {
        case 0:
            SoundsManager.shared.setSoundEnable(sound: .move_block, enable: toggle.isOn)
        default:
            SoundsManager.shared.setSoundEnable(sound: .win_game, enable: toggle.isOn)
        }
        
    }
}
