//
//  ContentView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 20.06.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContributionViewModel(getItemsUseCase: AnyUseCase(wrapped: GetContributionUseCase(repository: DefaultContributionRepository())),
                                                       getSettingsUseCase: AnyUseCase(wrapped: GetContributionSettingsUseCase()),
                                                       setSettingsUseCase: AnyUseCase(wrapped: SetContributionSettingsUseCase()),
                                                       getMetricsUseCase: AnyUseCase(wrapped: GetContributionMetricsUseCase()))
    @State var selectedDay = 0
    
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
                                      dayToday: Date.now.weekday())
                .onDataCell {
                    data.notesCount(at: $0)
                }
                .onTapCell { day in
                    selectedDay = day
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
                        ForEach(data.notes(at: selectedDay), id: \.self) {
                            Text($0)
                        }.onDelete { _ in }
                    }
                    .toolbar {
                        NavigationLink {
                            AddContributionView()
                        } label: { Image(systemName: "plus") }
                        EditButton()
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
