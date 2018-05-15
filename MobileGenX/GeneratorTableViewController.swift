//
//  GeneratorTableViewController.swift
//  MobileGenX
//
//  Created by Guilherme Rambo on 15/05/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

import UIKit
import GeneratorCore

class GeneratorTableViewController: UITableViewController {

    var options: [DocumentType] = DocumentType.all

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = options[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
