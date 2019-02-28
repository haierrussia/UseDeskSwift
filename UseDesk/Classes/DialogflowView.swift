//
//  DialogflowView.swift


import Foundation
import QBImagePickerController
import MBProgressHUD

class DialogflowView: RCMessagesView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, QBImagePickerControllerDelegate {

    var rcmessages: [AnyHashable] = []
    
    private var sendImageArr: [Any] = []
    private var hudErrorConnection: MBProgressHUD!
    private var imageVC: UDImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Gif", style: .done, target: self, action: #selector(self.actionDone))
        
        hudErrorConnection = MBProgressHUD(view: view)
        hudErrorConnection?.removeFromSuperViewOnHide = true
        view.addSubview(hudErrorConnection!)
        
        hudErrorConnection.mode = MBProgressHUDMode.indeterminate//MBProgressHUDModeIndeterminate
        //hudErrorConnection.label.text = @"Loading";
        //dicLoadingBuffer = [AnyHashable : Any]()
        labelAttachmentFile.isHidden = true
        
        //buttonInputAttach.isUserInteractionEnabled = false
        //if ([FUser wallpaper] != nil)
        //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[FUser wallpaper]]];
        
        rcmessages = [AnyHashable]()
        loadEarlierShow(false)
        
        updateTitleDetails()
        
        let use = usedesk as? UseDeskSDK
        use?.connectBlock = { success, error in
            self.hudErrorConnection.hide(animated: true)
            self.reloadhistory()
        }
        
        use?.newMessageBlock = { success, message in

            if let aMessage = message {
                self.rcmessages.append(aMessage)
            }
            self.refreshTableView1()
            
//            if message?.incoming != false {
//                UDAudio.playMessageIncoming()
//            }
        }
        
        use!.feedbackAnswerMessageBlock = { success in
            let alert = UIAlertController(title: "", message: "Спасибо за вашу оценку", preferredStyle: .alert)
            
            
            let yesButton = UIAlertAction(title: "Ok", style: .default, handler: { action in
                //Handle your yes please button action here
            })
            
            alert.addAction(yesButton)
            
            self.present(alert, animated: true)
        }
        
        use!.errorBlock = { errors in
            if (errors?.count ?? 0) > 0 {
                self.hudErrorConnection.label.text = (errors?[0] as! String)
            }
            self.hudErrorConnection.show(animated: true)
        }
        
        use!.feedbackMessageBlock = { message in
            if let aMessage = message {
                self.rcmessages.append(aMessage)
            }
            self.refreshTableView1()
        }
        
        reloadhistory()
    }
    
    func reloadhistory() {
        let use = usedesk as! UseDeskSDK
        for message in (use.historyMess) {
            rcmessages.append(message)
        }
        refreshTableView1()
    }
    
    // MARK: - Message methods
    override func rcmessage(_ indexPath: IndexPath?) -> RCMessage? {
        return (rcmessages[indexPath!.section] as! RCMessage)
    }
    
    func addMessage(_ text: String?, incoming: Bool) {
        let rcmessage = RCMessage(text: text, incoming: incoming)
        rcmessages.append(rcmessage)
        refreshTableView1()
    }
    
    // MARK: - Avatar methods
    override func avatarInitials(_ indexPath: IndexPath?) -> String? {
        let rcmessage = rcmessages[indexPath!.section] as? RCMessage
        if (rcmessage?.outgoing)! {
            return "you"
        } else {
            return "Ad"
        }
    }
    
    override func avatarImage(_ indexPath: IndexPath?) -> UIImage? {
        let rcmessage = rcmessages[indexPath!.section] as? RCMessage
        if rcmessage?.avatar == nil {
            return nil
        }
        var image: UIImage? = nil
        do {
            if  URL(string: rcmessage!.avatar) != nil {
                let anAvatar = URL(string: rcmessage!.avatar)
                let anAvatar1 = try Data(contentsOf: anAvatar!)
                image = UIImage(data: anAvatar1)
                
            } else {
                if rcmessage?.outgoing == true {
                    return UIImage(named: "avatarClient.png")
                } else {
                    return UIImage(named: "avatarOperator.png")
                }
            }
        } catch {
        }
//        if let anAvatar = URL(string: rcmessage.avatar ?? ""), let anAvatar1 = Data(contentsOf: anAvatar) {
//            image = UIImage(data: anAvatar1)
//        }
        return image
    }
    
    // MARK: - Header, Footer methods
    override func textSectionHeader(_ indexPath: IndexPath?) -> String? {
        let rcmessage = rcmessages[indexPath!.section] as! RCMessage
        
        if rcmessage.date!.isToday{
            return rcmessage.date!.timeString
        }
        return rcmessage.date!.timeAndDayString
    }
    
    override func textBubbleHeader(_ indexPath: IndexPath?) -> String? {
        return nil
    }
    
    override func textBubbleFooter(_ indexPath: IndexPath?) -> String? {
        return nil
    }
    
    override func textSectionFooter(_ indexPath: IndexPath?) -> String? {
        let rcmessage = rcmessages[indexPath!.section] as! RCMessage
        if rcmessage.incoming != false {
            return rcmessage.name
        }
        return nil
    }
    
    override func menuItems(_ indexPath: IndexPath?) -> [Any]? {
        let menuItemCopy = RCMenuItem(title: "Copy", action: #selector(self.actionMenuCopy(_:)))
        menuItemCopy.indexPath = indexPath
        return [menuItemCopy]
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.actionMenuCopy(_:)) {
            return true
        }
        return false
    }
    
