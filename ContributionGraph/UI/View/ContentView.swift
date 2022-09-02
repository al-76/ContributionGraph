//
//  ContentView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 20.06.2022.
//

import Factory
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UIContainer.contributionViewModel()
    @State private var selectedDay = 0
    @State private var addContribution = false

    var body: some View {
        VStack(alignment: .trailing) {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading... Loa...")

            case .failure(let error):
                Label {
                    Text("Error: \(error.localizedDescription)")
                } icon: {
                    Image(systemName: "xmark.app")
                            .foregroundColor(Color.red)
                }

            case .success(let data):
                Label {
                    Text("Contributions: \(data.totalContributionCount())")
                        .font(.headline)
                } icon: {
                    Image(systemName: "flame")
                        .foregroundColor(Color.red)
                }
                .padding()

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

                Menu {
                    Button("15 weeks") { viewModel.set(settings: data.set(weekCount: 15)) }
                    Button("25 weeks") { viewModel.set(settings: data.set(weekCount: 25)) }
                    Button("50 weeks") { viewModel.set(settings: data.set(weekCount: 50)) }
                    Button("All weeks (\(data.totalWeekCount()))") {
                        viewModel.set(settings: data.set(weekCount: data.totalWeekCount()))
                    }
                } label: {
                    Label("Weeks count: \(data.weekCount())", systemImage: "slider.horizontal.3")
                }.padding(.trailing)

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
                        ForEach(data.notes()) {
                            Text("\($0.changed.format())\n")
                                .font(.caption) +
                            Text($0.note)
                        }.onDelete { _ in }
                    }
                    .toolbar {
                        Button {
                            addContribution = true
                        } label: { Image(systemName: "plus") }

                        EditButton()
                    }
                    .sheet(isPresented: $addContribution) {
                        AddEditContributionView(day: selectedDay, isPresented: $addContribution)
                    }
                    .onChange(of: addContribution) { value in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
            .previewInterfaceOrientation(.portrait)
    }
}
