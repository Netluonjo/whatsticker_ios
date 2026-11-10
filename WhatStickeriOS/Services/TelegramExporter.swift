import Foundation
import UIKit

public final class TelegramExporter {
    public static let shared = TelegramExporter()

    private init() {}

    public var isTelegramInstalled: Bool {
        guard let url = URL(string: "tg://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Opens Telegram @Stickers bot with step-by-step guidance
    public func openTelegramStickersBot() {
        if let directUrl = URL(string: "tg://resolve?domain=Stickers"), UIApplication.shared.canOpenURL(directUrl) {
            UIApplication.shared.open(directUrl)
        } else if let webUrl = URL(string: "https://t.me/Stickers") {
            UIApplication.shared.open(webUrl)
        }
    }

    /// Shares rendered sticker images to iOS share sheet (AirDrop, Files, Telegram, iMessage)
    public func shareStickerPack(pack: StickerPack, from viewController: UIViewController) {
        var imagesToShare: [UIImage] = []

        for sticker in pack.stickers {
            let rendered = StickerProcessor.shared.renderCompositeSticker(
                baseImage: sticker.imageData != nil ? UIImage(data: sticker.imageData!) : nil,
                symbolIcon: sticker.imageSymbol,
                symbolColor: UIColor(hex: sticker.symbolColor) ?? .systemBlue,
                outlineWidth: 6,
                outlineColor: .white,
                textOverlays: [],
                emojiOverlays: []
            )
            imagesToShare.append(rendered)
        }

        let activityVC = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
}
