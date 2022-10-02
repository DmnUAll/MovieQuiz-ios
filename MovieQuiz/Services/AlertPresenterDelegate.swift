//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Илья Валито on 29.09.2022.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {   // Using 'class' keyword to define a class-constrained protocol is deprecated; use 'AnyObject' instead
    func presentAlert(_ alert: UIAlertController)
}
