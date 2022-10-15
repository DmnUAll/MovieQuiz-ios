//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Валито on 29.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
