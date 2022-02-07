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
    var strategy: GameStrategyProtocol? {
        didSet {
            setStatetgy()
        }
    }

    var questions = [Question]()

    func startSetQuestion() {
        questions.append(Question(
            textQuestion: "Как назывался первый советский фильм-катастрофа?",
            aAnswer: "34-й скорый",
            bAnswer: "Остановился поезд",
            cAnswer: "Экипаж",
            dAnswer: "Берегись автомобиля",
            correctAnswer: .c,
            halfAnswer: (Answer.b, Answer.c),
            helpFriend: .c,
            helpPeople: (0, 5, 95, 0),
            summ: 500))

        questions.append(Question(
            textQuestion: "Какой газ преобладает в атмосфере Земли?",
            aAnswer: "Кислород",
            bAnswer: "Азот",
            cAnswer: "Углекислый газ",
            dAnswer: "Водород",
            correctAnswer: .b,
            halfAnswer: (Answer.b, Answer.d),
            helpFriend: .b,
            helpPeople: (55, 25, 10, 10),
            summ: 1000))

        questions.append(Question(
            textQuestion: "Какой флаг развевается над пиратским судном?",
            aAnswer: "Грустный Роберт",
            bAnswer: "Печальный Рональд",
            cAnswer: "Смешливый Роналд",
            dAnswer: "Весёлый Роджер",
            correctAnswer: .d,
            halfAnswer: (Answer.a, Answer.d),
            helpFriend: .d,
            helpPeople: (0, 0, 0, 100),
            summ: 2000))

        questions.append(Question(
            textQuestion: "В какой стране возник танец краковяк?",
            aAnswer: "Польша",
            bAnswer: "Венгрия",
            cAnswer: "Румыния",
            dAnswer: "Чехия",
            correctAnswer: .a,
            halfAnswer: (Answer.a, Answer.d),
            helpFriend: .a,
            helpPeople: (30, 30, 30, 10),
            summ: 5000))

        questions.append(Question(
            textQuestion: "Какая из перечисленных башен самая низкая?",
            aAnswer: "Пизанская",
            bAnswer: "Останкинская",
            cAnswer: "Эйфелева",
            dAnswer: "Спасская",
            correctAnswer: .a,
            halfAnswer: (Answer.a, Answer.c),
            helpFriend: .c,
            helpPeople: (25, 25, 25, 25),
            summ: 15000))

        questions.append(Question(
            textQuestion: "Какие пальцы рук не участвуют при игре на современной арфе?",
            aAnswer: "Большие",
            bAnswer: "Указательные",
            cAnswer: "Безымянные",
            dAnswer: "Мизинцы",
            correctAnswer: .d,
            halfAnswer: (Answer.d, Answer.c),
            helpFriend: .a,
            helpPeople: (10, 25, 50, 15),
            summ: 50000))

        questions.append(Question(
            textQuestion: "Какое государство ежегодно дарит Лондону ёлку для Трафальгарской площади?",
            aAnswer: "Дания",
            bAnswer: "Норвегия",
            cAnswer: "Швеция",
            dAnswer: "Эстония",
            correctAnswer: .b,
            halfAnswer: (Answer.b, Answer.a),
            helpFriend: .b,
            helpPeople: (5, 5, 45, 45),
            summ: 100000))

        questions.append(Question(
            textQuestion: "Какой город США принято считать родиной джаза?",
            aAnswer: "Чикаго",
            bAnswer: "Нью-Йорк",
            cAnswer: "Новый Орлеан",
            dAnswer: "Сан-Франциско",
            correctAnswer: .c,
            halfAnswer: (Answer.c, Answer.d),
            helpFriend: .c,
            helpPeople: (10, 25, 20, 45),
            summ: 250000))

        questions.append(Question(
            textQuestion: "Что носило название «пенни-фартинг»?",
            aAnswer: "Игральный автомат",
            bAnswer: "Велосипед",
            cAnswer: "Телескоп",
            dAnswer: "Дуэт клоунов",
            correctAnswer: .b,
            halfAnswer: (Answer.b, Answer.d),
            helpFriend: .a,
            helpPeople: (10, 25, 50, 15),
            summ: 500000))

        questions.append(Question(
            textQuestion: "Какое растение существует на самом деле?",
            aAnswer: "Лох индийский",
            bAnswer: "Лох чилийский",
            cAnswer: "Лох греческий",
            dAnswer: "Лох русский",
            correctAnswer: .a,
            halfAnswer: (Answer.a, Answer.d),
            helpFriend: .d,
            helpPeople: (0, 5, 95, 0),
            summ: 1000000))
    }

    func setStatetgy() {
        questions = strategy?.getQuestionsArray(question: questions) ?? questions
    }

    func addResult(result: GameResult) {
        results.append(result)
        saveResults()
    }

    func addNewQuestion(_ question: Question) {
        questions.append(question)
        questions.sort { $0.summ < $1.summ }
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
