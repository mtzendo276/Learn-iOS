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
        
    @State private var selectedDate = Self.now
    
    init() {
        self.monthFormatter = DateFormatter(dateFormat: "MMMM YYYY", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
    }
    
    var body: some View {
        VStack {
            CalendarViewComponent(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    ZStack {
                        if calendar.isDateInToday(date) && !calendar.isDateInWeekend(date) {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .frame(width: 40, height: 40)
                        }
                        if calendar.isDate(date, inSameDayAs: selectedDate) && !calendar.isDateInWeekend(date) {
                            Circle()
                                .fill(.blue)
                                .frame(width: 40, height: 40)
                        }
                        if calendar.isDateInWeekend(date) {
                            Circle()
                                .fill(.gray)
                                .frame(width: 40, height: 40)
                        }
                        Button(action: { selectedDate = date }) {
                            Text(dayFormatter.string(from: date))
                                .padding(6)
                                .frame(width: 33, height: 33, alignment: .center)
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                        }
                        .disabled(calendar.isDateInWeekend(date))
                        
                    }
                },
                trailing: { date in
                    ZStack {
                        if calendar.isDateInWeekend(date) {
                            Circle()
                                .fill(.gray)
                                .frame(width: 40, height: 40)
                        }
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    }
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date).uppercased())
                        .fontWeight(.bold)
                },
                title: { date in
                    HStack {
                        Button {
                            guard let newDate = calendar.date(
                                byAdding: .month,
                                value: -1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            selectedDate = newDate
                            
                        } label: {
                            Label(
                                title: { Text("Previous") },
                                icon: {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedDate = Date.now
                        } label: {
                            Text(monthFormatter.string(from: date).uppercased())
                                .foregroundColor(.black)
                                .font(.title2)
                                .padding(2)
                        }
                        
                        Spacer()
                        
                        Button {
                            guard let newDate = calendar.date(
                                byAdding: .month,
                                value: 1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            
                            selectedDate = newDate
                            
                        } label: {
                            Label(
                                title: { Text("Next") },
                                icon: {
                                    Image(systemName: "chevron.right")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }
                    }
                }
            )
            .equatable()
            Spacer()
        }
    }
    
}

// MARK: - Component

public struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Environment(\.colorScheme) var colorScheme

    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        VStack {
            Section(header: title(month)) { }
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                }
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date)
                        } else {
                            trailing(date)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Equatable
extension CalendarViewComponent: Equatable {
    
    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
    
}

// MARK: - Helpers
private extension CalendarViewComponent {
    
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
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
    
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
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
