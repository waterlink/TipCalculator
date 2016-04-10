protocol TipCalculatorModelObserver {
    func handleTipCalculatorModelChange(model: TipCalculatorModel)
}

class TipCalculatorModel {
    var total: Double { didSet { notifyObservers() } }
    var taxPercentage: Double { didSet { notifyObservers() } }
    
    var observer: TipCalculatorModelObserver?
    
    init(total: Double, taxPercentage: Double) {
        self.total = total
        self.taxPercentage = taxPercentage
    }
    
    func calcTipWithTipPct(tipPct: Double) -> Double {
        return subtotal() * tipPct
    }
    
    func subscribe(observer: TipCalculatorModelObserver) {
        self.observer = observer
    }
    
    private func subtotal() -> Double {
        return total / (taxPercentage + 1)
    }
    
    private func notifyObservers() {
        observer?.handleTipCalculatorModelChange(self)
    }
}