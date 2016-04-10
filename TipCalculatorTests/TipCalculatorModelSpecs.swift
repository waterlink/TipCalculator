import Quick
import Nimble

@testable import TipCalculator

class TipCalculatorModelSpecs: QuickSpec {
    override func spec() {
        var observer: MockTipCalculatorModelObserver!
        var subject: TipCalculatorModel!
        
        func buildTipCalculatorModel() -> TipCalculatorModel {
            let model = TipCalculatorModel(total: 33.25, taxPercentage: 0.06)
            model.subscribe(observer)
            return model
        }
        
        beforeEach {
            observer = MockTipCalculatorModelObserver()
            subject = buildTipCalculatorModel()
        }
        
        describe("-calcTipWithTipPct(_:)") {
            it("returns correct value for 18%") {
                expect(subject.calcTipWithTipPct(0.18)).to(beCloseTo(5.6462))
            }
            
            it("returns correct value for 20%") {
                expect(subject.calcTipWithTipPct(0.2)).to(beCloseTo(6.2736))
            }
        }
        
        describe("-subscribe(_:)") {
            context("when there are no changes") {
                it("does not notify") {
                    expect(observer.handled).to(beFalse())
                }
            }

            context("when total is changed") {
                it("notifies observer") {
                    subject.total = 34
                    expect(observer.handled).to(beTrue())
                }
            }
            
            context("when taxPercentage is changed") {
                it("notifies observer") {
                    subject.taxPercentage = 0.41
                    expect(observer.handled).to(beTrue())
                }
            }
        }
    }
}

class MockTipCalculatorModelObserver: TipCalculatorModelObserver {
    var handled = false
    
    func handleTipCalculatorModelChange(model: TipCalculatorModel) {
        handled = true
    }
}