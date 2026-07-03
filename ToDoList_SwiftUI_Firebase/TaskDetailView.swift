//
//  TaskDetailView.swift
//  ToDoList_SwiftUI_Firebase
//
//  Created by 권태우 on 7/3/26.
//

import SwiftUI

/// 할 일 상세 화면 — 제목을 수정하거나 삭제할 수 있습니다.
struct TaskDetailView: View {

    let task: TaskItem
    @State private var title: String
    @State private var isWorking = false

    @Environment(\.dismiss) private var dismiss

    let onChange: () async -> Void

    init(task: TaskItem, onChange: @escaping () async -> Void) {
        self.task = task
        self.onChange = onChange
        _title = State(initialValue: task.title)
    }

    var body: some View {
        Form {
            Section("제목") {
                TextField("할 일을 입력하세요", text: $title)
            }

            Section {
                Button(role: .destructive) {
                    deleteAndDismiss()
                } label: {
                    Text("삭제")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    saveAndDismiss()
                }
            }
        }
        .disabled(isWorking)
    }

    /// 제목을 저장한 뒤 목록을 새로고침하고 화면을 닫습니다.
    private func saveAndDismiss() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        Task {
            isWorking = true
            await editTask(id: task.id, title: trimmed)
            await onChange()
            dismiss()
        }
    }

    /// 할 일을 삭제한 뒤 목록을 새로고침하고 화면을 닫습니다.
    private func deleteAndDismiss() {
        Task {
            isWorking = true
            await deleteTask(id: task.id)
            await onChange()
            dismiss()
        }
    }
}
