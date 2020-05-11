//
//  SoundsSettingsTableViewController.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-06.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit

class SoundsSettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SoundsEffects.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseSoundCell", for: indexPath) as! SoundCell
        
        cell.settingsLabel.text = SoundsEffects.allCases[indexPath.row].rawValue
        cell.settingsSwitch.tag = indexPath.row
        if indexPath.row ==  0 {
            cell.settingsSwitch.setOn(SoundsManager.shared.checkSoundEnable(sound: .move_block), animated: false)
        } else {
            cell.settingsSwitch.setOn(SoundsManager.shared.checkSoundEnable(sound: .win_game), animated: false)
        }
        cell.selectionStyle = .none
        return cell
    }
}
