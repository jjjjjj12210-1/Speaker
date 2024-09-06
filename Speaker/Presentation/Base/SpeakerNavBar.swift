import UIKit

final class SpeakerNavBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let standardAppearance = navigationBar.standardAppearance

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = true

        standardAppearance.shadowImage = nil
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundEffect = nil
        standardAppearance.backgroundColor = .clear

        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.poppins(.bold, size: 16)
        ]
    }
}
