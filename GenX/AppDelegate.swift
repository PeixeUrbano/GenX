//
//  AppDelegate.swift
//  GenX
//
//  Created by Guilherme Rambo on 15/05/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import Cocoa
import GeneratorCore

enum UIError: Error {
    case invalidDocumentType

    var localizedDescription: String {
        switch self {
        case .invalidDocumentType:
            return "This document type is invalid"
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var menu: NSMenu = {
        let m = NSMenu(title: "GenX")

        DocumentType.all.enumerated().forEach { index, docType in
            let item = NSMenuItem(title: docType.title, action: #selector(generate), keyEquivalent: "")
            item.tag = index
            item.target = self
            m.addItem(item)
        }

        return m
    }()

    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: 18)
        statusItem.title = "G"
        statusItem.menu = menu
    }

    @objc private func generate(_ sender: NSMenuItem) {
        let type = DocumentType.all[sender.tag]

        do {
            let result = try Generator().generate(type: type)

            print("Generated \(type.title): " + result)

            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(result, forType: .string)
        } catch {
            NSApp.presentError(error)
        }
    }

}

