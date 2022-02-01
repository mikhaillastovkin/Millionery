//
//  MainMenuViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 31.01.2022.
//

import UIKit

final class MainMenuViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goGameVC" {
            let destination = segue.destination as? GameViewController
            destination?.delegate = self
        }
    }

    @IBAction func pressStartButton(_ sender: Any) {
        performSegue(withIdentifier: "goGameVC", sender: self)
    }
}

extension MainMenuViewController: GameViewDelegate {

    func setLastResult(result: String, summ: String) {
        resultLabel.text = "\(result) вопросов, \(summ) рублей"
    }

}


