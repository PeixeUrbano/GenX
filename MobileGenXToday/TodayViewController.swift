//
//  TodayViewController.swift
//  MobileGenXToday
//
//  Created by Guilherme Rambo on 15/05/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import NotificationCenter
import GeneratorCore
import os.log

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var tableView: UITableView!
    private let log = OSLog(subsystem: "MobileGenXToday", category: "TodayViewController")

    override func viewDidLoad() {
        super.viewDidLoad()

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        update()
        completionHandler(.newData)
    }

    var options = DocumentType.all

    private func update() {
        tableView.reloadData()
        updatePreferredContentSize()
    }

    @objc private func generate(_ sender: UIButton) {
        let type = DocumentType.all[sender.tag]

        do {
            let result = try Generator().generate(type: type)

            os_log("Generated %{public}@: %{public}@", type.title, result)

            UIPasteboard.general.string = result
        } catch {
            os_log(
                "Failed to generate document %{public}@: %{public}@",
                log: self.log,
                type: .error,
                type.title,
                String(describing: error)
            )
        }
    }

    private func updatePreferredContentSize() {
        guard let mode = extensionContext?.widgetActiveDisplayMode else { return }

        switch mode {
        case .compact:
            preferredContentSize = CGSize(width: 0, height: 110)
        case .expanded:
            preferredContentSize = CGSize(width: 0, height: tableView.contentSize.height)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }, completion: nil)
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        updatePreferredContentSize()
    }
    
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = options[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = options[indexPath.row]

        do {
            let result = try Generator().generate(type: type)
            print("Generated \(type.title): \(result)")
            UIPasteboard.general.string = result
        } catch {
            let alert = UIAlertController(title: "Generation failed", message: "Error: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

}
