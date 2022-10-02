//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Валито on 29.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {   // Using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead
    func didReceiveNextQuestion(question: QuizQuestion?)
}
