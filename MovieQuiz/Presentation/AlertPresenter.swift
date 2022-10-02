//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Валито on 29.09.2022.
//

import UIKit

struct AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    init (delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completionHandler)
        alert.addAction(action)
        delegate?.presentAlert(alert)
    }
}
