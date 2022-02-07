//
//  GameSession.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 01.02.2022.
//

import Foundation

struct GameSession {
    var activeQuestion: Observable<Int> = Observable(0)
    var currentSumm: Int = 0
    var countClue: Int = 0
    var countCorrectAnswer: Int = 0
    var answerSelect: Answer?
}
