import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes; // 25분을 환산하면 1500초
  bool isRunning = false;
  bool isResetPressed = false;
  int totalPomodoros = 0;
  late Timer timer; // 타이머 선언 나중에 ~ 초기화 할게!

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    // 타이머를 멈추는 역할
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void formatTimer() { // 리셋 버튼
    timer.cancel();
    setState(() {
      totalSeconds = twentyFiveMinutes;
      isResetPressed = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7); // 문자열 잘라내기
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                  ),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: formatTimer,
                    icon: Icon(Icons.stop_circle_outlined),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pomodoros',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$totalPomodoros',
                        style: TextStyle(
                            fontSize: 60,
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
