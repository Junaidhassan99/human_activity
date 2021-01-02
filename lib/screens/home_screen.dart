import 'package:flutter/material.dart';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<ActivityEvent> activityStream;
  ActivityEvent latestActivity = ActivityEvent.empty();
  List<ActivityEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    if (await Permission.activityRecognition.request().isGranted) {
      activityStream =
          ActivityRecognition.activityStream(runForegroundService: true);
      activityStream.listen(onData);
    }
  }

  void onData(ActivityEvent activityEvent) {
    print(activityEvent.toString());
    setState(() {
      _events.insert(0, activityEvent);
      latestActivity = activityEvent;
    });
  }

  Widget _dataTextWidget(double fontSize, String title, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
        ),
        children: <TextSpan>[
          TextSpan(
            text: title,
          ),
          TextSpan(text: ' : '),
          TextSpan(
            text: value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Human Activity Recognition'),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 50),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  radius: 150,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${latestActivity.type.toString().split('.').last.replaceAll('_', ' ')}',
                          style: TextStyle(fontSize: 60),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _dataTextWidget(
                            20, 'Confidence', '${latestActivity.confidence} %'),
                        SizedBox(
                          height: 5,
                        ),
                        _dataTextWidget(18, 'At',
                            '${DateFormat.jms().format(latestActivity.timeStamp)}'),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _events.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int idx) {
                    final entry = _events[idx];
                    return ListTile(
                      tileColor: Theme.of(context)
                          .accentColor
                          .withOpacity((idx + 1) / (_events.length)),
                      trailing: Text(
                        '${DateFormat.jms().format(entry.timeStamp)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: Text(
                        entry.type.toString().split('.').last,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
