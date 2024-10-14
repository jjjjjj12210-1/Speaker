import UIKit

final class SpeakerNavBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let standardAppearance = navigationBar.standardAppearance

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundImage = UIImage()
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
