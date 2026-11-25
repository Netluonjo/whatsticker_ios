import SwiftUI

public struct ImportCodeDialog: View {
    @ObservedObject var repository = StickerRepository.shared
    @Environment(\.dismiss) private var dismiss

    @State private var codeText: String = ""
    @State private var errorMessage: String?
    @State private var importSuccess: Bool = false
    @State private var importedPackTitle: String = ""

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "#00D2D3"))
                    .padding(.top, 24)

                VStack(spacing: 6) {
                    Text("Nhập Mã Bộ Sticker")
                        .font(.system(size: 20, weight: .bold))

                    Text("Nhập mã định danh 6-7 ký tự (Ví dụ: WS-MEME, WS-CAPY) để tải toàn bộ sticker từ bạn bè.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                TextField("WS-XXXX", text: $codeText)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .padding(14)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)

                if let err = errorMessage {
                    Text(err)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                }

                Button(action: handleImport) {
                    Text("Tải & Nhập Bộ Sticker")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#00D2D3"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 32)
                }

                Spacer()
            }
            .navigationTitle("Nhập Mã Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") { dismiss() }
                }
            }
            .alert(isPresented: $importSuccess) {
                Alert(
                    title: Text("Nhập thành công! 🎉"),
                    message: Text("Đã thêm bộ '\(importedPackTitle)' vào danh sách của bạn."),
                    dismissButton: .default(Text("Tuyệt vời"), action: { dismiss() })
                )
            }
        }
    }

    private func handleImport() {
        guard !codeText.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Vui lòng nhập mã code hợp lệ."
            return
        }

        if let pack = repository.importPackByCode(codeText) {
            importedPackTitle = pack.title
            importSuccess = true
        } else {
            errorMessage = "Không tìm thấy bộ sticker tương ứng với mã này."
        }
    }
}

