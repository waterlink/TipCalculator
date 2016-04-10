import UIKit

@objc protocol Editable {
     func endEditing(force: Bool) -> Bool
}

extension UITextField: Editable {}

class ViewController: UIViewController {
    private let defaultTotal: Double = 0
    
    @IBOutlet weak var totalTextField: Editable!
    @IBOutlet weak var taxPercentageSlider: UISlider!
    @IBOutlet weak var taxPercentageLabel: UILabel!
    @IBOutlet weak var resultsTextView: UIView!
    
    var tipCalculatorModel: TipCalculatorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ensureModelIsPresent()
    }

    @IBAction func handleTap(sender: AnyObject) {
        totalTextField.endEditing(true)
    }

    @IBAction func handleTaxPercentageChange(sender: AnyObject) {
        tipCalculatorModel?.taxPercentage = CalculateTaxPercentageValue()
    }
}

// MARK: TipCalculatorModelObserver

extension ViewController: TipCalculatorModelObserver {
    func handleTipCalculatorModelChange(model: TipCalculatorModel) {
        taxPercentageLabel.text = TipCalculatorPresenter(model: model).presentTaxPercentageLabel()
    }
}

// MARK: @private

extension ViewController {
    private func isModelInitializationPending() -> Bool {
        return tipCalculatorModel == nil
    }
    
    private func ensureModelIsPresent() {
        if isModelInitializationPending() {
            initializeModel()
        }
    }
    
    private func initializeModel() {
        tipCalculatorModel = buildTipCalculatorModel()
        subscribeToModelChanges()
        makeInitialViewUpdate()
    }
    
    private func buildTipCalculatorModel() -> TipCalculatorModel {
        return TipCalculatorModel(
            total: defaultTotal,
            taxPercentage: CalculateTaxPercentageValue()
        )
    }
    
    private func subscribeToModelChanges() {
        tipCalculatorModel?.subscribe(self)
    }
    
    private func makeInitialViewUpdate() {
        handleTipCalculatorModelChange(tipCalculatorModel!)
    }
    
    private func CalculateTaxPercentageValue() -> Double {
        return fetchTaxPercentageSliderCurrentValue() / fetchTaxPercentageSliderMaxValue()
    }
    
    private func fetchTaxPercentageSliderMaxValue() -> Double {
        return Double(taxPercentageSlider.maximumValue)
    }
    
    private func fetchTaxPercentageSliderCurrentValue() -> Double {
        return Double(taxPercentageSlider.value)
    }
}

class TipCalculatorPresenter {
    let model: TipCalculatorModel
    
    init(model: TipCalculatorModel) {
        self.model = model
    }
    
    func presentTaxPercentageLabel() -> String {
        return "Tax Percentage (\(presentTaxPercentage()))"
    }
    
    func presentTaxPercentage() -> String {
        return "\(calculateReadableTaxPercetage())%"
    }
    
    private func calculateReadableTaxPercetage() -> Int {
        return Int(model.taxPercentage * 100)
    }
}

