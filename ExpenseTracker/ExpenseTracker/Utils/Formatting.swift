import Foundation

extension Double {
    func formattedCurrency(code: String, locale: Locale = .current) -> String {
        formatted(.currency(code: code).locale(locale))
    }

    func currencyEditingValue(locale: Locale = .current) -> String {
        let value = (self * 100).rounded() / 100
        return value.formatted(.number.precision(.fractionLength(2)).locale(locale))
    }
}

extension String {
    var doubleValue: Double {
        Double(replacingOccurrences(of: ",", with: ".")) ?? 0
    }
}

extension Date {
    func detailDateString(locale: Locale = .current) -> String {
        formatted(
            Date.FormatStyle(date: .abbreviated, time: .omitted)
                .locale(locale)
        )
    }

    func monthShort(locale: Locale = .current) -> String {
        formatted(.dateTime.month(.abbreviated).locale(locale))
    }

    func dayMonthShort(locale: Locale = .current) -> String {
        formatted(.dateTime.day().month(.abbreviated).locale(locale))
    }
}
