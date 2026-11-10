import SwiftUI

public struct TemplatesView: View {
    @ObservedObject var repository = StickerRepository.shared
    @Binding var selectedTemplate: MemeTemplate?
    @Binding var showMemeCreator: Bool

    @State private var selectedCategory: String = "All"
    private let categories = ["All", "Classic", "Animals", "Reactions", "Trending"]

    public init(selectedTemplate: Binding<MemeTemplate?>, showMemeCreator: Binding<Bool>) {
        self._selectedTemplate = selectedTemplate
        self._showMemeCreator = showMemeCreator
    }

    private var filteredTemplates: [MemeTemplate] {
        if selectedCategory == "All" {
            return repository.memeTemplates
        } else {
            return repository.memeTemplates.filter { $0.category == selectedCategory }
        }
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                Button(action: { selectedCategory = cat }) {
                                    Text(cat)
                                        .font(.system(size: 14, weight: .semibold))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == cat ? Color(hex: "#FF6B6B") : Color(UIColor.secondarySystemBackground))
                                        .foregroundColor(selectedCategory == cat ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Templates Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                        ForEach(filteredTemplates) { template in
                            memeTemplateCard(for: template)
                                .onTapGesture {
                                    selectedTemplate = template
                                    showMemeCreator = true
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top, 12)
            }
            .navigationTitle("Mẫu Meme Nổi Tiếng")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func memeTemplateCard(for template: MemeTemplate) -> some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: template.accentColorHex).opacity(0.12))
                    .frame(height: 130)

                VStack(spacing: 6) {
                    Image(systemName: template.symbolIcon)
                        .font(.system(size: 38))
                        .foregroundColor(Color(hex: template.accentColorHex))

                    Text(template.category)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: template.accentColorHex))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)

                Text(template.defaultTopText)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .padding(10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
