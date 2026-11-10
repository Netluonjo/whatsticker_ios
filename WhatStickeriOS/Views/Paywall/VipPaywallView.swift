import SwiftUI

public struct VipPaywallView: View {
    @ObservedObject var storeKit = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Icon
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#FFD32A"), Color(hex: "#FF9F43")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 80, height: 80)
                            Image(systemName: "crown.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }

                        Text("WhatSticker VIP Pro")
                            .font(.system(size: 26, weight: .black))

                        Text("Mở khóa toàn bộ sức mạnh sáng tạo không giới hạn")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 16)

                    // Features List
                    VStack(alignment: .leading, spacing: 14) {
                        featureRow(icon: "wand.and.stars.inverse", title: "Tách Nền Vision AI Không Giới Hạn", desc: "Thuật toán CoreML & Vision chính xác tới từng sợi tóc.")
                        featureRow(icon: "play.circle.fill", title: "Mở Khóa Toàn Bộ Sticker Động", desc: "Tạo và xuất Animated Stickers không giới hạn số lượng.")
                        featureRow(icon: "sparkles.rectangle.stack.fill", title: "Truy Cập Hơn 500+ Bộ VIP Độc Quyền", desc: "Cập nhật các bộ meme trending mỗi tuần.")
                        featureRow(icon: "nosign", title: "100% Không Quảng Cáo", desc: "Trải nghiệm mượt mà, tốc độ phản hồi tức thì.")
                    }
                    .padding(.horizontal, 20)

                    // Plan Selection Cards
                    VStack(spacing: 12) {
                        ForEach(StoreKitManager.SubscriptionPlan.allCases) { plan in
                            Button(action: { storeKit.selectedPlan = plan }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 8) {
                                            Text(plan.rawValue)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.primary)

                                            if let badge = plan.badge {
                                                Text(badge)
                                                    .font(.system(size: 10, weight: .heavy))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.red)
                                                    .cornerRadius(6)
                                            }
                                        }

                                        Text(plan.priceString)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: storeKit.selectedPlan == plan ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(storeKit.selectedPlan == plan ? Color(hex: "#00D2D3") : .secondary)
                                }
                                .padding(16)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(hex: "#00D2D3"), lineWidth: storeKit.selectedPlan == plan ? 2 : 0)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Subscribe CTA Button
                    Button(action: {
                        storeKit.purchase(plan: storeKit.selectedPlan)
                        dismiss()
                    }) {
                        Text(storeKit.isVipSubscribed ? "Bạn Đã Là Thành Viên VIP" : "Bắt Đầu Trải Nghiệm VIP Ngay")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient(colors: [Color(hex: "#00D2D3"), Color(hex: "#54A0FF")], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(color: Color(hex: "#00D2D3").opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .disabled(storeKit.isVipSubscribed)

                    // Restore & Legal
                    HStack(spacing: 16) {
                        Button("Khôi phục gói mua") {
                            storeKit.restorePurchases()
                            dismiss()
                        }
                        Text("•")
                        Button("Điều khoản") {}
                        Text("•")
                        Button("Bảo mật") {}
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 22))
                    }
                }
            }
        }
    }

    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "#00D2D3"))
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
}
