//
//  SettingsViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 12/12/22.
//

import UIKit
class SettingsViewController: UIViewController {
    @IBOutlet weak var darkModeSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let check = UserDefaults.standard.bool(
            forKey: "DarkMode")
        if check == true {
            darkModeSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func darkMode(_ sender: Any) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let appDelegate = windowScene?.windows.first
        if darkModeSwitch.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
        } else {
            appDelegate?.overrideUserInterfaceStyle = .light
        }
        UserDefaults.standard.set(
            darkModeSwitch.isOn,
            forKey: "DarkMode")
    }
}
