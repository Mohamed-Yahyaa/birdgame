import 'dart:async';

import 'package:birdgame/bird.dart';
import 'package:flutter/material.dart';


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

  void startGame() {
    gameHasStarted = true ;
    Timer.periodic(Duration(milliseconds: 80), (timer){
      height = gravity * time * time + velocity * time;


      setState(() {
        birdY = initialPos - height;
      });

      if(birdIsDead()){
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      // print(birdY);

      // if(birdY < -1 || birdY > 1){
      //   timer.cancel();

      // }


      time += 0.1;
    });
  }

void resetGame(){
  Navigator.pop(context);
  setState(() {
    birdY = 0;
    gameHasStarted = false;
    time = 0;
    initialPos = birdY;
  });
}

void _showDialog(){
  showDialog(
    context: context,
    barrierDismissible: false,
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
    });
}
 
 void jump(){
  setState(() {
    time = 0;
    initialPos = birdY ;
  });

 }

 bool birdIsDead(){
   if(birdY < -1 || birdY > 1){
        return true;
      }
      return false;
 }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
    child: Scaffold(
      body: Column(
        children: [
          Expanded(
            flex:3 ,
            child: Container(
              color: Colors.blue[300],
              child: Center(
                child: Stack(
                  children: [
                    MyBird(
                      birdY: birdY,
                    ),
                    Container(
                      child: Center( 
                      child: Text(
                        gameHasStarted ? '':'P L A Y',
                        style: TextStyle(color: Colors.white , fontSize: 40 , height: -4),
                      ),
                      ),
                    )
                  ],
                ),
              ),
            ) ),
            Expanded(
              child: Container(
                color: Colors.brown[400],
              ))
        ],
      ),
    )
    );
  }
}