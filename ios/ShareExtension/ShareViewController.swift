//
//  ShareViewController.swift
//  Share Extension
//
//  Created by Macbook on 22/06/2024.
//

import UIKit
import Social
import receive_sharing_intent // Import the module

class ShareViewController: RSIShareViewController { // Inherit from RSIShareViewController

    // Override the method to control auto-redirect behavior
    override func shouldAutoRedirect() -> Bool {
        return false
    }

    // This method can be used to validate the content if needed
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    // This method is called after the user selects Post
    override func didSelectPost() {
        // Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    // This method can be used to add configuration options via table cells at the bottom of the sheet
    override func configurationItems() -> [Any]! {
        // Return an array of SLComposeSheetConfigurationItem here.
        return []
    }
}
