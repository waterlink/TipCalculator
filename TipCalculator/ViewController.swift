import UIKit

@objc protocol Editable {
     func endEditing(force: Bool) -> Bool
}

extension UITextField: Editable {}

class ViewController: UIViewController {
    @IBOutlet weak var totalTextField: Editable!
    @IBOutlet weak var taxPercentageSlider: UISlider!
    @IBOutlet weak var taxPercentageLabel: UILabel!
    @IBOutlet weak var resultsTextView: UIView!
    
    var tipCalculatorModel: TipCalculatorModel!

    @IBAction func handleTap(sender: AnyObject) {
        totalTextField.endEditing(true)
    }

    @IBAction func handleTaxPercentageChange(sender: AnyObject) {
        tipCalculatorModel.taxPercentage = taxPercentageValue()
    }
    
    private func taxPercentageValue() -> Double {
        return taxPercentageSliderCurrentValue() / taxPercentageSliderMaxValue()
    }
    
    private func taxPercentageSliderMaxValue() -> Double {
        return Double(taxPercentageSlider.maximumValue)
    }
    
    private func taxPercentageSliderCurrentValue() -> Double {
        return Double(taxPercentageSlider.value)
    }
}

