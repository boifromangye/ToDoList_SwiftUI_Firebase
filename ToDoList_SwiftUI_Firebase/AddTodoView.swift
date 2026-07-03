//
//  AddTodoView.swift
//  ToDoList_SwiftUI_Firebase
//
//  Created by 권태우 on 6/30/26.
//

import SwiftUI

/// 새 할 일을 입력받는 화면 (시트로 표시됩니다)
struct AddTodoView: View {
    // 입력한 제목을 임시로 담아두는 상태
    @State private var title: String = ""

    // 시트를 닫기 위해 사용하는 환경 값
    @Environment(\.dismiss) private var dismiss

    // "추가" 버튼을 눌렀을 때 부모 뷰로 제목을 전달하는 클로저
    let onAdd: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("할 일을 입력하세요", text: $title)
            }
            .navigationTitle("새 할 일")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 왼쪽: 취소
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                // 오른쪽: 추가
                ToolbarItem(placement: .confirmationAction) {
                    Button("추가") {
                        onAdd(title)
                        dismiss()
                    }
                    // 공백만 입력했거나 비어 있으면 추가 비활성화
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddTodoView { newTitle in
        print("추가됨: \(newTitle)")
    }
}
