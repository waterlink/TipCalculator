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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTap(sender: AnyObject) {
        totalTextField.endEditing(true)
    }

}

