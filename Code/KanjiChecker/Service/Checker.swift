//
//  Checker.swift
//  KanjiChecker
//
//  Created by Nicolás Miari on 2020/04/08.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation
import Cocoa

class Checker {

    enum SchoolGrade {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
    }

    var workItem: DispatchWorkItem?

    let firstCharacter: Character
    let lastCharacter: Character

    let grades: [[String]]

    init() {
        guard let minScalar = Unicode.Scalar(UInt32(0x4e00)) else {
            fatalError("!!!")
        }
        guard let maxScalar = Unicode.Scalar(UInt32(0x9fff)) else {
            fatalError("!!!")
        }
        self.firstCharacter = Character(minScalar)
        self.lastCharacter = Character(maxScalar)

        guard let tableURL = Bundle.main.url(forResource: "Table", withExtension: "json") else {
            fatalError("!!!")
        }
        guard let data = try? Data(contentsOf: tableURL) else {
            fatalError("!!!")
        }
        guard let table = try? JSONDecoder().decode(Table.self, from: data) else {
            fatalError("!!!")
        }

        let splitGrades = table.grades.map { (line) -> [String] in
            return line.components(separatedBy: ",")
        }

        var cummulativeGrades = [[String]]()

        for index in 0 ..< splitGrades.count {
            if index == 0 {
                // First
                cummulativeGrades.append(splitGrades[0])
            } else {

                let cummulative = splitGrades[index] + cummulativeGrades[index - 1]
                cummulativeGrades.append(cummulative)
            }
        }

        self.grades = cummulativeGrades
    }

    func highlightInput(_ attributed: NSAttributedString, grade: Int, progress: @escaping ((Double) -> Void), completion: @escaping((NSAttributedString) -> Void) ) {

        let min = self.firstCharacter
        let max = self.lastCharacter

        let rawText = attributed.string
        let output = NSMutableAttributedString(attributedString: attributed)

        let outColor = NSColor.red
        let inColor = NSColor(calibratedRed: 0.1, green: 0.66, blue: 0.15, alpha: 1)

        let gradeList = grades[grade]

        let workItem = DispatchWorkItem(block: {

            let total = rawText.count
            let step = 10
            var index = 0

            rawText.forEach { (character) in
                defer {
                    index += 1
                }

                if (index % step) == 0 {
                    // Update progress bar UI every <step> characters
                    DispatchQueue.main.async {
                        let value = Double(index)/Double(total)
                        progress(value)
                    }
                }

                guard character >= min && character <= max else {
                    // (Not a Kanji)
                    return
                }

                let range = NSRange(location: index, length: 1)
                if gradeList.contains("\(character)") {
                    output.addAttributes([.foregroundColor: inColor], range: range)
                } else {
                    output.addAttributes([.foregroundColor: outColor], range: range)
                }
            }

            DispatchQueue.main.async { [weak self] in
                completion(output)
                self?.workItem = nil
            }
        })
        DispatchQueue.global().async(execute: workItem)
        self.workItem = workItem
    }

    func abort() {
        DispatchQueue.main.async { [weak self] in
            self?.workItem?.cancel()
            self?.workItem = nil
        }
    }
}

// MARK: - Supporting Types

struct Table: Decodable {
    let grades: [String]
}
