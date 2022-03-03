//
//  NotesController.swift
//  FSNotes
//
//  Created by HariPanicker on 25/02/22.
//

import UIKit
import FirebaseAuth
class NotesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var notesTable: UITableView!

    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTable.delegate = self
        notesTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseDataManager.shared.fetch(completion: { [weak self] data in
            DispatchQueue.main.async {
                self?.notes = data
                self?.notesTable.reloadData()
            }
        })
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            CoredataManager.shared.deleteUser()
        } catch {
            fatalError("Signout failed")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func newNote(_ sender: Any) {
        moveToNotes(selectedNote: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell") as? NotesCell else {
            return UITableViewCell()
        }
        cell.loadWith(note: notes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToNotes(selectedNote: notes[indexPath.row])
    }
    
    func moveToNotes(selectedNote: Note?) {
        guard let notesController =  self.storyboard?.instantiateViewController(identifier: "EditorController") as? EditorController else {
            return
        }
        notesController.note = selectedNote
        self.navigationController?.pushViewController(notesController, animated: true)
    }
}
