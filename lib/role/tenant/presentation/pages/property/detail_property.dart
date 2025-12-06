import 'package:flutter/material.dart';
import 'package:rentverse/common/widget/custom_app_bar.dart';

class DetailProperty extends StatelessWidget {
  const DetailProperty({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(appBar: CustomAppBar(displayName: 'Property Details')),
    );
  }
}
