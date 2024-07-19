import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:birdgame/barriers.dart';
import 'package:birdgame/bird.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0.5;
  double gravity = -4.9;
  double velocity = 2.8;

  bool gameHasStarted = false;
  static double barrierOne = 1;
  double barrierTwo = barrierOne + 1.5;

  int _currentScore = 0;
  int _bestScore = 0;

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _gameOverPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.play(AssetSource('sound.mp3'), volume: 0.5);
      _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  void _playGameOverSound() async {
    try {
      await _gameOverPlayer.play(AssetSource('over.mp3'), volume: 1.0);
    } catch (e) {
      print("Error playing game over sound: $e");
    }
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 80), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      setState(() {
        if (barrierOne < -2) {
          barrierOne += 3.5;
          _currentScore++; // Increment score
        } else {
          barrierOne -= 0.05;
        }
      });

      setState(() {
        if (barrierTwo < -2) {
          barrierTwo += 3.5;
        } else {
          barrierTwo -= 0.05;
        }
      });

      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _playGameOverSound();
        _showDialog();
      }

      time += 0.1;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      _currentScore = 0;
      barrierOne = 1;
      barrierTwo = barrierOne + 1.5;
    });
  }

  void _showDialog() {
    setState(() {
      if (_currentScore > _bestScore) {
        _bestScore = _currentScore;
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "G A M E   O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "PLAY AGAIN",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    _gameOverPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blueGrey[300],
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            gameHasStarted ? '' : 'P L A Y',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                height: -4),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierOne, 1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 250.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierOne, -1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 230.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierTwo, 1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 190.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierTwo, -1.1),
                        duration: Duration(milliseconds: 0),
                        child: MyBarrier(
                          size: 280.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.grey[300],
            ),
            Expanded(
              child: Container(
                color: Colors.grey[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$_currentScore",
                          style: TextStyle(
                              color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20),
                        Text(
                          "$_bestScore",
                          style: TextStyle(
                              color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
