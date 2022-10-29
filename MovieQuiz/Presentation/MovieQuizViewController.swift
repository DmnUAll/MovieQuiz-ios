import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    var alertPresenter: AlertPresenterProtocol? { get }
    func show(quiz step: QuizStepViewModel)
    func highlightImage(isAnswerCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func removeHighlight()
    func enableOrDisableButtons()
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private var buttonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        stackView.isHidden = true
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        self.stackView.isHidden = false
    }
    
   func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    completionHandler: { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        })
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImage(isAnswerCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isAnswerCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        enableOrDisableButtons()
    }
    
    func removeHighlight() {
        self.imageView.layer.borderWidth = 0
    }
    
    func enableOrDisableButtons() {
        for button in buttonsCollection {
            button.isEnabled.toggle()
        }
    }
    
    @IBAction private func yesButtonTapped() {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonTapped() {
        presenter.noButtonClicked()
    }
}

// MARK: - AlertPresenterDelegate

extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}


