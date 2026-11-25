import Foundation
import SwiftUI
import StoreKit

public final class StoreKitManager: ObservableObject {
    public static let shared = StoreKitManager()

    @Published public var isVipSubscribed: Bool = false
    @Published public var selectedPlan: SubscriptionPlan = .yearly

    public enum SubscriptionPlan: String, CaseIterable, Identifiable {
        case monthly = "Monthly VIP"
        case yearly = "Annual VIP (Best Value)"
        case lifetime = "Lifetime VIP"

        public var id: String { rawValue }

        public var priceString: String {
            switch self {
            case .monthly: return "$4.99 / tháng"
            case .yearly: return "$29.99 / năm (Chỉ $2.49/tháng)"
            case .lifetime: return "$59.99 Mua một lần"
            }
        }

        public var badge: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "TIẾT KIỆM 50%"
            case .lifetime: return "TRỌN ĐỜI"
            }
        }
    }

    private let vipKey = "com.whatsticker.ios.vip_status"

    public init() {
        self.isVipSubscribed = UserDefaults.standard.bool(forKey: vipKey)
    }

    public func purchase(plan: SubscriptionPlan) {
        // Mock purchase success
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.isVipSubscribed = true
            UserDefaults.standard.set(true, forKey: self.vipKey)
        }
    }

    public func restorePurchases() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isVipSubscribed = true
            UserDefaults.standard.set(true, forKey: self.vipKey)
        }
    }
}

