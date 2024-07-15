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
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;

  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true ;
    Timer.periodic(Duration(milliseconds: 10), (timer){
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
                      child: Text(
                        gameHasStarted ? '':'P L A Y',
                        style: TextStyle(color: Colors.white , fontSize: 20),
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