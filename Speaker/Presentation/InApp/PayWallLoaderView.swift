import UIKit

final class PayWallLoaderView: UIView {

    //MARK: - Property


    //MARK: - UI

    private var activityView: UIView?

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Constraits
extension PayWallLoaderView {

    func showSpinner() {
        DispatchQueue.main.async { [self] in
            activityView = UIView(frame: self.bounds)
            activityView?.backgroundColor = .clear

            guard let activityView = activityView else {return}
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = activityView.center
            activityIndicator.startAnimating()
            activityView.addSubview(activityIndicator)
            self.addSubview(activityView)
        }
    }

    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }
}
