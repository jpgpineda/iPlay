import UIKit

@IBDesignable
class FloatingLabeledTextField: UITextField {

    // MARK: - Labels
    private let floatingLabel = UILabel()
    private let errorLabel = UILabel()
    private var labelsAddedToSuperview = false

    // MARK: - Inspectables
    @IBInspectable var floatingText: String?
    @IBInspectable var errorMessage: String?
    @IBInspectable var floatingLabelColor: UIColor = .darkGray { didSet { floatingLabel.textColor = floatingLabelColor } }
    @IBInspectable var errorColor: UIColor = .red { didSet { errorLabel.textColor = errorColor } }
    @IBInspectable var activeBorderColor: UIColor = .systemBlue
    @IBInspectable var inactiveBorderColor: UIColor = .lightGray
    @IBInspectable var borderCornerRadius: CGFloat = 8 {
        didSet { layer.cornerRadius = borderCornerRadius }
    }
    @IBInspectable var borderWidthValue: CGFloat = 1 {
        didSet { layer.borderWidth = borderWidthValue }
    }

    // MARK: - State
    /// setea la visibilidad del error desde afuera
    var isValid: Bool = true {
        didSet { updateErrorState() }
    }

    // store original placeholder so we can restore it
    private var originalPlaceholder: String?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // We manage our own border, avoid built-in ones
        borderStyle = .none
        layer.borderWidth = borderWidthValue
        layer.cornerRadius = borderCornerRadius
        layer.borderColor = inactiveBorderColor.cgColor
        clipsToBounds = false // allow labels (if put in same superview) to be visible

        // Floating label setup
        floatingLabel.font = UIFont.systemFont(ofSize: 12)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.alpha = 0 // start hidden
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.backgroundColor = .clear
        floatingLabel.numberOfLines = 1

        // Error label setup
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.textColor = errorColor
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.backgroundColor = .clear

        // keep placeholder
        originalPlaceholder = placeholder

        // events
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    // Add the labels to the textField superview so they won't be clipped by the textField itself,
    // and so they can sit outside the textfield frame (top and bottom).
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let container = superview, !labelsAddedToSuperview else { return }

        container.addSubview(floatingLabel)
        container.addSubview(errorLabel)

        // Constraints: floatingLabel sits above the textfield; errorLabel below the textfield
        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            floatingLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -4),
            // allow max width but prefer textfield width
            floatingLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -2),

            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -2)
        ])

        // set initial texts
        floatingLabel.text = floatingText ?? originalPlaceholder
        errorLabel.text = errorMessage

        labelsAddedToSuperview = true
    }

    // MARK: - Editing events
    @objc private func editingDidBegin() {
        showFloatingLabel(animated: true)
        layer.borderColor = activeBorderColor.cgColor
    }

    @objc private func editingDidEnd() {
        // hide floating label only if empty and not showing an error
        if (text?.isEmpty ?? true) && (isValid == true) {
            hideFloatingLabel(animated: true)
        }
        // border color depends on error state
        layer.borderColor = (isValid ? inactiveBorderColor : errorColor).cgColor
    }

    @objc private func editingChanged() {
        // if user types, hide error
        if !(text?.isEmpty ?? true) {
            isValid = true
        }
    }

    // MARK: - Floating label controls
    private func showFloatingLabel(animated: Bool) {
        floatingLabel.text = floatingText ?? originalPlaceholder
        if animated {
            floatingLabel.transform = CGAffineTransform(translationX: 0, y: 6) // start slightly lower for animation
            floatingLabel.alpha = 0
            UIView.animate(withDuration: 0.18) {
                self.floatingLabel.alpha = 1
                self.floatingLabel.transform = .identity
            }
        } else {
            floatingLabel.alpha = 1
            floatingLabel.transform = .identity
        }
        // hide native placeholder so we don't see duplicated text
        placeholder = ""
    }

    private func hideFloatingLabel(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.18, animations: {
                self.floatingLabel.alpha = 0
            }) { _ in
                self.placeholder = self.originalPlaceholder
            }
        } else {
            floatingLabel.alpha = 0
            placeholder = originalPlaceholder
        }
    }

    // MARK: - Error controls
    private func showError(message: String?) {
        errorLabel.text = message ?? errorMessage
        errorLabel.isHidden = false
        layer.borderColor = errorColor.cgColor
        // ensure floating label stays visible (if placeholder previously shown)
        if floatingLabel.alpha == 0 {
            // if field is empty and we show error, float label should be visible so user knows the field label
            showFloatingLabel(animated: true)
        }
    }

    private func hideError() {
        errorLabel.isHidden = true
        layer.borderColor = inactiveBorderColor.cgColor
    }

    private func updateErrorState() {
        DispatchQueue.main.async {
            if self.isValid {
                self.hideError()
            } else {
                self.showError(message: self.errorMessage)
            }
        }
    }

    // Public helper to set error from outside
    func setError(_ message: String?) {
        self.errorMessage = message
        self.isValid = (message == nil)
        if message != nil { self.isValid = false }
    }

    // Make sure placeholder text available in Interface Builder preview
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        floatingLabel.text = floatingText ?? placeholder
        errorLabel.text = errorMessage
    }
}
