//
//  SecondViewController.swift
//  lioniq-demo
//
//  Created by JERRY LIU on 21/8/2016.
//  Copyright © 2016 ONTHETALL. All rights reserved.
//

import UIKit
import Lioniq

class ShoppingCartViewController: UIViewController {
    var liqview: LIQView?
    @IBOutlet weak var webviewPlaceholder: UIView!
    
    let key = "15ef0668e2f7d3234c1706997156c8a2"
    let secret = "2ab6633650437c8bb29ee5bcdf072034"
    let userId = "xyz123123"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadWebview()
    }
    private func loadWebview() {
        self.liqview = LIQView(frame: webviewPlaceholder.frame)
        self.liqview?.reloadCart(key, secret: secret, userId: userId)
        self.liqview?.delegate = self
        self.view.addSubview(liqview!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment" {
            let paymentVC = segue.destination as! PaymentViewController
            paymentVC.orderData = sender as! Dictionary<String, AnyObject>?
        }
    }
}

extension ShoppingCartViewController: LIQViewDelegate {
    func webviewDidMain() {
        print("[CartViewController webviewDidRouteToMain]")
        self.tabBarController?.tabBar.isHidden = false
    }
    func webviewDidCheckout() {
        print("[CartViewController didCheckout]")
        self.tabBarController?.tabBar.isHidden = true
    }

    func webviewDidOrder(_ orderData: Dictionary<String, AnyObject>) {
        print("[CartViewController didOrder]:\(orderData)")
        self.tabBarController?.tabBar.isHidden = true
        
        // 跳转至支付
        self.performSegue(withIdentifier: "payment", sender: orderData)
    }
    
    func webviewDidItemDetail() {
        print("[CartViewController webviewDidRouteToItemDetail")
        self.tabBarController?.tabBar.isHidden = true
    }
}

