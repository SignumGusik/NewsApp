//
//  VKShareService.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

final class VKShareService {
    static let shared = VKShareService()

    private init() {}

    func share(url: URL, from viewController: UIViewController, sourceView: UIView?, sourceRect: CGRect?) {
        guard let vkURL = makeVKShareURL(for: url) else {
            presentSystemShare(url: url, from: viewController, sourceView: sourceView, sourceRect: sourceRect)
            return
        }

        UIApplication.shared.open(vkURL, options: [:]) { success in
            if success == false {
                self.presentSystemShare(
                    url: url,
                    from: viewController,
                    sourceView: sourceView,
                    sourceRect: sourceRect
                )
            }
        }
    }

    private func makeVKShareURL(for articleURL: URL) -> URL? {
        var components = URLComponents(string: VKShareConstants.shareBaseURL)
        components?.queryItems = [
            URLQueryItem(name: VKShareConstants.QueryItems.url, value: articleURL.absoluteString)
        ]
        return components?.url
    }

    private func presentSystemShare(
        url: URL,
        from viewController: UIViewController,
        sourceView: UIView?,
        sourceRect: CGRect?
    ) {
        let controller = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let popover = controller.popoverPresentationController,
           let sourceView,
           let sourceRect {
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
        }

        viewController.present(controller, animated: true)
    }
}
