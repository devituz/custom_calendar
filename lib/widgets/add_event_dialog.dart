import 'package:flutter/material.dart';
import '../models/event_model.dart';

/// Dialog for adding or editing calendar events
class AddEventDialog extends StatefulWidget {
  final Event? event; // null for new event, existing event for editing
  final DateTime selectedDate;

  const AddEventDialog({
    Key? key,
    this.event,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  late DateTime _selectedDateTime;
  late TimeOfDay _selectedTime;
  Duration _duration = const Duration(hours: 1);

  @override
  void initState() {
    super.initState();

    // Initialize with existing event data or defaults
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _selectedDateTime = widget.event!.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.event!.dateTime);
      _duration = widget.event!.duration;
    } else {
      _selectedDateTime = widget.selectedDate;
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Show time picker dialog
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  /// Show date picker dialog
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  /// Show duration picker
  void _showDurationPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('30 minutes'),
              leading: Radio<Duration>(
                value: const Duration(minutes: 30),
                groupValue: _duration,
                onChanged: (value) {
                  setState(() => _duration = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('1 hour'),
              leading: Radio<Duration>(
                value: const Duration(hours: 1),
                groupValue: _duration,
                onChanged: (value) {
                  setState(() => _duration = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('2 hours'),
              leading: Radio<Duration>(
                value: const Duration(hours: 2),
                groupValue: _duration,
                onChanged: (value) {
                  setState(() => _duration = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('All day'),
              leading: Radio<Duration>(
                value: const Duration(hours: 24),
                groupValue: _duration,
                onChanged: (value) {
                  setState(() => _duration = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Save the event
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: _selectedDateTime,
        location: _locationController.text.trim(),
        duration: _duration,
      );

      Navigator.of(context).pop(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.event != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Event' : 'Add New Event'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Location field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Date and time selection
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date'),
                      subtitle: Text(
                        '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year}',
                      ),
                      onTap: _selectDate,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text(_selectedTime.format(context)),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),

              // Duration selection
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Duration'),
                subtitle: Text(_duration.inHours >= 24
                    ? 'All day'
                    : _duration.inHours > 0
                    ? '${_duration.inHours}h ${_duration.inMinutes % 60}m'
                    : '${_duration.inMinutes}m'),
                onTap: _showDurationPicker,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveEvent,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
