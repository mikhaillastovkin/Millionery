//
//  AddQuestionViewController.swift
//  Millionery
//
//  Created by Михаил Ластовкин on 04.02.2022.
//

import UIKit

class AddQuestionViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var aAnswerTextField: UITextField!
    @IBOutlet weak var bAnswerTextField: UITextField!
    @IBOutlet weak var cAnswerTextField: UITextField!
    @IBOutlet weak var dAnswerTextField: UITextField!
    @IBOutlet weak var summTextField: UITextField!

    @IBOutlet weak var corrcectAnswerSegmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func checkTextFields() -> Bool {
        guard questionTextField.hasText,
              aAnswerTextField.hasText,
              bAnswerTextField.hasText,
              cAnswerTextField.hasText,
              dAnswerTextField.hasText
        else {
            attensionAlert()
            return false
        }
        return true
    }

    private func checkSumm() -> Bool {

        guard let newSumm: Int = Int(summTextField.text ?? "")
        else {
            attensionAlert()
            return false
        }
        for question in Game.shared.questions {
            if question.summ == newSumm {
                attensionSummAlert()
                return false
            }
        }
        return true
    }

    private func attensionSummAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Такая сумма уже занята", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)

    }


    private func attensionAlert() {
        let alert = UIAlertController(title: "Ошибка!", message: "Првильно заполните все поля", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

    private func createQuestion() -> Question{
        let newQuestion = Question(
            textQuestion: questionTextField.text ?? "",
            aAnswer: aAnswerTextField.text ?? "",
            bAnswer: bAnswerTextField.text ?? "",
            cAnswer: cAnswerTextField.text  ?? "",
            dAnswer: dAnswerTextField.text  ?? "",
            correctAnswer: getCorrectAnswer(),
            halfAnswer: getHulfAnswer(),
            helpFriend: getFriendAnswer(),
            helpPeople: getPeopleAnswers(),
            summ: Int(summTextField.text ?? "0")!)
        return newQuestion
    }

    private func getCorrectAnswer() -> Answer {
        switch corrcectAnswerSegmentControl.selectedSegmentIndex {
        case 0:
            return .a
        case 1:
            return .b
        case 2:
            return .c
        case 3:
            return .d
        default:
            return .a
        }
    }

    private func getHulfAnswer() -> (Answer, Answer) {
        let correctAnswer = getCorrectAnswer()
        var randomAnswer: Answer = .a

        repeat {
            randomAnswer = Answer.allCases.randomElement() ?? .a
        } while randomAnswer == correctAnswer
        return (correctAnswer, randomAnswer)
    }

    private func getFriendAnswer() -> Answer {
        let coinRandom = Bool.random()
        if coinRandom {
            return getCorrectAnswer()
        } else {
            return Answer.allCases.randomElement() ?? .a
        }
    }

    private func getPeopleAnswers() -> (Int, Int, Int, Int) {
        var remainder = 100
        let a = Int.random(in: 0...remainder)
        remainder -= a
        let b = Int.random(in: 0...remainder)
        remainder -= b
        let c = Int.random(in: 0...remainder)
        remainder -= c
        let d = remainder
        return (a, b, c, d)
    }


    @IBAction func pressAddQuestionButton(_ sender: Any) {
        if checkTextFields(),
           checkSumm() {
            Game.shared.addNewQuestion(createQuestion())
            dismiss(animated: true, completion: nil)
        }
    }
}
