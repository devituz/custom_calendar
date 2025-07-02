import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../widgets/add_event_dialog.dart';

/// Main calendar screen with different view modes
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Calendar state
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Events storage (in a real app, this would be from a database)
  final Map<DateTime, List<Event>> _events = {};

  // View mode for different calendar layouts
  ViewMode _viewMode = ViewMode.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    // Add some sample events for demonstration
    _addSampleEvents();
  }

  /// Add sample events for demonstration
  void _addSampleEvents() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    _addEvent(Event(
      id: '1',
      title: 'Team Meeting',
      description: 'Weekly team sync meeting',
      dateTime: DateTime(today.year, today.month, today.day, 10, 0),
      location: 'Conference Room A',
      duration: const Duration(hours: 1),
    ));

    _addEvent(Event(
      id: '2',
      title: 'Doctor Appointment',
      description: 'Annual checkup',
      dateTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14, 30),
      location: 'Medical Center',
      duration: const Duration(minutes: 30),
    ));
  }

  /// Get events for a specific day
  List<Event> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  /// Add an event to the calendar
  void _addEvent(Event event) {
    final key = DateTime(
      event.dateTime.year,
      event.dateTime.month,
      event.dateTime.day,
    );

    setState(() {
      if (_events[key] != null) {
        _events[key]!.add(event);
      } else {
        _events[key] = [event];
      }
    });
  }

  /// Update an existing event
  void _updateEvent(Event oldEvent, Event newEvent) {
    // Remove from old date
    final oldKey = DateTime(
      oldEvent.dateTime.year,
      oldEvent.dateTime.month,
      oldEvent.dateTime.day,
    );
    _events[oldKey]?.remove(oldEvent);

    // Add to new date
    _addEvent(newEvent);
  }

  /// Delete an event
  void _deleteEvent(Event event) {
    final key = DateTime(
      event.dateTime.year,
      event.dateTime.month,
      event.dateTime.day,
    );

    setState(() {
      _events[key]?.remove(event);
      if (_events[key]?.isEmpty == true) {
        _events.remove(key);
      }
    });
  }

  /// Show add event dialog
  Future<void> _showAddEventDialog([Event? event]) async {
    final result = await showDialog<Event>(
      context: context,
      builder: (context) => AddEventDialog(
        event: event,
        selectedDate: _selectedDay,
      ),
    );

    if (result != null) {
      if (event != null) {
        _updateEvent(event, result);
      } else {
        _addEvent(result);
      }
    }
  }

  /// Show event options (edit/delete)
  void _showEventOptions(Event event) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Event'),
            onTap: () {
              Navigator.pop(context);
              _showAddEventDialog(event);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Event', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(event);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(event);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Build calendar widget based on view mode
  Widget _buildCalendar() {
    switch (_viewMode) {
      case ViewMode.month:
        return _buildMonthView();
      case ViewMode.week:
        return _buildWeekView();
      case ViewMode.day:
        return _buildDayView();
    }
  }

  /// Build month view calendar
  Widget _buildMonthView() {
    return TableCalendar<Event>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: Colors.red[400]),
        holidayTextStyle: TextStyle(color: Colors.red[400]),
        markerDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
      ),
    );
  }

  /// Build week view (simplified)
  Widget _buildWeekView() {
    return TableCalendar<Event>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: TextStyle(color: Colors.red[400]),
        markerDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  /// Build day view
  Widget _buildDayView() {
    final events = _getEventsForDay(_selectedDay);

    return Column(
      children: [
        // Day header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                    _focusedDay = _selectedDay;
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.add(const Duration(days: 1));
                    _focusedDay = _selectedDay;
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        // Events for the day
        Expanded(
          child: events.isEmpty
              ? const Center(
            child: Text(
              'No events for this day',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  /// Build event card widget
  Widget _buildEventCard(Event event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description.isNotEmpty)
              Text(event.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${TimeOfDay.fromDateTime(event.dateTime).format(context)} - ${TimeOfDay.fromDateTime(event.dateTime.add(event.duration)).format(context)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        onTap: () => _showEventOptions(event),
      ),
    );
  }

  /// Build events list for selected day
  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Events for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? const Center(
            child: Text(
              'No events for this day\nTap + to add an event',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        actions: [
          // View mode selector
          PopupMenuButton<ViewMode>(
            icon: const Icon(Icons.view_module),
            onSelected: (ViewMode mode) {
              setState(() {
                _viewMode = mode;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ViewMode.month,
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_month),
                    SizedBox(width: 8),
                    Text('Month'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ViewMode.week,
                child: Row(
                  children: [
                    Icon(Icons.calendar_view_week),
                    SizedBox(width: 8),
                    Text('Week'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ViewMode.day,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Day'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar view
          if (_viewMode != ViewMode.day) ...[
            _buildCalendar(),
            const Divider(height: 1),
          ],

          // Events list or day view
          Expanded(
            child: _viewMode == ViewMode.day
                ? _buildDayView()
                : _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Enum for different view modes
enum ViewMode { month, week, day }
