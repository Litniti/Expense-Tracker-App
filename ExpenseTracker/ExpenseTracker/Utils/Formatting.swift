import Foundation

extension Double {
    func formattedCurrency(code: String) -> String {
        formatted(.currency(code: code))
    }

    var currencyEditingValue: String {
        let value = (self * 100).rounded() / 100
        return value.formatted(.number.precision(.fractionLength(2)))
    }
}

extension String {
    var doubleValue: Double {
        Double(replacingOccurrences(of: ",", with: ".")) ?? 0
    }
}

extension Date {
    var detailDateString: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var monthShort: String {
        formatted(.dateTime.month(.abbreviated))
    }

    var dayMonthShort: String {
        formatted(.dateTime.day().month(.abbreviated))
    }
}
