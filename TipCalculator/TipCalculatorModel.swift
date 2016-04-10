class TipCalculatorModel {
    var total: Double
    var taxPercentage: Double
    
    init(total: Double, taxPercentage: Double) {
        self.total = total
        self.taxPercentage = taxPercentage
    }
    
    func calcTipWithTipPct(tipPct: Double) -> Double {
        return subtotal() * tipPct
    }
    
    private func subtotal() -> Double {
        return total / (taxPercentage + 1)
    }
}