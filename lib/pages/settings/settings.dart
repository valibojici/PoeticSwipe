import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/services/interfaces/settings_interface.dart';
import 'package:poetry_app/services/notifications.dart';
import 'package:poetry_app/themes/theme.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SettingsServiceI _settingsService;
  bool _isLoading = true;
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 0, minute: 0);

  @override
  void initState() {
    GetIt.I.getAsync<SettingsServiceI>().then((settingsService) {
      setState(() {
        _settingsService = settingsService;
        _notificationsEnabled = _settingsService.getNotificationsEnabled();
        _notificationTime = TimeOfDay(
          hour: _settingsService.getNotificationHour(),
          minute: _settingsService.getNotificationMinutes(),
        );
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  _notificationsToggle(),
                  _notificationsTime(),
                  _darkModeToggle(themeProvider),
                ],
              ),
            ),
    );
  }

  Widget _notificationsToggle() {
    return ListTile(
      title: const Text('Enable notifications'),
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: (value) async {
          await _settingsService.toggleNotifications(value);
          if (value == false) {
            await GetIt.I.get<NotificationService>().cancelAll();
          } else {
            // schedule notification
            await GetIt.I.get<NotificationService>().scheduleDailyNotification(
                  hour: _notificationTime.hour,
                  minute: _notificationTime.minute,
                  title: 'Poetry',
                  body: 'Check out a poem!',
                );
          }
          setState(() {
            _notificationsEnabled = value;
          });
        },
      ),
    );
  }

  Widget _notificationsTime() {
    String formatTime() {
      return "${_notificationTime.hour.toString().padLeft(2, "0")}:${_notificationTime.minute.toString().padLeft(2, '0')}";
    }

    if (!_notificationsEnabled) {
      return Container();
    }

    return ListTile(
      title: const Text('Notification time'),
      subtitle: Text(
        "Daily at ${formatTime()}",
      ),
      trailing: TextButton(
        child: const Text("Edit"),
        onPressed: () async {
          TimeOfDay? time = await _showTimePicker();
          if (time == null) return;
          await _settingsService.setNotificationTime(time.hour, time.minute);
          // schedule notification
          await GetIt.I.get<NotificationService>().scheduleDailyNotification(
                hour: time.hour,
                minute: time.minute,
                title: 'Poetry',
                body: 'Check out a poem!',
              );
          setState(() {
            _notificationTime = time;
          });
        },
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker() => showTimePicker(
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        context: context,
        initialTime: TimeOfDay(
            hour: _settingsService.getNotificationHour(),
            minute: _settingsService.getNotificationMinutes()),
      );

  Widget _darkModeToggle(ThemeProvider themeProvider) {
    return ListTile(
      title: const Text('Enable dark mode'),
      trailing: Switch(
          value: themeProvider.darkModeEnabled,
          onChanged: (value) {
            themeProvider.setTheme(value ? ThemeType.dark : ThemeType.light);
          }),
    );
  }
}
