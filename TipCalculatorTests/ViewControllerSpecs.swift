import Quick
import Nimble

@testable import TipCalculator

class ViewControllerSpecs: QuickSpec {
    override func spec() {
        var totalTextField: MockEditable!
        var subject: ViewController!
        
        beforeEach {
            totalTextField = MockEditable()
            subject = ViewController()
            
            subject.totalTextField = totalTextField
        }
        
        describe("-handleTap(_:)") {
            it("ends editing of totalTextField") {
                subject.handleTap(UITapGestureRecognizer())
                expect(totalTextField.willFinishEditing).to(beTrue())
            }
        }
    }
}

class MockEditable: NSObject, Editable {
    var willFinishEditing = false
    
    func endEditing(force: Bool) -> Bool {
        willFinishEditing = true
        return true
    }
}