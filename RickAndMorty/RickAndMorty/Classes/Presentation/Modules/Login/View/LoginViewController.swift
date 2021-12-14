import UIKit
import Locksmith

protocol LoginViewInput: AnyObject {
  func showAlert()
  func goMain()
}

class LoginViewController: UIViewController, StoryboardCreatable {
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  private let showPasswordButton = UIButton(type: .custom)
  var presenter: LoginViewOutput?

  private let account = KeyChainAccount(username: "Rick", password: "Morty")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.presenter = LoginPresenter(view: self, account: self.account)
    addGestureRecognizer(action: #selector(keyboardClose(_ :)))
    presenter?.passwordSecurityToggle(passwordField: passwordField)
    self.loginField.textFieldUnderLine()
    self.passwordField.textFieldUnderLine()
    showPasswordButtonSetting()
    passwordFieldButton()
  }

  @IBAction func cleanLoginField(_ sender: Any) {
    self.loginField.textColor = .black
    self.loginField.text = ""
    moveView(moveDistance: -87, goUp: true)
  }

  @IBAction func cleanPasswordField(_ sender: Any) {
    passwordField.textColor = .black
    passwordField.text = ""
    moveView(moveDistance: -124, goUp: true)
  }

  @IBAction func loginDidEndEditing(_ sender: Any) {
    moveView(moveDistance: -87, goUp: false)
  }

  @IBAction func passwordDidEndEditing(_ sender: Any) {
    moveView(moveDistance: -124, goUp: false)
  }

  @IBAction func touchLoginButton(_ sender: Any) {
    presenter?.tapLoginButton(loginField: self.loginField, passwordField: self.passwordField)
  }

  @IBAction func doneButtonLogin(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func doneButtonPassword(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  /// Конфигурация кнопки скрытия / отображения пароля
  private func showPasswordButtonSetting() {
    showPasswordButton.frame = CGRect(x: 0, y: 0, width: 22, height: 15)
    showPasswordButton.setImage(ImagesLogin.eye, for: .normal)
    showPasswordButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
    showPasswordButton.sizeToFit()
    showPasswordButton.tintColor = CustomColors.border
  }

  /// Показать или скрыть пароль в поле
  private func passwordFieldButton() {
    passwordField.rightView = showPasswordButton
    passwordField.rightViewMode = .always
  }

  @objc private func keyboardClose(_ sender: UITapGestureRecognizer) {
    self.loginField.resignFirstResponder()
    self.passwordField.resignFirstResponder()
  }

  @objc func showPassword() {
    presenter?.passwordSecurityToggle(passwordField: passwordField)
  }
}

extension LoginViewController: LoginViewInput {
  func showAlert() {
    loginField.textColor = .red
    passwordField.textColor = .red
    showAlert("Error", "Incorrect Login or Password", [UIAlertAction(title: "OK", style: .default, handler: nil)])
  }

  func goMain() {
    passwordField.textColor = .black
    loginField.textColor = .black
    show(TabBarViewController.createFromStoryboard, sender: nil)
  }
}
