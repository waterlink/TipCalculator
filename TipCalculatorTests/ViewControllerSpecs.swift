import XCTest
import Quick
import Nimble

@testable import TipCalculator

class ViewControllerSpecs: QuickSpec {
    override func spec() {
        var totalTextField: MockEditable!
        var taxPercentageSlider: UISlider!
        var taxPercentageLabel: UILabel!
        var tipCalculatorModel: TipCalculatorModel!
        var subject: ViewController!
        
        var modelTaxPercentage: Double { get {
            return tipCalculatorModel.taxPercentage
        } }
        
        func slideTaxPercentage(to value: Float) {
            taxPercentageSlider.value = value
            subject.handleTaxPercentageChange(UISlider())
        }
        
        func updateTaxPercentage(with value: Double) {
            tipCalculatorModel.taxPercentage = value
            subject.handleTipCalculatorModelChange(tipCalculatorModel)
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
            viewController.taxPercentageLabel = taxPercentageLabel
            return viewController
        }
        
        beforeEach {
            totalTextField = MockEditable()
            tipCalculatorModel = buildTipCalculatorModel()
            taxPercentageSlider = buildSlider()
            taxPercentageLabel = UILabel()
            subject = buildViewController()
        }
        
        describe("-handleTap(_:)") {
            it("ends editing of totalTextField") {
                subject.handleTap(UITapGestureRecognizer())
                expect(totalTextField.willFinishEditing).to(beTrue())
            }
        }
        
        describe("-handleTaxPercentageChange(_:)") {
            describe("model updates") {
                it("sets taxPercentage to min value") {
                    slideTaxPercentage(to: 0)
                    expect(modelTaxPercentage).to(beCloseTo(0))
                }
                
                it("sets taxPercentage to some value") {
                    slideTaxPercentage(to: 1.9)
                    expect(modelTaxPercentage).to(beCloseTo(0.19))
                }
                
                it("sets taxPercentage to max value") {
                    slideTaxPercentage(to: 10)
                    expect(modelTaxPercentage).to(beCloseTo(1))
                }
                
                context("when slider's max value is different") {
                    beforeEach {
                        taxPercentageSlider.maximumValue = 25
                    }
                    
                    it("sets to some value") {
                        slideTaxPercentage(to: 1.9)
                        expect(modelTaxPercentage).to(beCloseTo(1.9 / 25))
                    }
                }
            }
        }
        
        describe("-handleTipCalculatorModelChange(_:)") {
            describe("taxPercentage change") {
                it("updates tax percentage label with 0% value") {
                    updateTaxPercentage(with: 0)
                    expect(taxPercentageLabel.text).to(equal("Tax Percentage (0%)"))
                }
                
                it("updates tax percentage label with 100% value") {
                    updateTaxPercentage(with: 1)
                    expect(taxPercentageLabel.text).to(equal("Tax Percentage (100%)"))
                }
                
                it("updates tax percentage label with 18% value") {
                    updateTaxPercentage(with: 0.183)
                    expect(taxPercentageLabel.text).to(equal("Tax Percentage (18%)"))
                }
            }
        }
        
        describe("-viewDidLoad(_:)") {
            context("when model is already created") {
                it("does not change its model") {
                    subject.viewDidLoad()
                    expect(subject.tipCalculatorModel).to(be(tipCalculatorModel))
                }
            }
            
            context("when there is no model yet") {
                beforeEach {
                    subject.tipCalculatorModel = nil
                    subject.viewDidLoad()
                }
                
                it("does not change its model") {
                    expect(subject.tipCalculatorModel).notTo(beNil())
                }
                
                it("subscribes to the model") {
                    subject.tipCalculatorModel?.taxPercentage = 0.75
                    expect(taxPercentageLabel.text).to(equal("Tax Percentage (75%)"))
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