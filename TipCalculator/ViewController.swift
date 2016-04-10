import UIKit

@objc protocol Editable {
     func endEditing(force: Bool) -> Bool
}

extension UITextField: Editable {}

class ViewController: UIViewController, TipCalculatorModelObserver {
    @IBOutlet weak var totalTextField: Editable!
    @IBOutlet weak var taxPercentageSlider: UISlider!
    @IBOutlet weak var taxPercentageLabel: UILabel!
    @IBOutlet weak var resultsTextView: UIView!
    
    var tipCalculatorModel: TipCalculatorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tipCalculatorModel == nil {
            tipCalculatorModel = TipCalculatorModel(
                total: 0,
                taxPercentage: CalculateTaxPercentageValue()
            )
            tipCalculatorModel?.subscribe(self)
            handleTipCalculatorModelChange(tipCalculatorModel!)
        }
    }

    @IBAction func handleTap(sender: AnyObject) {
        totalTextField.endEditing(true)
    }

    @IBAction func handleTaxPercentageChange(sender: AnyObject) {
        tipCalculatorModel?.taxPercentage = CalculateTaxPercentageValue()
    }
    
    func handleTipCalculatorModelChange(model: TipCalculatorModel) {
        taxPercentageLabel.text = TipCalculatorPresenter(model: model).presentTaxPercentageLabel()
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

