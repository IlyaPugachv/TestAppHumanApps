import Foundation

extension Settings {
    class Presenter {
        
        // MARK: - Properties -
        
        weak var view: SettingsView?
        
        // MARK: - Initializers
        
        public init() {
            print(#function, self)
        }
        
        deinit {
            print(#function, self)
        }
        
        // MARK: - Methods -
        
        
    }
}


