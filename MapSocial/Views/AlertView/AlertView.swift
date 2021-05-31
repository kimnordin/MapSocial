//
//  AlertView.swift
//  MapSocial
//
//  Created by Kim Nordin on 2021-05-30.
//

import UIKit

class AlertView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private let viewSelfId = "AlertView"
    private var contentView: UIView?
    private var emojiId = "EmojiCell"
    var selectedEmoji = ""
    
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

    func commonInit() {
        contentView = loadViewFromNib(id: viewSelfId)
        addSubview(contentView!)
        
        emojiCollection.dataSource = self
        emojiCollection.delegate = self
        descriptionField.delegate = self
        
        let nib = UINib(nibName: emojiId, bundle: nil)
        emojiCollection.register(nib, forCellWithReuseIdentifier: emojiId)

        emojiCollection.reloadData()
    }
}

extension AlertView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: ", emojis.count)
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        statusLabel.text = emojis[indexPath.row]
        selectedEmoji = emojis[indexPath.row]

        print(selectedEmoji)
//        selectColor = coloRay[indexPath.row]
//        updateSliders(color: selectColor)
//        colorPreview.backgroundColor = selectColor
//        updateSenderColor()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiId, for: indexPath) as! EmojiCell
        let emoji = emojis[indexPath.row]
        cell.label.text = emoji
        return cell
    }
}
