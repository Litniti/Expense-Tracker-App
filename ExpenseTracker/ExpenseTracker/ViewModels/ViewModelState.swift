import Foundation

enum ViewModelState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
