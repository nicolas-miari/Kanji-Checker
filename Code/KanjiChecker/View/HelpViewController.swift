//
//  HelpViewController.swift
//  KanjiChecker
//
//  Created by Nicolás Miari on 2020/04/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Cocoa

class HelpViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        if let window = self.view.window {
            window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
        }
    }

    @IBAction func ok(_ sender: Any) {
        presentingViewController?.dismiss(self)
    }
}
