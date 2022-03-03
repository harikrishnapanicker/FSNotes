//
//  NotesCell.swift
//  FSNotes
//
//  Created by HariPanicker on 26/02/22.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadWith(note: Note) {
        indexLabel.text = "\(note.index)"
        contentLabel.text = note.title
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
