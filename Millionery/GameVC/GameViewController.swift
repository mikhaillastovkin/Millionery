//
//  GameViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 29.01.2022.
//

import UIKit

protocol GameViewDelegate: AnyObject {
    func setLastResult(result: String, summ: String)
}

final class GameViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var aAnswerButton: UIButton!
    @IBOutlet weak var bAnswerButton: UIButton!
    @IBOutlet weak var cAnswerButton: UIButton!
    @IBOutlet weak var dAnswerButton: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var clue50Button: UIButton!
    @IBOutlet weak var clueRingButton: UIButton!
    @IBOutlet weak var cluePeopleHelpButton: UIButton!
    @IBOutlet weak var numberQuestionLabel: UILabel!


    var questions = Game.shared.questions
    var gameSession = Game.shared.gameSession
    var answerSelected = false
    var dateFomater: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMM"
        return dateFormater
    }
    let observer = Observer()


    weak var delegate: GameViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestion(number: gameSession.activeQuestion.value)
        gameSession.activeQuestion.addObserver(observer) { [weak self] activeQuestion, _ in
            guard let self = self else { return }
            self.numberQuestionLabel.text = "Вопрос № \(activeQuestion + 1)"
        }
        gameSession.activeQuestion.value = 0
    }

    private func getQuestion(number: Int) {
        answerSelected = false
        guard number <= questions.count - 1
        else {
            stopGame()
            return
        }
        questionLabel.text = questions[number].textQuestion
        aAnswerButton.setTitle(questions[number].aAnswer, for: .normal)
        bAnswerButton.setTitle(questions[number].bAnswer, for: .normal)
        cAnswerButton.setTitle(questions[number].cAnswer, for: .normal)
        dAnswerButton.setTitle(questions[number].dAnswer, for: .normal)
        sumLabel.text = String(questions[number].summ)
    }

    private func selectAnswer(answer: Answer) {
        if !answerSelected {
            gameSession.answerSelect = answer
            switch answer {
            case .a:
                animationButton(aAnswerButton)
            case .b:
                animationButton(bAnswerButton)
            case .c:
                animationButton(cAnswerButton)
            case .d:
                animationButton(dAnswerButton)
            }
            answerSelected = true
        } else {
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Изменить ответ больше нельзя",
                preferredStyle: .alert)
            let alertAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }

    private func animationButton(_ selectedButton: UIButton) {
        let answerButton = getCorrectAnswer()
        UIView.animate(withDuration: 1, delay: 0) {
            selectedButton.backgroundColor = UIColor.orange
        } completion: { _ in
            UIView.animate(withDuration: 1, delay: 0.5) {
                answerButton.backgroundColor = UIColor.green
            } completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1) {
                    answerButton.backgroundColor = UIColor.systemGray6
                    selectedButton.backgroundColor = UIColor.systemGray6
                } completion: { _ in
                    self.checkResult()
                }
            }
        }
    }

    private func getCorrectAnswer() -> UIButton {
        let correctAnswer = questions[gameSession.activeQuestion.value].correctAnswer
        switch correctAnswer {
        case .a:
            return aAnswerButton
        case .b:
            return bAnswerButton
        case .c:
            return cAnswerButton
        case .d:
            return dAnswerButton
        }
    }

    private func checkResult() {
        if gameSession.answerSelect == questions[gameSession.activeQuestion.value].correctAnswer {
            gameSession.countCorrectAnswer += 1
            gameSession.currentSumm = questions[gameSession.activeQuestion.value].summ
            gameSession.activeQuestion.value += 1
            enableButton(answer: [.a, .b, .c, .d])
            getQuestion(number: gameSession.activeQuestion.value)
        } else {
            stopGame()
        }
    }

    private func stopGame() {
        delegate?.setLastResult(
            result: String(gameSession.countCorrectAnswer),
            summ: String(gameSession.currentSumm))
        let result = GameResult(date: dateFomater.string(from: .now),
                                countCorrectAnswer: String(gameSession.countCorrectAnswer),
                                summ: gameSession.currentSumm,
                                countClues: String(gameSession.countClue))
        Game.shared.addResult(result: result)
        var message = ""
        switch gameSession.activeQuestion.value {
        case 0:
            message = "Спасибо за игру, вам не удалось ответить ни на один вопросов!"

        case 1:
            message = "Спасибо за игру, вам удалось ответить на один вопрос! Вы заработали \(gameSession.currentSumm) рублей!"
        case 2...4:
            message = "Спасибо за игру, вам удалось ответить на \(gameSession.countCorrectAnswer) вопроса! Вы заработали \(gameSession.currentSumm) рублей!"
        case 5...questions.count - 1:
            message = "Спасибо за игру, вам удалось ответить на \(gameSession.countCorrectAnswer) вопросов! Вы заработали \(gameSession.currentSumm) рублей!"
        default:
            message = "Спасибо за игру вам, удалось ответить на все вопросы! Вы заработали \(String(describing: Game.shared.questions.last!.summ))"
        }
        let alert = UIAlertController(
            title: "Конец игры",
            message: message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)

    }

    private func getClue50() {
        let halfAnswer = questions[gameSession.activeQuestion.value].halfAnswer
        disableAllButton()
        enableButton(answer: [halfAnswer.0, halfAnswer.1])

    }

    private func disableAllButton() {
        aAnswerButton.isEnabled = false
        bAnswerButton.isEnabled = false
        cAnswerButton.isEnabled = false
        dAnswerButton.isEnabled = false

    }

    private func enableButton(answer: [Answer]) {
        for i in answer {
            switch i {
            case .a:
                aAnswerButton.isEnabled = true
            case .b:
                bAnswerButton.isEnabled = true
            case .c:
                cAnswerButton.isEnabled = true
            case .d:
                dAnswerButton.isEnabled = true
            }
        }
    }

    private func getClueRing() {
        var message = "Друг говорит правильный ответ: "
        switch questions[gameSession.activeQuestion.value].helpFriend {
        case .a:
            message += questions[gameSession.activeQuestion.value].aAnswer
        case .b:
            message += questions[gameSession.activeQuestion.value].bAnswer
        case .c:
            message += questions[gameSession.activeQuestion.value].cAnswer
        case .d:
            message += questions[gameSession.activeQuestion.value].dAnswer
        }
        let alert = UIAlertController(
            title: "Звонок другу",
            message: message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

    private func getCluePeopleHelp() {
        let question = questions[gameSession.activeQuestion.value]
        let message = """
        Голоса распределились так:
        \(question.aAnswer) - \(question.helpPeople.0)%
        \(question.bAnswer) - \(question.helpPeople.1)%
        \(question.cAnswer) - \(question.helpPeople.2)%
        \(question.dAnswer) - \(question.helpPeople.3)%
        """
        let alert = UIAlertController(
            title: "Помощь зала",
            message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }


    @IBAction func aButtonPress(_ sender: Any) {
        selectAnswer(answer: .a)
    }
    @IBAction func bButtonPress(_ sender: Any) {
        selectAnswer(answer: .b)
    }
    @IBAction func cButtonPress(_ sender: Any) {
        selectAnswer(answer: .c)
    }
    @IBAction func dButtonPress(_ sender: Any) {
        selectAnswer(answer: .d)
    }

    @IBAction func clue50ButtonPress(_ sender: Any) {
        clue50Button.isEnabled = false
        gameSession.countClue += 1
        getClue50()
    }
    @IBAction func clueRingButtonPress(_ sender: Any) {
        clueRingButton.isEnabled = false
        gameSession.countClue += 1
        getClueRing()
    }
    @IBAction func cluePeopleHelpPress(_ sender: Any) {
        cluePeopleHelpButton.isEnabled = false
        gameSession.countClue += 1
        getCluePeopleHelp()
    }

}


