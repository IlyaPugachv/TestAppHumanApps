import UIKit

extension UIButton {

    func configureButton(systemImageName: String, tintColor: UIColor) {
        setImage(UIImage(systemName: systemImageName), for: .normal)
        self.tintColor = tintColor
    }
}
