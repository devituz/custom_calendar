import 'package:flutter/material.dart';

class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({super.key});

  @override
  _CustomCalendarPageState createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  List<DateTime?> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 0);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final firstDayOfWeek = firstDay.weekday;

    int startOffset = (firstDayOfWeek % 7);

    List<DateTime?> daysInMonth = List.generate(
      lastDay.day + startOffset,
          (index) {
        if (index < startOffset) {
          return null;
        }
        return DateTime(date.year, date.month, index - startOffset + 1);
      },
    );

    return daysInMonth;
  }

  void _goToNextMonth() {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month + 1, 1);
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month - 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysInMonth = _getDaysInMonth(focusedDate);

    List<String> weekDays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.bloodtype_outlined, size: screenWidth * 0.08, color: Colors.pink),
                Text(
                  "${_monthName(focusedDate.month)}",
                  style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.calendar_month, size: screenWidth * 0.08, color: Colors.pink),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays
                  .map(
                    (day) => Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.56,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: daysInMonth.length,
                    itemBuilder: (context, index) {
                      final day = daysInMonth[index];
                      if (day == null) {
                        return Container(); // Return empty container for previous month days
                      }

                      final isSelected = selectedDate.day == day.day &&
                          selectedDate.month == day.month &&
                          selectedDate.year == day.year;
                      final isToday = day.day == today.day &&
                          day.month == today.month &&
                          day.year == today.year;
                      final isHighlighted = [16, 17, 18, 19].contains(day.day);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = day!;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.amberAccent
                                : isToday
                                ? Colors.amber
                                : isHighlighted
                                ? Colors.pink
                                : Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth * 0.12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${day.day}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected || isToday || isHighlighted
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: screenWidth < 400 ? 14 : 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_monthName(today.month)} ${today.day}",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                "Cycle Day 12 - Follicular Phase",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.bloodtype, color: Colors.pink),
                            label: Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                      ),
                      Row(
                      spacing: screenWidth * 0.03,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Medium",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.03,
                              ),
                            ),
                          ),

                          Text(
                            " - Chance of getting pregnant",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousMonth,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.015), // Ichki padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text("Previous Month", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  ElevatedButton(
                    onPressed: _goToNextMonth,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text("Next Month", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}

