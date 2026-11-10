import SwiftUI

public struct ProfileView: View {
    @ObservedObject var repository = StickerRepository.shared
    @ObservedObject var storeKit = StoreKitManager.shared
    @Binding var showPaywall: Bool

    @State private var showEditProfile: Bool = false

    public init(showPaywall: Binding<Bool>) {
        self._showPaywall = showPaywall
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar & Info
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: repository.userProfile.avatarSymbol)
                                .font(.system(size: 80))
                                .foregroundColor(Color(hex: "#00D2D3"))
                                .padding(16)
                                .background(Color(hex: "#00D2D3").opacity(0.12))
                                .clipShape(Circle())

                            if repository.userProfile.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                                    .background(Circle().fill(Color.white))
                            }
                        }

                        VStack(spacing: 4) {
                            Text(repository.userProfile.name)
                                .font(.system(size: 22, weight: .bold))

                            Text(repository.userProfile.handle)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }

                        Text(repository.userProfile.bio)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        // Stats bar
                        HStack(spacing: 36) {
                            VStack(spacing: 2) {
                                Text("\(repository.userProfile.followersCount / 1000)k")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Người theo dõi")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }

                            Divider().frame(height: 28)

                            VStack(spacing: 2) {
                                Text("\(repository.userProfile.followingCount)")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Đang theo dõi")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }

                            Divider().frame(height: 28)

                            VStack(spacing: 2) {
                                Text("\(repository.myPacks.count)")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Bộ đã tạo")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)

                        // Action Buttons
                        HStack(spacing: 12) {
                            Button(action: { showEditProfile = true }) {
                                Text("Chỉnh sửa Hồ sơ")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                            }

                            Button(action: { showPaywall = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.yellow)
                                    Text(storeKit.isVipSubscribed ? "VIP PRO" : "Nâng cấp VIP")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(LinearGradient(colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF9F43")], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    // Social Links
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mạng xã hội liên kết")
                            .font(.system(size: 15, weight: .bold))
                            .padding(.horizontal)

                        VStack(spacing: 8) {
                            socialRow(icon: "camera.fill", name: "Instagram", handle: repository.userProfile.socialLinks["instagram"] ?? "@alex")
                            socialRow(icon: "play.rectangle.fill", name: "TikTok", handle: repository.userProfile.socialLinks["tiktok"] ?? "@alex")
                            socialRow(icon: "bubble.left.and.bubble.right.fill", name: "Twitter / X", handle: repository.userProfile.socialLinks["twitter"] ?? "@alex")
                        }
                        .padding(.horizontal)
                    }

                    // Settings Group
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cài đặt chung")
                            .font(.system(size: 15, weight: .bold))
                            .padding(.horizontal)

                        VStack(spacing: 1) {
                            settingRow(icon: "arrow.clockwise", title: "Khôi phục gói mua (Restore)") {
                                storeKit.restorePurchases()
                            }
                            settingRow(icon: "shield.lefthalf.filled", title: "Chính sách bảo mật") {}
                            settingRow(icon: "doc.text", title: "Điều khoản sử dụng") {}
                        }
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Hồ Sơ Của Tôi")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showEditProfile) {
                EditProfileDialog()
            }
        }
    }

    private func socialRow(icon: String, name: String, handle: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#00D2D3"))
                .frame(width: 24)

            Text(name)
                .font(.system(size: 14, weight: .medium))

            Spacer()

            Text(handle)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }

    private func settingRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(14)
        }
    }
}
