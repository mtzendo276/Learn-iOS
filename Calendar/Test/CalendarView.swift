//
//  CalendarView.swift
//  Test
//
//  Created by Chen Yue on 15/01/23.
//

import SwiftUI
//test

struct CalendarView: View {
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }()
    private let monthFormatter: DateFormatter 
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private static var now = Date()
    
    private let daysInWeek = 7
    private let dayItemSize: CGFloat = 40
        
    @State private var selectedDate = Self.now
    
    init() {
        self.monthFormatter = DateFormatter(dateFormat: "MMMM YYYY", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
    }
    
    var body: some View {
        VStack {
            TitleView()
            ContentView()
        }
    }
    
}

extension CalendarView {
    
    @ViewBuilder
    func TitleView() -> some View {
        HStack {
            Button {
                guard let newDate = calendar.date(byAdding: .month, value: -1,  to: selectedDate) else { return }
                selectedDate = newDate
            } label: {
                Image(systemName: "chevron.left")
                          .font(.title2)
                          .foregroundColor(.black)
            }
            Spacer()
            Text(monthFormatter.string(from: selectedDate.startOfMonth(using: calendar)).uppercased())
                .foregroundColor(.black)
                .font(.title2)
            Spacer()
            Button {
                guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) else { return }
                selectedDate = newDate
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        let month = selectedDate.startOfMonth(using: calendar)
        let days = makeDays()
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                ForEach(days.prefix(daysInWeek), id: \.self) { date in
                    Text(weekDayFormatter.string(from: date).uppercased())
                        .fontWeight(.bold)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        ZStack {
                            if calendar.isDateInToday(date) && !calendar.isDateInWeekend(date) {
                                Circle()
                                    .stroke(.black, lineWidth: 1)
                                    .frame(width: dayItemSize, height: dayItemSize)
                            }
                            if calendar.isDate(date, inSameDayAs: selectedDate) && !calendar.isDateInWeekend(date) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: dayItemSize, height: dayItemSize)
                            }
                            if calendar.isDateInWeekend(date) {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: dayItemSize, height: dayItemSize)
                            }
                            Button(action: { selectedDate = date }) {
                                Text(dayFormatter.string(from: date))
                                    .frame(width: dayItemSize, height: dayItemSize, alignment: .center)
                                    .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                            }
                            .disabled(calendar.isDateInWeekend(date))
                        }
                    } else {
                        ZStack {
                            if calendar.isDateInWeekend(date) {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: dayItemSize, height: dayItemSize)
                            }
                            Text(dayFormatter.string(from: date))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
}

private extension CalendarView {
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
    
}

private extension Calendar {
    
    func generateDates(for dateInterval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [dateInterval.start]
        enumerateDates(startingAfter: dateInterval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date, date < dateInterval.end else {
                stop = true
                return
            }
            dates.append(date)
        }
        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
    
}

private extension Date {
    
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
    
}

private extension DateFormatter {
    
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
    
}

// MARK: - Previews
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
