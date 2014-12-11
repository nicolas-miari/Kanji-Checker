//
//  MainViewController.swift
//  KanjiChecker
//
//  Created by Nicolás Miari on 2020/04/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Cocoa

class CheckerViewController: NSViewController {

    // MARK: - GUI

    @IBOutlet private weak var textView: NSTextView!
    @IBOutlet private weak var audiencePopupButton: NSPopUpButton!
    @IBOutlet private weak var checkButton: NSButton!

    var progressViewController: ProgressViewController?
    let checker = Checker()

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Control Actions

    @IBAction func check(_ sender: Any) {

        guard let storyboard = self.storyboard else {
            fatalError("FUCK YOU")
        }
        guard let progress = storyboard.instantiateController(withIdentifier: "Progress") as? ProgressViewController else {
            fatalError("Fuck You")
        }

        let text = textView.attributedString()
        let grade = audiencePopupButton.indexOfSelectedItem
        progress.appearHandler = { [unowned self] in
            // Begin task...
            self.checker.highlightInput(text, grade: grade, progress: { (value) in
                progress.setProgress(value)

            }, completion: {[unowned self](result) in
                self.textView.textStorage?.setAttributedString(result)
                self.dismiss(progress)
            })
        }

        progress.cancelHandler = { [unowned self] in
            self.dismiss(progress)
        }
        presentAsSheet(progress)
    }

    @IBAction func audienceChanged(_ sender: Any) {
        textView.string = textView.attributedString().string
    }
}
