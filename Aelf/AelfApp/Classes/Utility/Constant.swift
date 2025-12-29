//
//  AppConst.swift
//  AelfApp
//
//  Created by 晋先森 on 2019/5/23.
//  Copyright © 2019 AELF. All rights reserved.
//

import UIKit

// 屏幕宽高
let screenBounds = UIScreen.main.bounds
let screenWidth = screenBounds.width
let screenHeight = screenBounds.height

// Helper to get safe area insets for modern iOS
var safeAreaInsets: UIEdgeInsets {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        return .zero
    }
    return window.safeAreaInsets
}

// Check if device has notch (iPhone X and later)
var isIphoneX: Bool {
    return safeAreaInsets.bottom > 0
}

var iPHONE_NAVBAR_HEIGHT: CGFloat {
    return isIphoneX ? 88 : 64
}

var iPHONE_TABBAR_HEIGHT: CGFloat {
    return isIphoneX ? 83 : 49
}

var iPHONE_STATUS_HEIGHT: CGFloat {
    return safeAreaInsets.top > 0 ? safeAreaInsets.top : 20
}

var iPHONE_BOTTOM_HEIGHT: CGFloat {
    return safeAreaInsets.bottom
}

//let itunesURLString = "https://itunes.apple.com/cn/app/id\(appStoreID)"

struct Define {
    static let decimals = 8 // AElf  精度8位
    static let decimalsValue = Double(1e8) // AELF 精度8位
    static let defaultChainID = "AELF"
    static let elfPrefix = "ELF"
}

let enableDeBugKit = true

struct NotificationName {
    static let updateAssetData = NSNotification.name("updateAssetData") // 导入/创建钱包成功调用
    static let currencyDidChange = NSNotification.name("currencyDidChange") // 展示币种发生变化调用
    static let assetDisplayModeChange = NSNotification.name("assetDisplayModeChange") // 资产展示方式发生变化调用, by token/chain
}
