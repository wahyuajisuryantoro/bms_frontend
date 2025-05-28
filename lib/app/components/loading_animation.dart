import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationLoading extends StatelessWidget {
  final double? width;
  final double? height;
  
  const AnimationLoading({
    Key? key, 
    this.width = 120, 
    this.height = 120,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loading.json',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
  
  // Method statis untuk membuat container dengan tinggi tertentu
  static Widget container({double height = 120, double? width, double? animationWidth, double? animationHeight}) {
    return Container(
      width: width,
      height: height,
      child: AnimationLoading(
        width: animationWidth,
        height: animationHeight,
      ),
    );
  }
}