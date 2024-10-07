import UIKit

final class SpeakerNavBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let standardAppearance = navigationBar.standardAppearance

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.clear
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.poppins(.bold, size: 16)
        ]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.poppins(.bold, size: 16)
        ]
    }
}
