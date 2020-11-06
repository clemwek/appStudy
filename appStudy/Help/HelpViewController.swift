//
//  HelpViewController.swift
//  appStudy
//
//  Created by Clement  Wekesa on 06/11/2020.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://www.apple.com/")!))
    }
}
