//
//  ContributionGraphView.swift
//  ContributionGraph
//
//  Created by Vyacheslav Konopkin on 27.06.2022.
//

import SwiftUI

struct ContributionGraphView: View {
    private let weeksCount: Int
    private let cellSize: CGFloat
    private let dayToday: Int

    private let cellSpacing: CGFloat = 3.0
    private let cellCornerRadius: CGFloat = 4.0
    private let cellBorderWidth: CGFloat = 2.0
    private let cellSelectedBorderWidth: CGFloat = 4.0
    
    private var onDataCellAction: ((Int) -> Int)? = nil
    private var onTapCellAction: ((Int) -> Void)? = nil
    @State private var selectedCell: Int = 0
        
    init(weeksCount: Int,
         cellSize: CGFloat,
         dayToday: Int) {
        self.weeksCount = weeksCount
        self.cellSize = cellSize
        self.dayToday = dayToday
    }
    
    var body: some View {
        HStack {
            dayHeaders()
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal) {
                    grid(cellCount: weeksCount * 7)
                        .onAppear {
                            scroll(scrollProxy)
                        }
                        .onChange(of: weeksCount) { _ in
                            scroll(scrollProxy)
                        }
                }.fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing)
            }
        }
    }
    
    func onDataCell(perform action: @escaping (Int) -> Int) -> ContributionGraphView {
        var view = self
        view.onDataCellAction = action
        return view
    }
    
    func onTapCell(perform action: @escaping (Int) -> Void) -> ContributionGraphView {
        var view = self
        view.onTapCellAction = action
        return view
    }
    
    private func scroll(_ proxy: ScrollViewProxy) {
        proxy.scrollTo(0, anchor: .bottomTrailing)
    }
    
    private func dayHeaders() -> some View {
        VStack(spacing: cellSpacing) {
            Text("").frame(height: cellSize * 2)
            Group {
                Text(dayName(from: 2))
                Text("")
                Text(dayName(from: 4))
                Text("")
                Text(dayName(from: 6))
                Text("")
            }.frame(height: cellSize)
        }.padding([.leading])
    }
    
    private func rows() -> [GridItem] {
        [GridItem(.fixed(2 * cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing),
         GridItem(.fixed(cellSize), spacing: cellSpacing)]
    }
    
    private func grid(cellCount: Int) -> some View {
        LazyHGrid(rows: rows(), spacing: cellSpacing) {
            ForEach((0..<cellCount).reversed(), id: \.self) { day in
                let n = absoluteDay(from: day, dayToday)
                let count = onDataCellAction?(n) ?? 0
                cell(day: n, count,
                     monthLabel: isFirstDayOfWeek(day),
                     selected: n == selectedCell)
                    .isHidden(n < 0)
                    .onTapGesture {
                        onTapCellAction?(n)
                        selectedCell = n
                    }
            }
        }
    }

    @ViewBuilder private func cell(day: Int,
                                   _ count: Int,
                                   monthLabel: Bool,
                                   selected: Bool) -> some View {
        if monthLabel {
            Cell(vLabel: monthName(from: day), count: count, selected: selected)
        } else {
            Cell(count: count, selected: selected)
        }
    }
}

// MARK: - Cell
extension ContributionGraphView {
    private func Cell(vLabel: String, count: Int, selected: Bool) -> some View {
        VStack (spacing: 0) {
            VText(vLabel)
            Cell(count: count, selected: selected)
        }.frame(width: cellSize, height: cellSize * 2,
                alignment: .bottom)
    }
    
    private func Cell(count: Int, selected: Bool) -> some View {
        RoundedRectangle(cornerRadius: cellCornerRadius)
            .strokeBorder(selected ? .orange : .black,
                          lineWidth: selected ? cellSelectedBorderWidth : cellBorderWidth)
            .frame(width: cellSize, height: cellSize)
            .background(RoundedRectangle(cornerRadius: cellCornerRadius)
                .foregroundColor(light: getColor(count), dark: getColor(count)))
    }
    
    private func VText(_ text: String) -> some View {
        VStack {
            Text("").padding(.bottom, 12.0)
        }.overlay {
            if text != "" {
                Text(text).frame(width: 60)
            }
        }
    }
}

// MARK: - Date
extension ContributionGraphView {
    private func isFirstDayOfWeek(_ day: Int) -> Bool {
        return (day > 0 && (day + 1) % 7 == 0)
    }
    
    private func week(from day: Int) -> Int {
        (day + 1) / 7
    }
    
    private func absoluteDay(from day: Int, _ today: Int) -> Int {
        day - (7 - today)
    }
    
    private func dayName(from day: Int) -> String {
        Calendar.current.shortWeekdaySymbols[day - 1]
    }
    
    private func monthName(from day: Int) -> String {
        let past = Date.neutral.days(ago: day)
        let weekOfMonth = past.weekOfMonth()
        let month = past.month()
        return weekOfMonth == 2 ? Calendar.current.shortMonthSymbols[month] : ""
    }
}

// MARK: - Color
extension ContributionGraphView {
    private func getColor(_ count: Int) -> Color {
        switch (count) {
        case 0:
            return Color(red: 0.9, green: 0.9, blue: 0.9)
        default:
            return Color(red: 0,
                         green: 1.0 - (0.2 * Double(count - 1)),
                         blue: 0.8 - (0.1 * Double(count - 1)))
        }
    }
}