//    var canBecomeFirstResponder: Bool {
//        return true
//    }
    
    // MARK: - Typing indicator methods
    func typingIndicatorShow(_ show: Bool, animated: Bool, delay: CGFloat) {
        let time = DispatchTime.now() + (Double(delay))
        DispatchQueue.main.asyncAfter(deadline: (time), execute: {
            self.typingIndicatorShow(show, animated: animated)
        })
    }
    
    // MARK: - Title details methods
    func updateTitleDetails() {
        labelTitle1.text = "UseDesk"
        labelTitle2.text = "online now"
    }
    
    // MARK: - Refresh methods
    func refreshTableView1() {
        refreshTableView2()
        scroll(toBottom: true)
    }
    
    func refreshTableView2() {
        tableView.reloadData()
    }
    
    func sendDialogflowRequest(_ text: String?) {
        typingIndicatorShow(true, animated: true, delay: 0.5)
        /*AITextRequest *aiRequest = [apiAI textRequest];
         aiRequest.query = @[text];
         [aiRequest setCompletionBlockSuccess:^(AIRequest *request, id response)
         {
         [self typingIndicatorShow:NO animated:YES delay:1.0];
         [self displayDialogflowResponse:response delay:1.1];
         }
         failure:^(AIRequest *request, NSError *error)
         {
         [ProgressHUD showError:@"Dialogflow request error."];
         }];
         [apiAI enqueue:aiRequest];*/
    }
    
    func displayDialogflowResponse(_ dictionary: [AnyHashable : Any]?, delay: CGFloat) {
        let time = DispatchTime.now() + Double(Double(delay) )
        DispatchQueue.main.asyncAfter(deadline: time , execute: {
            self.displayDialogflowResponse(dictionary)
        })
    }
    
    func displayDialogflowResponse(_ dictionary: [AnyHashable : Any]?) {
        let result = dictionary?["result"] as? [AnyHashable : Any]
        let fulfillment = result?["fulfillment"] as? [AnyHashable : Any]
        let text = fulfillment?["speech"] as? String
        addMessage(text, incoming: true)
        //UDAudio.playMessageIncoming()
    }
    
    // MARK: - User actions
    @objc func actionDone() {
        dismiss(animated: true)
    }
    
    override func actionSendMessage(_ text: String?) {
        //UDAudio.playMessageOutgoing()
        let use = usedesk as? UseDeskSDK
        
        if sendImageArr.count == 0 {
            use?.sendMessage(text)
        } else {
            
            for i in 0..<sendImageArr.count {
                let asset = sendImageArr[i] as? PHAsset

                let options = PHImageRequestOptions()
                options.isSynchronous = true
                if let anAsset = asset {
                    PHCachingImageManager.default().requestImage(for: anAsset, targetSize: CGSize(width: CGFloat(asset?.pixelWidth ?? Int(0.0)), height: CGFloat(asset?.pixelHeight ?? Int(0.0))), contentMode: .aspectFit, options: options, resultHandler: { result, info in
                        //image = result
                        if result != nil {
                            let content = "data:image/png;base64,\(UseDeskSDKHelp.image(toNSString: result!))"
                            var fileName = String(format: "%ld", content.hash)
                            fileName += ".png"
                            //self.dicLoadingBuffer.updateValue("1", forKey: fileName)
                            //dicLoadingBuffer[fileName] = "1"
                            use?.sendMessage(text, withFileName: fileName, fileType: "image/png", contentBase64: content)
                        }
                    })
                }
            }
            sendImageArr = []
            labelAttachmentFile.isHidden = true
        }
    }
    
    override func actionAttachMessage() {
        let alertController = UIAlertController(title: "Select Sharing option:", message:
            nil, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) -> Void in
        }
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .default) { (_) -> Void in
            self.takePhoto()
        }
        let selectFromPhotosAction = UIAlertAction(title: "Select From Photos", style: .default) { (_) -> Void in
            self.selectPhoto()
        }        
        alertController.addAction(takePhotoAction)
        alertController.addAction(selectFromPhotosAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: : Action Sheet Delegate
    func actionSheet(_ popup: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        switch popup.tag {
        case 1:
            switch buttonIndex {
            case 0:
                takePhoto()
                print("Select From Camera")
            case 1:
                selectPhoto()
                print("Select From Photos")
            default:
                break
            }
        default:
            break
        }
    }
    
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func selectPhoto() {        
        let imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.maximumNumberOfSelection = 3
        imagePickerController.showsNumberOfSelectedAssets = true
        
        present(imagePickerController, animated: true)
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController?, didFinishPickingAssets assets: [Any]?) {
        print("Selected assets:")
        if let anAssets = assets {
            print("\(anAssets)")
        }
        if let anAssets = assets {
            sendImageArr = anAssets
        }
        labelAttachmentFile.text = String(format: "%lu attachment", UInt(sendImageArr.count))
        labelAttachmentFile.isHidden = false
        buttonInputSend.isHidden = false
        
        dismiss(animated: true)
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController?) {
        print("Canceled.")
        
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        sendImageArr = [chosenImage as Any]
        labelAttachmentFile.isHidden = false
        labelAttachmentFile.text = String(format: "%lu attachment", UInt(sendImageArr.count))
        
        buttonInputSend.isHidden = false
        // self.imageView.image = chosenImage;
        
        picker.dismiss(animated: true)
    }
    
    // MARK: - User actions (menu)
    @objc func actionMenuCopy(_ sender: Any?) {
        let indexPath: IndexPath? = RCMenuItem.indexPath((sender as! UIMenuController))
        let rcmessage: RCMessage? = self.rcmessage(indexPath)
        UIPasteboard.general.string = rcmessage?.text
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rcmessages.count
    }
    
    override func actionTapBubble(_ indexPath: IndexPath?) {
        let rcmessage = rcmessages[indexPath!.section] as! RCMessage
        guard rcmessage.file != nil else {return}
        if !(rcmessage.file!.type == "image") {
            let url = URL(string: rcmessage.file!.content )
            
            if #available(iOS 10.0, *) {
                if UIApplication.shared.responds(to: #selector(UIApplication.open(_:options:completionHandler:))) {
                    if let anUrl = url {
                        UIApplication.shared.open(anUrl, options: [:], completionHandler: nil)
                    }
                } else {
                    // Fallback on earlier versions
                    if let anUrl = url {
                        UIApplication.shared.openURL(anUrl)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            let session = URLSession.shared
            if let url = URL(string: rcmessage.file!.content) {
                (session.dataTask(with: url, completionHandler: { data, response, error in
                    if error == nil {
                        DispatchQueue.main.async(execute: {
                            self.imageVC = UDImageView(nibName: "UDImageView", bundle: nil)
                            self.addChildViewController(self.imageVC)
                            self.view.addSubview(self.imageVC.view)
                            self.imageVC.view.frame = CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                            rcmessage.picture_image = UIImage(data: data!)
                            self.imageVC.viewimage.image = rcmessage.picture_image
                            self.imageVC.delegate = self
                        })
                    }
                })).resume()
            }
        }
        
    }
    
}

extension Date {
    var isToday: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        let date1 = dateFormatter.string(from: self)
        let date2 = dateFormatter.string(from: Date())
        if date1 == date2 {
            return true
        } else {
            return false
        }
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        return dateFormatter.string(from: self)
    }
    
    var timeAndDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        return dateFormatter.string(from: self)
    }
}

extension DialogflowView: UDImageViewDelegate {
    func close() {
        imageVC.view.removeFromSuperview()
    }
    
}
