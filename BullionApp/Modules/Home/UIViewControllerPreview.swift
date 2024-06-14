//
//  UIViewControllerPreview.swift
//  BullionApp
//
//  Created by Naela Fauzul Muna on 14/06/24.
//

import SwiftUI
import UIKit

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // leave this empty
    }
}

