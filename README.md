# WhatSticker - Sticker Maker (iOS)

Ứng dụng tạo, tùy biến và chia sẻ bộ sticker động & tĩnh cho các nền tảng nhắn tin (WhatsApp, Telegram, iMessage, Zalo...), được thiết kế và phát triển tối ưu 100% bằng **SwiftUI**, **Apple Vision AI Framework**, **CoreImage**, và **AVFoundation** dành cho iOS 16+.

Tham chiếu ứng dụng gốc trên App Store: [WhatSticker - Sticker Maker](https://apps.apple.com/us/app/whatsticker-sticker-maker/id1147094379)

---

## 🚀 Hướng Dẫn Mở & Chạy Dự Án Trên Xcode

### Yêu Cầu Môi Trường
- **Hệ điều hành**: macOS Ventura 13.5+ hoặc macOS Sonoma / Sequoia 15+.
- **Xcode**: Xcode 15.0+ hoặc Xcode 16.x.
- **Mục tiêu triển khai (Deployment Target)**: iOS 16.0+.
- **Thiết bị chạy**: Máy ảo iPhone Simulator (iPhone 14/15/16 Pro) hoặc iPhone thật.

### Các Bước Khởi Chạy:
1. Mở thư mục dự án `whatsticker_ios` trên máy Mac.
2. Mở file project:
   ```bash
   open WhatStickeriOS.xcodeproj
   ```
3. Tại thanh công cụ trên cùng của Xcode, chọn Simulator (ví dụ: **iPhone 16 Pro**).
4. Nhấn tổ hợp phím **`Cmd + R`** (Run) để biên dịch và trải nghiệm app!

---

## 🌟 7 Phân Hệ Tính Năng Cốt Lõi

### 1. 🔮 Tách Nền AI Tự Động (Apple Vision Framework & Magic Cut)
- Tích hợp **Vision AI**:
  - iOS 17+: Sử dụng `VNGenerateForegroundInstanceMaskRequest` để nhận diện phân tách chủ thể tức thì.
  - iOS 16+: Sử dụng `VNGeneratePersonSegmentationRequest` với độ chính xác cao `qualityLevel = .accurate`.
- Xử lý 100% On-Device (trên thiết bị), hoàn toàn ngoại tuyến và bảo mật ảnh người dùng.
- Tự động tạo hiệu ứng **Die-cut Sticker Outline**: Viền trắng hoặc màu bo quanh chủ thể với thanh trượt độ dày từ 0px đến 24px.
- **Tập tin phụ trách**: `Services/MagicSelectorEngine.swift`, `Services/StickerProcessor.swift`.

### 2. 🎬 Trình Biên Tập Sticker Động (Animated Stickers)
- Trích xuất khung hình tự động từ clip ngắn hoặc ảnh động GIF bằng `AVAssetImageGenerator` & `ImageIO`.
- Trình phát vòng lặp (Loop Preview) theo thời gian thực.
- Tùy chỉnh tốc độ khung hình từ **6 FPS đến 24 FPS**.
- Xuất dữ liệu định dạng chuẩn GIF / Animated WebP tương thích cao.
- **Tập tin phụ trách**: `Services/AnimatedStickerHelper.swift`, `Views/Editor/AnimatedEditorView.swift`.

### 3. 🎨 Sticker Studio & Chỉnh Sửa Chuyên Nghiệp
- **Thêm Chữ (Caption Text)**: Chèn chữ phong cách Meme viền đen chữ trắng, hỗ trợ kéo thả trực tiếp trên màn hình cảm ứng.
- **Thư viện Emoji**: Hàng chục emoji biểu cảm sinh động, có thể phóng to thu nhỏ và định vị trên sticker.
- **Lưới caro trong suốt (Checkerboard)** mô phỏng môi trường transparent PNG chuẩn xác.
- **Tập tin phụ trách**: `Views/Editor/StickerEditorView.swift`, `Models/EditorModels.swift`.

### 4. 🎭 Kho Mẫu Meme 1-Chạm (Meme Templates)
- Tích hợp sẵn 10+ mẫu meme kinh điển được yêu thích nhất toàn cầu:
  - *Drake Hotline Bling*
  - *Distracted Boyfriend*
  - *Buff Doge vs Cheems*
  - *Woman Yelling at Cat*
  - *Surprised Pikachu*
  - *Trade Offer*
  - *GigaChad*
  - *This is Fine*
  - *Expanding Brain*
- Hỗ trợ đổi chữ Top/Bottom Text và xuất trực tiếp thành sticker vào bộ sưu tập chỉ với 1 chạm.
- **Tập tin phụ trách**: `Services/PresetData.swift`, `Views/Templates/TemplatesView.swift`, `Views/Templates/MemeCreatorSheet.swift`.

### 5. 🔍 Khám Phá Cộng Đồng (Explore & Trending Packs)
- Duyệt qua hàng loạt bộ sticker theo danh mục: *Memes, Cute, Reactions, Animals, Anime, Love, Gaming*.
- Xem trước chi tiết từng sticker trong bộ, lượt thích, lượt tải, và trạng thái xác minh của tác giả.
- Hỗ trợ tìm kiếm theo tên bộ sticker, tác giả hoặc mã code.
- **Tập tin phụ trách**: `Views/Explore/ExploreView.swift`, `Views/Explore/PackDetailSheet.swift`.

### 6. 📤 Xuất Sticker Trực Tiếp Sang WhatsApp & Telegram
- **Giao thức WhatsApp iOS chính thức**:
  - Đóng gói dictionary theo chuẩn WhatsApp: `identifier`, `tray_image`, `stickers` (PNG 512x512 trong suốt kèm emojis).
  - Giao tiếp qua `UIPasteboard` hệ thống và URL scheme `whatsapp://stickerPack`.
- **Telegram Export**:
  - Tích hợp mở trực tiếp Telegram bot `@Stickers` (`tg://resolve?domain=Stickers`).
  - Hỗ trợ iOS Share Sheet (`UIActivityViewController`) xuất file sang iMessage, AirDrop, Zalo, Files.
- **Hệ thống Mã Chia Sẻ (Pack Code)**:
  - Tự động sinh mã định danh 6 ký tự (VD: `WS-MEME`, `WS-CAPY`).
  - Cho phép người dùng nhập mã tại `ImportCodeDialog` để tải trọn bộ sticker từ bạn bè trong 1 giây.
- **Tập tin phụ trách**: `Services/WhatsAppExporter.swift`, `Services/TelegramExporter.swift`, `Views/MyPacks/ImportCodeDialog.swift`.

### 7. 👑 Gói VIP Subscription & Hồ Sơ Nhà Sáng Tạo
- **StoreKit 2 Integration**:
  - Gói Tuần / Tháng: `$4.99/tháng`
  - Gói Năm (Tiết kiệm 50%): `$29.99/năm`
  - Gói Trọn đời: `$59.99`
  - Tính năng VIP: Tách nền AI không giới hạn, mở khóa 500+ bộ VIP, không quảng cáo.
- **Hồ sơ Cá nhân**:
  - Tùy chỉnh Avatar, Tên, Bio, liên kết mạng xã hội (Instagram, TikTok, X).
  - Thống kê lượt Follower, Following, và danh sách các bộ sticker tự tạo.
- **Tập tin phụ trách**: `Services/StoreKitManager.swift`, `Views/Paywall/VipPaywallView.swift`, `Views/Profile/ProfileView.swift`.

---

## 📁 Cấu Trúc Thư Mục Dự Án

```
D:/whatsticker_ios/
├── WhatStickeriOS.xcodeproj/    # File project Xcode chuẩn
├── Package.swift               # Swift Package Manager config
├── README.md                   # Tài liệu hướng dẫn chi tiết
└── WhatStickeriOS/
    ├── WhatStickeriOSApp.swift # App Entry Point
    ├── Info.plist              # Cấu hình quyền Photos, Camera, URL schemes
    ├── Assets.xcassets/        # AppIcon & tài nguyên đồ họa
    ├── Models/
    │   ├── StickerModels.swift # Model dữ liệu Sticker, Pack, Meme, Profile
    │   └── EditorModels.swift  # Model công cụ, lớp chữ, emoji, thao tác
    ├── Services/
    │   ├── MagicSelectorEngine.swift # Tách nền Vision AI trên iOS
    │   ├── StickerProcessor.swift    # Viền Die-cut & xuất ảnh 512x512
    │   ├── AnimatedStickerHelper.swift# Trích xuất khung hình Video/GIF
    │   ├── StickerRepository.swift   # Quản lý kho sticker & mã Pack Code
    │   ├── PresetData.swift          # Dữ liệu mẫu Meme & Packs có sẵn
    │   ├── WhatsAppExporter.swift    # Giao thức xuất sang WhatsApp
    │   ├── TelegramExporter.swift    # Xuất Telegram & Universal Share
    │   └── StoreKitManager.swift     # Quản lý gói VIP In-App Purchases
    └── Views/
        ├── MainTabView.swift         # Thanh điều hướng 5 Tab chính
        ├── Explore/
        │   ├── ExploreView.swift     # Màn hình Khám phá & Banner
        │   └── PackDetailSheet.swift # Chi tiết bộ sticker & Nút xuất
        ├── Templates/
        │   ├── TemplatesView.swift   # Danh sách Meme kinh điển
        │   └── MemeCreatorSheet.swift# Trình tạo Meme 1 chạm
        ├── Editor/
        │   ├── CreateOptionsSheet.swift # Menu chọn loại sticker muốn tạo
        │   ├── StickerEditorView.swift  # Canvas chỉnh sửa ảnh & Tách nền AI
        │   └── AnimatedEditorView.swift # Trình tạo sticker động FPS
        ├── MyPacks/
        │   ├── MyPacksView.swift     # Quản lý các bộ sticker tự tạo
        │   └── ImportCodeDialog.swift# Nhập mã chia sẻ WS-XXXX
        ├── Profile/
        │   ├── ProfileView.swift     # Hồ sơ tác giả & mạng xã hội
        │   └── EditProfileDialog.swift
        └── Paywall/
            └── VipPaywallView.swift  # Màn hình đăng ký VIP Pro
```

