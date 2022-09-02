//
//  ContributionView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 02.09.2022.
//

import SwiftUI

struct ContributionView: View {
    @StateObject private var viewModel = UIContainer.contributionViewModel()
    @State private var selectedDay = 0
    @State private var addEditContribution = false
    @State private var editingNote: ContributionNote?

    var body: some View {
        VStack(alignment: .trailing) {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading... Loa...")

            case .failure(let error):
                ErrorView(error: error)

            case .success(let data):
                contributionsCountLabel(data.totalContributionCount())

                ContributionGraphView(weeksCount: data.weekCount(),
                                      cellSize: 40.0,
                                      dayToday: Date.neutral.weekday())
                .onDataCell {
                    data.notesCount(at: $0)
                }
                .onTapCell { day in
                    selectedDay = day
                }
                .onChange(of: selectedDay) { newDay in
                    viewModel.fetchContribtuionDetails(at: newDay)
                }

                settingsView(data)

                Label {
                    Text(data.date(at: selectedDay))
                        .font(.headline)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(Color.blue)
                }
                .padding()

                NavigationView {
                    List {
                        ForEach(data.notes()) { note in
                            notesRow(note)
                            .onTapGesture {
                                editingNote = note
                                addEditContribution = true
                            }
                        }
                        .onDelete { _ in }
                        .onTapGesture { addEditContribution = true }
                    }
                    .toolbar {
                        Button {
                            editingNote = nil
                            addEditContribution = true
                        } label: { Image(systemName: "plus") }

                        EditButton()
                    }
                    .sheet(isPresented: $addEditContribution) {
                        AddEditContributionView(day: selectedDay,
                                                contributionNote: editingNote,
                                                isPresented: $addEditContribution)
                    }
                    .onChange(of: addEditContribution) { value in
                        guard !value else { return }
                        withAnimation(.spring()) {
                            viewModel.fetchContributionData(at: selectedDay)
                        }
                    }
                    .navigationTitle("Items")
                    .navigationBarTitleDisplayMode(.inline)
                }

                Spacer()
            }
        }.onAppear {
            viewModel.fetchContributionData()
        }
    }
}

// MARK: - Components
extension ContributionView {
    private func contributionsCountLabel(_ count: Int) -> some View {
        Label {
            Text("Contributions: \(count)")
                .font(.headline)
        } icon: {
            Image(systemName: "flame")
                .foregroundColor(Color.red)
        }
        .padding()
    }

    private func settingsView(_ data: ContributionViewModel.Data) -> some View {
        Menu {
            Button("15 weeks") { viewModel.set(settings: data.set(weekCount: 15))
            }
            Button("25 weeks") { viewModel.set(settings: data.set(weekCount: 25)) }
            Button("50 weeks") { viewModel.set(settings: data.set(weekCount: 50)) }
            Button("All weeks (\(data.totalWeekCount()))") {
                viewModel.set(settings: data.set(weekCount: data.totalWeekCount()))
            }
        } label: {
            Label("Weeks count: \(data.weekCount())", systemImage: "slider.horizontal.3")
        }.padding(.trailing)
    }

    private func notesRow(_ note: ContributionNote) -> some View {
        HStack {
            Text("\(note.changed.format())\n")
                .font(.caption) +
            Text(note.title)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct ContributionView_Previews: PreviewProvider {
    static var previews: some View {
        ContributionView()
    }
}
