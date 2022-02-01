//
//  Game.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 01.02.2022.
//

import Foundation

final class Game {

    static var shared = Game()

    private init() { }

    var results = [GameResult]()

    var gameSession = GameSession()

    func addResult(result: GameResult) {
        results.append(result)
        saveResults()
    }

    private func saveResults() {
        do {
            let data = try JSONEncoder().encode(results)
            UserDefaults.standard.set(data, forKey: "resultGame")
        }
        catch {
            print(error.localizedDescription)
        }
    }

    func loadResults() {
        let data = UserDefaults.standard.data(forKey: "resultGame")
        guard let currentData = data else { return }
        do {
            let results = try JSONDecoder().decode([GameResult].self, from: currentData)
            self.results = results
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
