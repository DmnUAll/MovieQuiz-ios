//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Илья Валито on 29.09.2022.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completionHandler: (UIAlertAction) -> Void
}

