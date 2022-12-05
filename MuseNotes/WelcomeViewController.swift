//
//  ViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 11/14/22.
//  Spotify API Authentification done using following tutorials:
//  Tutorial 1: https://www.youtube.com/watch?v=MfhwNT5uT2s&list=PL5PR3UyfTWve9ZC7Yws0x6EGjBO2FGr0o&index=7
//  Tutorial 2: https://www.youtube.com/watch?v=rKDD9R7VED0&list=PL5PR3UyfTWve9ZC7Yws0x6EGjBO2FGr0o&index=7
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var LogInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func didTapLogIn(_ sender: UIButton) {
        let vc = AuthViewController()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AuthView") as? AuthViewController
//        vc.completionHandler { [weak self] success in
//            DispatchQueue.main.async {
//                self?.handleSignIn(success: success)
//            }
//        }
        // get reference to AuthViewController, check completionHandler
        print("tapped login")
    }
    func handleSignIn(success: Bool){
        guard success else {
            let alert = UIAlertController(title: "Error", message: "could not sign in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        self.performSegue(withIdentifier: "loggedin", sender: self)
    }
}

