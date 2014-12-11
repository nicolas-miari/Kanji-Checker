//
//  InputTextView.swift
//  KanjiChecker
//
//  Created by Nicolás Miari on 2020/04/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Cocoa

class InputTextView: NSTextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textContainerInset = CGSize(width: 5, height: 5)
    }

    override func paste(_ sender: Any?) {
        super.pasteAsPlainText(sender)
    }

    override var textContainerOrigin: NSPoint {
        let origin = super.textContainerOrigin
        return CGPoint(x: origin.x + 5, y: origin.y + 5)
    }
}
