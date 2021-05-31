//
//  EmojiField.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-31.
//

import UIKit

class EmojiField: UITextField {

   // required for iOS 13
   override var textInputContextIdentifier: String? { "" }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
