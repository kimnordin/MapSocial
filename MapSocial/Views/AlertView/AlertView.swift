//
//  AlertView.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-30.
//

import UIKit
import Smile

class AlertView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var statusField: EmojiField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private let viewSelfId = "AlertView"
    private var contentView: UIView?
    private let allEmojis = Smile.list()
    
    var validInput: Bool = false {
        didSet {
            errorField.isHidden = validInput
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (string.containsValidCharacter)
    }
    
    override var textInputContextIdentifier: String? {  
        return "emoji"
    }

    
    func commonInit() {
        contentView = loadViewFromNib(id: viewSelfId)
        addSubview(contentView!)
        
        statusField.delegate = self
        descriptionField.delegate = self
    }
}
