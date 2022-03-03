//
//  FirebaseDataManager.swift
//  FSNotes
//
//  Created by HariPanicker on 26/02/22.
//

import Foundation
import FirebaseDatabase

class FirebaseDataManager {
    static let shared = FirebaseDataManager()
    private let databaseReference = Database.database().reference()
    private init() {
    }
    
    func saveMessage(title: String, content: String) {
        fetchLastId { [weak self] index in
            self?.updateMessage(index: index + 1, title: title, content: content)
        }
    }
    
    func updateMessage(index: Int, title: String, content: String) {
        let timestamp = timeNow()
        databaseReference.child("Notes/\(index)").setValue(["title": title,"content": content, "timestamp":timestamp])
        saveMessageIndex(index: index)
    }
    
    func saveMessageIndex(index: Int) {
        databaseReference.child("Notes/LastMessageIndex").setValue(["index": index])
    }
    
    func fetchLastId(completion: @escaping (Int) -> Void) {
        databaseReference.child("Notes/LastMessageIndex").observeSingleEvent(of: .value) { snapshot in
            guard let resources = snapshot.value as? [String : AnyObject], let index = resources["index"] as? Int else {
                completion(-1)
                return
            }
            completion(index)
        }
    }
    
    func fetch(completion: @escaping ([Note]) -> Void) {
        databaseReference.queryOrderedByKey()
        databaseReference.child("Notes").observeSingleEvent(of: .value) { snapshot in
            guard let resources = snapshot.value as? [String : AnyObject] else {
                return
            }
            var parsedData = [Note]()
            for (key, noteData) in resources {
                if let dict = noteData as? [String: AnyObject], let index = Int(key) {
                    parsedData.append(Note(data: dict, index: index))
                }
            }
            completion(parsedData)
        }
    }
    
    func timeNow() -> String {
        let timestamp = NSDate().timeIntervalSince1970
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(timestamp)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM EEEE hh:mm:ss"
        return dateFormatter.string(from: dateVar)
    }
}

struct Note {
    var index: Int
    var title: String
    var content: String
    var time: String
    
    init(data: [String: Any], index: Int) {
        self.index = index
        self.title = data["title"]  as? String ?? ""
        self.content = data["content"]  as? String ?? ""
        self.time = data["timestamp"]  as? String ?? ""
    }
}
