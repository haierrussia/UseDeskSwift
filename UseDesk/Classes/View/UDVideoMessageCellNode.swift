//
//  UDVideoMessageCellNode.swift
//  UseDesk_SDK_Swift
//

import UIKit
import Foundation
import AsyncDisplayKit

class UDVideoMessageCellNode: UDMessageCellNode {
    private var previewImageNode = ASImageNode()
    private var playNode = ASImageNode()
    private var loaderNode = ASDisplayNode()
    private var loaderBackNode = ASDisplayNode()
    private var activityIndicator = UIActivityIndicatorView()
    
    var messageTextParagraphStyle = NSMutableParagraphStyle()
    
    weak var usedesk: UseDeskSDK?
    
    override init() {
        super.init()
        previewImageNode.addTarget(self, action: #selector(self.actionTapBubble), forControlEvents: .touchUpInside)
        playNode.addTarget(self, action: #selector(self.actionTapBubble), forControlEvents: .touchUpInside)
    }
    
    override func bindData(messagesView messagesView_: UDMessagesView?, message : UDMessage, avatarImage: UIImage?) {
        messagesView = messagesView_
        self.message = message
        let videoStyle = configurationStyle.videoStyle
        isPictureOrVideoType = true
        
        let widthLoaderView: CGFloat = 48
        
        playNode.removeFromSupernode()
        playNode.image = UIImage.named("udVideoPlay") 
        playNode.style.width = ASDimensionMakeWithPoints(widthLoaderView - 10)
        playNode.style.height = ASDimensionMakeWithPoints(widthLoaderView - 10)
        
        loaderBackNode.removeFromSupernode()
        loaderBackNode = ASDisplayNode(viewBlock: { () -> UIView in
            let activityBackView = UIView()
            let backView = UIView()
            activityBackView.backgroundColor = .clear
            activityBackView.layer.masksToBounds = true
            activityBackView.layer.cornerRadius = widthLoaderView / 2
            backView.backgroundColor = UIColor(hexString: "454D63")
            backView.alpha = 0.4
            backView.frame = CGRect(x: 0, y: 0, width: widthLoaderView, height: widthLoaderView)
            activityBackView.addSubview(backView)
            return activityBackView
        })
        loaderBackNode.style.width = ASDimensionMakeWithPoints(widthLoaderView)
        loaderBackNode.style.height = ASDimensionMakeWithPoints(widthLoaderView)
        
        loaderNode.removeFromSupernode()
        loaderNode = ASDisplayNode(viewBlock: { [weak self] () -> UIView in
            guard let wSelf = self else {return UIView()}
            wSelf.activityIndicator = UIActivityIndicatorView(style: .white)
            wSelf.activityIndicator.hidesWhenStopped = false
            if message.status == RC_STATUS_OPENIMAGE {
                wSelf.activityIndicator.startAnimating()
                wSelf.activityIndicator.alpha = 1
                wSelf.playNode.alpha = 0
            } else {
                if message.status == RC_STATUS_SUCCEED {
                    wSelf.activityIndicator.stopAnimating()
                    wSelf.activityIndicator.alpha = 0
                    wSelf.playNode.alpha = 1
                } else {
                    wSelf.activityIndicator.startAnimating()
                    wSelf.activityIndicator.alpha = 1
                    wSelf.playNode.alpha = 0
                }
            }
            return wSelf.activityIndicator
        })
        
        previewImageNode.removeFromSupernode()
        if message.file.picture != nil {
            previewImageNode.image = message.file.picture
        } else if message.file.path != "" {
            previewImageNode.image = UDFileManager.videoPreview(filePath: message.file.path)
        } else {
            previewImageNode.image = videoStyle.imageDefault
        }
        previewImageNode.contentMode = .scaleAspectFit
        previewImageNode.cornerRadius = videoStyle.cornerRadius
        
        addSubnode(previewImageNode)
        addSubnode(loaderBackNode)
        addSubnode(playNode)
        addSubnode(loaderNode)
        
        super.bindData(messagesView: messagesView, message: message, avatarImage: avatarImage)
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let messageStyle = configurationStyle.messageStyle
        let videoStyle = configurationStyle.videoStyle
        
        let playAndLoaderOverlaySpec = ASOverlayLayoutSpec()
        let centerplayAndLoaderSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: loaderNode)
        playAndLoaderOverlaySpec.overlay = centerplayAndLoaderSpec
        playAndLoaderOverlaySpec.child = playNode
        
        let loaderBackOverlaySpec = ASOverlayLayoutSpec()
        let centerLoaderSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: playAndLoaderOverlaySpec)
        loaderBackOverlaySpec.overlay = centerLoaderSpec
        loaderBackOverlaySpec.child = loaderBackNode
        
        let sizeMessagesManager = UDSizeMessagesManager(messagesView: messagesView, message: message, indexPath: indexPath, configurationStyle: configurationStyle)
        let sizeImageNode = sizeMessagesManager.sizeImageMessageFrom(size: CGSize(width: message.file.picture?.size.width ?? 0, height: message.file.picture?.size.height ?? 0))
        previewImageNode.style.width = ASDimensionMakeWithPoints(sizeImageNode.width)
        previewImageNode.style.height = ASDimensionMakeWithPoints(sizeImageNode.height)
        
        let imageWithLoaderStack = ASOverlayLayoutSpec()
        let centerLoaderBackSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: loaderBackOverlaySpec)
        imageWithLoaderStack.overlay = centerLoaderBackSpec
        imageWithLoaderStack.child = previewImageNode

        var timeEndSendedLayoutElements: [ASLayoutElement] = [timeNode]
        if message.outgoing {
            timeEndSendedLayoutElements.append(sendedImageNode)
        }
        let horizonTimeAndSendedSpec = ASStackLayoutSpec(direction: .horizontal, spacing: message.outgoing ? messageStyle.sendedStatusMargin.left : messageStyle.timeMargin.right, justifyContent: .start, alignItems: ASStackLayoutAlignItems.start, children: timeEndSendedLayoutElements)
        let timeBackSpec = ASBackgroundLayoutSpec()
        timeBackSpec.background = timeBackNode
        timeBackSpec.child = ASInsetLayoutSpec(insets: UIEdgeInsets(top: messageStyle.timeBackViewPadding.top, left: messageStyle.timeBackViewPadding.left, bottom: messageStyle.timeBackViewPadding.bottom, right: messageStyle.timeBackViewPadding.right), child: horizonTimeAndSendedSpec)
        
        let timeFromImageOverlaySpec = ASOverlayLayoutSpec()
        let timeCenterSpec = ASCenterLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumWidth, child: timeBackSpec)
        timeFromImageOverlaySpec.overlay = timeCenterSpec
        timeFromImageOverlaySpec.child = imageWithLoaderStack
        
        contentMessageInsetSpec = ASInsetLayoutSpec(insets: videoStyle.margin, child: timeFromImageOverlaySpec)
        let messageLayoutSpec = super.layoutSpecThatFits(constrainedSize)
        return messageLayoutSpec
    }
    
    // MARK: - User actions
    @objc func actionTapBubble() {
        messagesView?.view.endEditing(true)
        messagesView?.actionTapBubble(indexPath)
    }
}

