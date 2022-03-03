//
//  EditorController.swift
//  FSNotes
//
//  Created by HariPanicker on 26/02/22.
//

import UIKit

class EditorController: UIViewController {

    @IBOutlet private weak var titleText: UITextField!
    @IBOutlet private weak var contentText: UITextView!

    var index: Int?
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let noteData = note {
            self.titleText.text = noteData.title
            self.contentText.text = noteData.content
            self.index = noteData.index
        }
        contentText.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        contentText.layer.cornerRadius = 10
        contentText.layer.borderWidth = 1
    }
    
    @IBAction func saveNote(_ sender: Any) {
        guard let title = titleText.text, let content = contentText.text else {
            return
        }
        if let currentIndex = index {
            FirebaseDataManager.shared.updateMessage(index: currentIndex, title: title, content: content)
        } else {
            FirebaseDataManager.shared.saveMessage(title: title, content: content)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
