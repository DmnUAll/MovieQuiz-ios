//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Валито on 28.10.2022.
//

import UIKit

final class MovieQuizPresenter {

    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
            
            statisticService = StatisticServiceImplementation()
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            loadQuestions()
            viewController.showLoadingIndicator()
        }
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    func loadQuestions() {
        questionFactory?.loadData()
    }

    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        correctAnswers += isCorrectAnswer ? 1 : 0
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(correctAnswers)/10\n" +
                "Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)\n" +
                "Рекорд: \(statisticService?.bestGame.gameStatistic() ?? "Данные отсутствуют")\n" +
                "Средняя точность: " + String(format: "%.2f" , statisticService?.totalAccuracy ?? 0.00) + "%",
                buttonText: "Сыграть ещё раз",
                completionHandler: { [ weak self ] _ in
                    guard let self = self else { return }
                    self.restartGame()
                })
            viewController?.alertPresenter?.show(alertModel: alertModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func yesButtonClicked() {
        checkUserAnswer(userAnswer: true)
    }
    
    func noButtonClicked() {
        checkUserAnswer(userAnswer: false)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func checkUserAnswer(userAnswer answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isUserGuessed = currentQuestion.correctAnswer == answer
        viewController?.showAnswerResult(isCorrect: isUserGuessed)
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}

