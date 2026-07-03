//
//  Firebase.swift
//  ToDoList_UIKit_Firebase
//
//  Created by 권태우 on 6/21/26.
//

import FirebaseFirestore

struct TaskItem: Identifiable {
    let id: String
    let title: String
    let check: Bool
}

let db = Firestore.firestore()

func addTask(title: String) async {
    // Add a second document with a generated ID.
    do {
      _ = try await db.collection("tasks").addDocument(data: [
        "check": false,
        "title": title
      ])
    } catch {
    }
}

func getTasks() async -> [TaskItem] {
    do {
        let snapshot = try await db.collection("tasks").getDocuments()
        return snapshot.documents.map { document in
            let data = document.data()
            return TaskItem(
                id: document.documentID,
                title: data["title"] as? String ?? "",
                check: data["check"] as? Bool ?? false
            )
        }
    } catch {
        return []
    }
}

func editTask(id: String, title: String) async {
    try? await db.collection("tasks").document(id).updateData(["title": title])
}

func deleteTask(id: String) async {
    try? await db.collection("tasks").document(id).delete()
}
