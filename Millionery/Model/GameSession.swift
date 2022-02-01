//
//  GameSession.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 01.02.2022.
//

import Foundation

struct GameSession {
    var activeQuestion: Int = 0
    var currentSumm: String = "0"
    var countClue: Int = 0
    var countCorrectAnswer: Int = 0
    var answerSelect: Answer?
}
