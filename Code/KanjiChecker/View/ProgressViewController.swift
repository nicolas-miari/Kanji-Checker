//
//  ProgressViewController.swift
//  KanjiChecker
//
//  Created by Nicolás Miari on 2020/04/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Cocoa

class ProgressViewController: NSViewController {

    // MARK: - GUI

    @IBOutlet private weak var progressIndicator: NSProgressIndicator!

    // MARK: -

    var cancelHandler: (() -> Void)?
    var appearHandler: (() -> Void)?

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        appearHandler?()
    }

    // MARK: - Operation

    func setProgress(_ value: Double) {
        progressIndicator.doubleValue = value
    }

    // MARK: - Control Actions

    @IBAction func cancel(_ sender: Any) {
        cancelHandler?()
    }
}
