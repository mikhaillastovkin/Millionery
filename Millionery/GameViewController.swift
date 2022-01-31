//
//  GameViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 29.01.2022.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var aAnswerButton: UIButton!
    @IBOutlet weak var bAnswerButton: UIButton!
    @IBOutlet weak var cAnswerButton: UIButton!
    @IBOutlet weak var dAnswerButton: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var clue50Button: UIButton!
    @IBOutlet weak var clueRingButton: UIButton!
    @IBOutlet weak var cluePeopleHelpButton: UIButton!

    var questions = [Question]()
    var activeQuestion = 0
    var clueCount = 0
    var selectedAnswer: Answer?
    var countCorrectAnswer = 0
    var answerSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestion()
        getQuestion(number: activeQuestion)
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
        sumLabel.text = questions[number].summ
    }

    private func selectAnswer(answer: Answer) {
        if !answerSelected {
            selectedAnswer = answer
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
            UIView.animate(withDuration: 1, delay: 2) {
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
        let correctAnswer = questions[activeQuestion].correctAnswer
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
        if selectedAnswer == questions[activeQuestion].correctAnswer {
            countCorrectAnswer += 1
            activeQuestion += 1
            enableButton(answer: [.a, .b, .c, .d])
            getQuestion(number: activeQuestion)
        } else {
            stopGame()
        }
    }

    private func stopGame() {
        var message = ""
        switch activeQuestion {
        case 0:
            message = "Спасибо за игру, вам не удалось ответить ни на один вопросов!"
        case 1:
            message = "Спасибо за игру, вам удалось ответить на один вопрос! Вы заработали \(questions[activeQuestion - 1].summ) рублей!"
        case 2...4:
            message = "Спасибо за игру, вам удалось ответить на \(countCorrectAnswer) вопроса! Вы заработали \(questions[activeQuestion - 1].summ) рублей!"
        case 5...questions.count - 1:
            message = "Спасибо за игру, вам удалось ответить на \(countCorrectAnswer) вопросов! Вы заработали \(questions[activeQuestion - 1].summ) рублей!"
        default:
            message = "Спасибо за игру вам, удалось ответить на все вопросы! Вы заработали 1 000 000"
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
        let halfAnswer = questions[activeQuestion].halfAnswer
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
        switch questions[activeQuestion].helpFriend {
        case .a:
            message += questions[activeQuestion].aAnswer
        case .b:
            message += questions[activeQuestion].bAnswer
        case .c:
            message += questions[activeQuestion].cAnswer
        case .d:
            message += questions[activeQuestion].dAnswer
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
        let question = questions[activeQuestion]
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
        clueCount -= 1
        getClue50()
    }
    @IBAction func clueRingButtonPress(_ sender: Any) {
        clueRingButton.isEnabled = false
        clueCount -= 1
        getClueRing()
    }
    @IBAction func cluePeopleHelpPress(_ sender: Any) {
        cluePeopleHelpButton.isEnabled = false
        clueCount -= 1
        getCluePeopleHelp()
    }

}


