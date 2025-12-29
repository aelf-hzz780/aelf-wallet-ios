//
//  WalletShutdownAlertView.swift
//  AelfApp
//
//  Created on 2024.
//  Copyright © 2024 AELF. All rights reserved.
//

import UIKit
import SwiftMessages

/// 钱包关闭引导弹窗 - 引导用户迁移到 FairyVault 钱包
class WalletShutdownAlertView: MessageView {
    
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var downloadTitleLabel: UILabel!
    @IBOutlet weak var downloadLinkButton: UIButton!
    @IBOutlet weak var tutorialTitleLabel: UILabel!
    @IBOutlet weak var tutorialLinkButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    private static let downloadURL = "https://fairyvault.com/download"
    private static let tutorialURL = "https://fairyvault.gitbook.io/fairyvault-docs/wallet-creation-and-login/publish-your-docs"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // 设置链接按钮样式
        downloadLinkButton.setTitleColor(.master, for: .normal)
        tutorialLinkButton.setTitleColor(.master, for: .normal)
        
        // 添加下划线效果
        let downloadAttr = NSAttributedString(
            string: WalletShutdownAlertView.downloadURL,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.master
            ]
        )
        downloadLinkButton.setAttributedTitle(downloadAttr, for: .normal)
        
        let tutorialAttr = NSAttributedString(
            string: "View Tutorial".localized(),
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.master
            ]
        )
        tutorialLinkButton.setAttributedTitle(tutorialAttr, for: .normal)
    }
    
    /// 显示钱包关闭弹窗
    class func show() {
        guard let view = WalletShutdownAlertView.loadFromNib(named: WalletShutdownAlertView.className) as? WalletShutdownAlertView else { return }
        
        // 设置多语言文本
        view.alertTitleLabel.text = "Wallet Shutdown Notice".localized()
        view.alertMessageLabel.text = "Wallet shutdown message".localized()
        view.downloadTitleLabel.text = "Download FairyVault".localized()
        view.tutorialTitleLabel.text = "How to import your wallet".localized()
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true) // 允许点击背景关闭
        config.interactiveHide = false
        
        SwiftMessages.show(config: config, view: view)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        SwiftMessages.hide()
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        openURL(WalletShutdownAlertView.downloadURL)
    }
    
    @IBAction func tutorialButtonTapped(_ sender: UIButton) {
        openURL(WalletShutdownAlertView.tutorialURL)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

