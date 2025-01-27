import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/text/text.dart';
import '../controllers/sample_controller.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  SampleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText.google(text: "SAMPLE PAGE")),
    );
  }
}
