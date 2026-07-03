//
//  ContentView.swift
//  ToDoList_SwiftUI_Firebase
//
//  Created by 권태우 on 6/30/26.
//

import SwiftUI
// Swift UI 는 View model 를 구현해서 사용. View에 로직이 없고 상태를 통해서 UI 만 그리도록 수정
// Viewmodel은 Observable 를 채택해서 구현
struct ContentView: View {
    // Firestore에서 불러온 할 일 목록
    @State private var tasks: [TaskItem] = []
    
    // 추가 시트 표시 여부
    @State private var isShowingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List(tasks) { task in
                NavigationLink {
                    TaskDetailView(task: task) {
                        await loadTasks()   // 수정/삭제 후 목록 새로고침
                    }
                } label: {
                    Text(task.title)
                }
            }
            .navigationTitle("할 일")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddTodoView { newTitle in
                    Task {
                        await addTask(title: newTitle)   // Firestore에 저장
                        await loadTasks()                // 저장 후 목록 새로고침
                    }
                }
            }
            // 화면이 나타날 때 Firestore에서 목록을 한 번 불러옵니다.
            .task {
                await loadTasks()
            }
        }
    }
    
    /// Firestore에서 할 일 목록을 불러와 화면에 반영
    private func loadTasks() async {
        tasks = await getTasks()
    }
}
