//
//  HardGameStrategy.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 02.02.2022.
//

import Foundation

final class HardGameStrategy: GameStrategyProtocol {

    func getQuestionsArray(question: [Question]) -> [Question] {
        let shuffledQuestion = question.shuffled()
        return shuffledQuestion
    }
}
