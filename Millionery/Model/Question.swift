//
//  Question.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 29.01.2022.
//

import Foundation

struct Question {
    let textQuestion: String
    let aAnswer: String
    let bAnswer: String
    let cAnswer: String
    let dAnswer: String
    let correctAnswer: Answer
    let halfAnswer: (Answer, Answer)
    let helpFriend: Answer
    let helpPeople: (Int, Int, Int, Int)
    let summ: Int

}

enum Answer: CaseIterable {
    case a, b, c, d

}
