import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';



class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage() : super();
  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends ModularState<SplashScreenPage, SplashscreenController>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  ReactionDisposer? disposer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250,
      ),
    );
    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    init();
  }

  Future init() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    await _controller.forward();
    controller.streamStatusUserAuthenticate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: AppColors.transparent,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: AppColors.primaryColor,
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: AppColors.primaryColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FadeTransition(
                      opacity: _animation as Animation<double>,
                      child: Container(
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              'GPS BALLOON',
                              speed: const Duration(milliseconds: 100),
                              textStyle: TextStyles.megaTitle,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
