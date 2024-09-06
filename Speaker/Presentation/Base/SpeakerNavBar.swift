import UIKit

final class SpeakerNavBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let standardAppearance = navigationBar.standardAppearance

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true

        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.poppins(.bold, size: 16)
        ]
    }
}
