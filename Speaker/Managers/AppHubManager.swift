import Foundation
import StoreKit
import ApphudSDK

protocol AppHubManagerDelegate {
    func purchasesWasEnded(success: Bool?, messageError: String)
    func finishLoadPaywall()
}

final class AppHubManager: NSObject {

    enum Products {
        case trialWeek
        case year
        case mounth
        case week
    }

    static let shared = AppHubManager()
    @objc dynamic var isLoadInapp = false

    @objc private(set) var products: [SKProduct] = []
    private var productIds : Set<String> = []

    private var currentProduct: SKProduct?
    var subscriptionsOnboard: [ApphudProduct] = []
    var subscriptions: [ApphudProduct] = []

    var isPremium: Bool { Apphud.hasActiveSubscription() }

    var isSubscribed: Bool = false

    var delegate: AppHubManagerDelegate?

    func mouthSubscription() -> ApphudProduct? {
        getProductFor(id: "month.speakerapp")
    }

    func weekSubscription() -> ApphudProduct? {
        getProductFor(id: "week.speakerapp")
    }

    func yearSubscription() -> ApphudProduct? {
        getProductFor(id: "year.speakerapp")
    }

    func weekTrialSubscription() -> ApphudProduct? {
        return subscriptionsOnboard.first(where: { item in
            item.productId == "week.trial.speakerapp"
        })
    }

    func getProductFor(id: String) -> ApphudProduct? {
        return subscriptions.first(where: { item in
            item.productId == id
        })
    }

    private override init() {
        super.init()
    }
}

extension AppHubManager {

    func getProducts() {
        Task {
            let onboardingPlacement = await Apphud.placement("place_onboarding")
            if let paywall = onboardingPlacement?.paywall {
                let apphudProducts = paywall.products
                self.subscriptionsOnboard = apphudProducts
            }

            let defaultPlacement = await Apphud.placement("place_default")
            if let paywall = defaultPlacement?.paywall {
                let apphudProducts = paywall.products
                self.subscriptions = apphudProducts
            }
        }
    }

    func getOnboardingInfo() {
        Task {
            let onboardingPlacement = await Apphud.placement("place_onboarding")
            if let paywall = onboardingPlacement?.paywall {
                let apphudProducts = paywall.products
                Apphud.paywallShown(paywall)
                self.subscriptionsOnboard = apphudProducts
                delegate?.finishLoadPaywall()
            }
        }
    }

    func getDefaultInfo() {
        Task {
            let onboardingPlacement = await Apphud.placement("place_default")
            if let paywall = onboardingPlacement?.paywall {
                let apphudProducts = paywall.products
                Apphud.paywallShown(paywall)
                self.subscriptions = apphudProducts
                delegate?.finishLoadPaywall()
            }
        }
    }

    func startPurchase(_ product: ApphudProduct) {
        Task {
            let result = await Apphud.purchase(product)
            if result.success {
                delegate?.purchasesWasEnded(success: true, messageError: "")
            } else {
                let errorMess = result.error?.localizedDescription
                guard errorMess != "The operation couldn’t be completed. (SKErrorDomain error 2.)" else {
                    self.delegate?.purchasesWasEnded(success: nil, messageError: "")
                    return
                }
                delegate?.purchasesWasEnded(success: false, messageError: result.error?.localizedDescription ?? "Error during subscription payment process")
            }
        }
    }

    func restore() {
        Task {
            let result = await Apphud.restorePurchases()
            if let error = result?.localizedDescription {
                delegate?.purchasesWasEnded(success: false, messageError: error)
            } else {
                delegate?.purchasesWasEnded(success: true, messageError: "")
            }
        }
    }
}

extension AppHubManager {

    func getPrice(_ type: Products) -> String {
        guard !subscriptions.isEmpty else {return ""}
        let price = switch type {
        case .trialWeek:
            weekTrialSubscription()?.skProduct?.localizedPrice
        case .year:
            yearSubscription()?.skProduct?.localizedPrice
        case .mounth:
            mouthSubscription()?.skProduct?.localizedPrice
        case .week:
            weekSubscription()?.skProduct?.localizedPrice
        }
        return price ?? "no price"
    }
}
