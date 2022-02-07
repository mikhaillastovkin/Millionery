//
//  MainMenuViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 31.01.2022.
//

import UIKit

final class MainMenuViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private var difficulty: Difficulty {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return .normal
        case 1:
            return .shuffled
        default:
            return .normal
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Game.shared.startSetQuestion()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goGameVC" {
            let destination = segue.destination as? GameViewController
            destination?.delegate = self
        }
    }

    @IBAction func pressStartButton(_ sender: Any) {
        choiseStrategy()
        performSegue(withIdentifier: "goGameVC", sender: self)
    }

    private func choiseStrategy() {
        switch difficulty {
        case .normal:
            Game.shared.strategy = EasyGameStrategy()
        case .shuffled:
            Game.shared.strategy = HardGameStrategy()
        }
    }
}

extension MainMenuViewController: GameViewDelegate {

    func setLastResult(result: String, summ: String) {
        resultLabel.text = "\(result) вопросов, \(summ) рублей"
    }

}


