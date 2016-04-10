import XCTest
import Quick
import Nimble

@testable import TipCalculator

class ViewControllerSpecs: QuickSpec {
    override func spec() {
        var totalTextField: MockEditable!
        var taxPercentageSlider: UISlider!
        var tipCalculatorModel: TipCalculatorModel!
        var subject: ViewController!
        
        var modelTaxPercentage: Double { get {
            return tipCalculatorModel.taxPercentage
        } }
        
        func slideTaxPercentage(to value: Float) {
            taxPercentageSlider.value = value
            subject.handleTaxPercentageChange(UISlider())
        }
        
        func buildSlider() -> UISlider {
            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = 6
            return slider
        }
        
        func buildTipCalculatorModel() -> TipCalculatorModel {
            return TipCalculatorModel(total: 0, taxPercentage: 0)
        }
        
        func buildViewController() -> ViewController {
            let viewController = ViewController()
            viewController.totalTextField = totalTextField
            viewController.taxPercentageSlider = taxPercentageSlider
            viewController.tipCalculatorModel = tipCalculatorModel
            return viewController
        }
        
        beforeEach {
            totalTextField = MockEditable()
            tipCalculatorModel = buildTipCalculatorModel()
            taxPercentageSlider = buildSlider()
            subject = buildViewController()
        }
        
        describe("-handleTap(_:)") {
            it("ends editing of totalTextField") {
                subject.handleTap(UITapGestureRecognizer())
                expect(totalTextField.willFinishEditing).to(beTrue())
            }
        }
        
        describe("-handleTaxPercentageChange(_:)") {
            it("updates model's taxPercentage with min value") {
                slideTaxPercentage(to: 0)
                expect(modelTaxPercentage).to(beCloseTo(0))
            }
            
            it("updates model's taxPercentage with some value") {
                slideTaxPercentage(to: 1.9)
                expect(modelTaxPercentage).to(beCloseTo(0.19))
            }
            
            it("updates model's taxPercentage with max value") {
                slideTaxPercentage(to: 10)
                expect(modelTaxPercentage).to(beCloseTo(1))
            }
            
            context("when slider's max value is different") {
                beforeEach {
                    taxPercentageSlider.maximumValue = 25
                }
                
                it("updates TipCalculatorModel with some value") {
                    slideTaxPercentage(to: 1.9)
                    expect(modelTaxPercentage).to(beCloseTo(1.9 / 25))
                }
            }
        }
        
        describe("Quick + XCode 7.3 workaround") { it("is last test that is not executed") {} }
    }
}

class MockEditable: NSObject, Editable {
    var willFinishEditing = false
    
    func endEditing(force: Bool) -> Bool {
        willFinishEditing = true
        return true
    }
}