import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomCalendarPage(),
    );
  }
}

class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({super.key});

  @override
  _CustomCalendarPageState createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  DateTime focusedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(
      lastDay.day,
          (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now(); // Bugungi kunni olish uchun
    final daysInMonth = _getDaysInMonth(focusedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back, size: 28, color: Colors.pink),
                Text(
                  "${_monthName(focusedDate.month)}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward, size: 28, color: Colors.pink),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                  .map(
                    (day) => Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          SizedBox(
            width: 500,
            height: 500,
            child: Column(
              children: [Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: daysInMonth.length,
                  itemBuilder: (context, index) {
                    final day = daysInMonth[index];
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
                          selectedDate = day;
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
                                width: MediaQuery.of(context).size.width * 0.12, // Ekran kengligining 12% ga teng
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Boshida va oxirida joylashtirish
                                  children: [
                                    Text(
                                      "${day.day}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected || isToday || isHighlighted
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16, // Ekran kichik bo'lsa, font hajmi kichrayadi
                                      ),
                                    ),
                                    Text(
                                      "1",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected || isToday || isHighlighted
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: MediaQuery.of(context).size.width < 400 ? 8 : 10, // Ekran kichik bo'lsa, font hajmi kichrayadi
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
                  padding: const EdgeInsets.all(16.0),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Cycle Day 12 - Follicular Phase",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.edit, color: Colors.white),
                            label: Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity, // Chiziq uzunligi ekranning to'liq kengligi
                        height: 1, // Chiziqning balandligi
                        color: Colors.black, // Chiziq rangi
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Medium",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Chance of getting pregnant",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),],
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

hafta kuni hafta sanasiga tog'ri kelsin bir biriga