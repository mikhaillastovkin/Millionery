//
//  GameStrategyProtocol.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 02.02.2022.
//

import Foundation

protocol GameStrategyProtocol {

    func getQuestionsArray(question: [Question]) -> [Question]

}
