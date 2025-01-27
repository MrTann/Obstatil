import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/scheduler.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  // Single yerine Ticker kullanıldı
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _shadowAnimation;
  late AnimationController _buttonPulseController;
  late Animation<double> _buttonPulseAnimation;

  bool isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    // Ana animasyon controller'ı
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _positionAnimation = Tween<double>(begin: 300.0, end: 220.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Kalp atışı efekti için yeni controller
    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _buttonPulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonPulseController, curve: Curves.easeInOut),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isAnimationCompleted = true; // Animasyon tamamlandı işaretle
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _positionAnimation.value,
                left: MediaQuery.of(context).size.width / 2 - 80,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: _shadowAnimation.value,
                            offset: Offset(0, _shadowAnimation.value),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/girisanimasyon.png',
              width: 160,
              height: 160,
            ),
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 90,
            child: AnimatedBuilder(
              animation: _buttonPulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _buttonPulseAnimation.value,
                  child: ElevatedButton(
                    onPressed: isAnimationCompleted
                        ? () {
                            context.go(
                                '/login'); // Animasyon tamamlandıysa yönlendir
                          }
                        : null, // Animasyon bitmediyse buton pasif
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blue.shade800,
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      shadowColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.4),
                      ),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    child: Text(
                      'Giriş Yap',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
