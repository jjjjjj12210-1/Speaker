import UIKit
import MessageUI
import StoreKit

final class MailService: NSObject {

    weak var controller: UIViewController?
    private let supportMail = "Anna_chvertkova_1991@icloud.com"

    init(controller: UIViewController? = nil) {
        self.controller = controller
    }

    func sendEmailToSupport() {
        if MFMailComposeViewController.canSendMail() {

            let mail = MFMailComposeViewController()

            mail.setToRecipients([supportMail])
            mail.mailComposeDelegate = self
//            mail.modalPresentationStyle = .fullScreen
            controller?.present(mail, animated: true)
        } else {
            guard let url = URL(string: "mailto:\(supportMail)") else {
                return
            }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}

extension MailService: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
        self.controller?.navigationController?.popViewController(animated: true)
    }
}
