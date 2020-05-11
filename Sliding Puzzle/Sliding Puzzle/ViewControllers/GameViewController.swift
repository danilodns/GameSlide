//
//  GameViewController.swift
//  Sliding Puzzle
//
//  Created by Danilo Silveira on 2020-05-04.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var apiManager: GameAPI?
    var keepPositon = false
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var gameView: UIView!
    
    @IBAction func resetButtomPressed(_ sender: Any) {
        loadData()
    }
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backToInitial(sender:)))
        changeStackOrientation(size: view.frame.size)
        if apiManager == nil {
            apiManager = GameAPI(image: #imageLiteral(resourceName: "defaultImage"), rows: 4, cols: 4)
        }
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !keepPositon {
            loadData()
            keepPositon = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let titleView = touches.first?.view as? BlockGame else {
            return
        }
        apiManager!.moveBlock(position: titleView.currentPosition)
        
        if apiManager!.checkWin() {
            removeBlocksFromGameView()
            SoundsManager.shared.play(sound: .win_game)
            let view = UIImageView(image: apiManager!.fullImage)
            view.isUserInteractionEnabled = false
            gameView.addSubview(view)
            let alert = UIAlertController(title: "You Win", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        changeStackOrientation(size: size)
        var newSize: CGFloat = 0
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            let navigationBarheight:CGFloat = size.height < 376 ? 32 : 44
            newSize = size.width > size.height ? (size.height - 40 - navigationBarheight) : (size.width - 40)
            break
        case .pad:
            newSize = size.width > size.height ? (size.height - 114) : (size.width - 40)
        default:
            break
        }
        rotate(size: CGSize(width: newSize, height: newSize))
    }
    
    @objc func backToInitial(sender: Any) {
        self.performSegue(withIdentifier: "unwindToInitialVc", sender: self)
    }
    
    
    private func loadData() {
        removeBlocksFromGameView()
        apiManager!.startGame(imageViewSize: gameView.frame.size).forEach { (titleGame) in
            gameView.addSubview(titleGame)
        }
    }
    
    private func removeBlocksFromGameView() {
        for subView in gameView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func changeStackOrientation(size: CGSize) {
        if size.width > size.height {
            self.stackView.axis = .horizontal
        } else {
            self.stackView.axis = .vertical
        }
    }
    
    func rotate(size: CGSize) {
        removeBlocksFromGameView()
        print("Size \(size)")
        apiManager!.rotateGame(size: size).forEach { (titleGame) in
            gameView.addSubview(titleGame)
        }
    }
}
