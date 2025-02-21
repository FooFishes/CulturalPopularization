import 'package:flutter/material.dart';
import '../route/routes.dart';
import '../models/user_inf.dart';
import '../dio/user_dio.dart';
import 'package:dio/dio.dart';
import 'dart:math';
/// 首页(开始)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  bool hasLogin = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState(){
    super.initState();
    //初始化
    initialize();
    //加载动画
    _controller = AnimationController(
      duration: const Duration(seconds: 9),//调节旋转速度
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  ///初始化
  Future<void> initialize()async{
    User.init();
    if(User.uid!=-1&&User.token.isNotEmpty){
      try{
        Response res = await UserDio.refTk();
        if(res.data['code']==200){
          hasLogin = true;
          await User.setToken(res.data['data']);
        }else{
          hasLogin = false;
        }
      }catch(e){
        hasLogin = false;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              setState(() {
                _isAnimating = true;
              });
              Future.delayed(const Duration(seconds: 2),(){
                if(hasLogin){
                  Routes.pushForNamed(context, RoutePath.selectJigsawPuzzle);
                }else{
                  Routes.pushForNamed(context, RoutePath.login);
                }
              });
              
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/image/背景.jpg',fit:BoxFit.cover),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/image/开始页面花.png'

                      ),
                      const Text(
                        '开始',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 小鱼 1
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final angle = _isAnimating ? _animation.value : pi/4;
                          final x = 145 * cos(angle);
                          final y = 145 * sin(angle);
                          return Positioned(
                            left: MediaQuery.of(context).size.width / 9 + x ,
                            top: MediaQuery.of(context).size.height / 25 + y ,
                            child: Transform.rotate(
                              angle: angle + pi,
                              child: Image.asset(
                                'assets/image/鱼.png',
                                width: 360,
                                height: 360,
                              ),
                            ),
                          );
                        },
                      ),
                      // 小鱼 2
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final angle = _isAnimating ? _animation.value + pi : pi+pi/4;
                          final x = 145 * cos(angle);
                          final y = 145 * sin(angle);
                          return Positioned(
                            left: MediaQuery.of(context).size.width / 9 + x ,
                            top: MediaQuery.of(context).size.height / 25 + y ,
                            child: Transform.rotate(
                              angle: angle + pi ,
                              child: Image.asset(
                                'assets/image/鱼.png',
                                width: 360,
                                height: 360,
                              ),
                            ),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ],
            ),
        )
    );
  }
}
