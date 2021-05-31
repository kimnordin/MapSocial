//
//  AlertController.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-30.
//

import UIKit

protocol AlertDelegate: class {
    func addAnnotation(status: String, description: String) // add any necessary parameters
}

class AlertController: UIViewController {
    
    weak var delegate: AlertDelegate?

    @IBOutlet weak var alertView: AlertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        view.tapOutsideKeyboardDismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alertView.doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        alertView.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    func isValid() -> Bool {
        var valid = false
        if alertView.statusField.text != "" && alertView.descriptionField.text != "" {
            valid = true
        }
        alertView.validInput = valid
        return valid
    }
    
    @objc func doneAction(_ sender: UIButton) {
        let inputValid = isValid()
        
        if inputValid {
            if let status = alertView.statusField.text,
               let description = alertView.descriptionField.text {
                delegate?.addAnnotation(status: status, description: description)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        print("cancel action")
        if let presenter = presentingViewController as? MapController {
            print("present")
            if let status = alertView.statusField.text,
               let description = alertView.descriptionField.text {
                print("add annotation")
                presenter.addAnnotation(status: status, description: description)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
