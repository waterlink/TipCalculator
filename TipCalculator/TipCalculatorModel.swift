class TipCalculatorModel {
    private let total: Double
    private let taxPct: Double
    
    init(total: Double, taxPct: Double) {
        self.total = total
        self.taxPct = taxPct
    }
    
    func calcTipWithTipPct(tipPct: Double) -> Double {
        return subtotal() * tipPct
    }
    
    private func subtotal() -> Double {
        return total / (taxPct + 1)
    }
}