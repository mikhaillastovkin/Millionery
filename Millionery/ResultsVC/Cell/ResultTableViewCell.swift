//
//  ResultTableViewCell.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 01.02.2022.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countCorrectAnswerLabel: UILabel!
    @IBOutlet weak var summLabel: UILabel!
    @IBOutlet weak var countClueLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell(result: GameResult) {
        dateLabel.text = result.date
        countCorrectAnswerLabel.text = result.countCorrectAnswer
        summLabel.text = String(result.summ)
        countClueLabel.text = result.countClues
    }
    
}
