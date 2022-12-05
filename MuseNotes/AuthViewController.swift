//
//  AuthViewController.swift
//  MuseNotes
//
//  Created by Leyla Tuon on 11/14/22.
//  Spotify API Authentification done using following tutorials:
//  Tutorial 1: https://www.youtube.com/watch?v=MfhwNT5uT2s&list=PL5PR3UyfTWve9ZC7Yws0x6EGjBO2FGr0o&index=7
//  Tutorial 2: https://www.youtube.com/watch?v=rKDD9R7VED0&list=PL5PR3UyfTWve9ZC7Yws0x6EGjBO2FGr0o&index=7
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        // initialize webkit config
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero
                                , configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange code for access token
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value
        else {
            return
        }
        webView.isHidden = true
        print ("code: \(code)")
        
        AuthManager.shared.exchangeCodeForToken(code: code) { success in
            
        }
            //            DispatchQueue.main.async {
            //                self?.navigationController?.popToRootViewController(animated: true)
            //                self?.completionHandler?(success)
            //            }
        self.performSegue(withIdentifier: "loggedin", sender: self)

    }
}
