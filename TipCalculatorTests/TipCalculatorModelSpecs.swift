import Quick
import Nimble

@testable import TipCalculator

class TipCalculatorModelSpecs: QuickSpec {
    override func spec() {
        describe("-calcTipWithTipPct(_:)") {
            let subject = TipCalculatorModel(total: 33.25, taxPercentage: 0.06)
            
            it("returns correct value for 18%") {
                expect(subject.calcTipWithTipPct(0.18)).to(beCloseTo(5.6462))
            }
            
            it("returns correct value for 20%") {
                expect(subject.calcTipWithTipPct(0.2)).to(beCloseTo(6.2736))
            }
        }
    }
}