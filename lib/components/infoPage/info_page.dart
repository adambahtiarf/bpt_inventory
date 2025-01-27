import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../blank/blank.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    this.backgroundColor,
    this.errWidget,
    super.key,
    this.err,
  });

  final Widget? errWidget;

  final Color? backgroundColor;

  final FlutterErrorDetails? err;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: widget.backgroundColor,
        body: _body(),
      );

  Widget _body() {
    if (widget.err != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(),
          child: widget.errWidget ?? const Blank(),
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (_, c) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: c.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                ),
                child: widget.errWidget ?? const Blank(),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
