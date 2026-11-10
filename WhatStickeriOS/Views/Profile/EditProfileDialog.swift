import SwiftUI

public struct EditProfileDialog: View {
    @ObservedObject var repository = StickerRepository.shared
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var handle: String = ""
    @State private var bio: String = ""

    public init() {}

    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Thông tin cá nhân")) {
                    TextField("Họ và tên", text: $name)
                    TextField("Tên người dùng (Handle)", text: $handle)
                }

                Section(header: Text("Tiểu sử (Bio)")) {
                    TextField("Giới thiệu ngắn gọn...", text: $bio, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Chỉnh sửa Hồ sơ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        repository.userProfile.name = name
                        repository.userProfile.handle = handle
                        repository.userProfile.bio = bio
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                }
            }
            .onAppear {
                name = repository.userProfile.name
                handle = repository.userProfile.handle
                bio = repository.userProfile.bio
            }
        }
    }
}
