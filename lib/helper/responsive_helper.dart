import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _desktopBreakpoint = 900;
  static const double _tabletBreakpoint = 600;

  static bool isDesktop(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return mediaWidth >= _desktopBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return mediaWidth >= _tabletBreakpoint && mediaWidth < _desktopBreakpoint;
  }

  static bool isPhone(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return mediaWidth < _tabletBreakpoint;
  }

  static int responsiveAxisCountGrid(BuildContext context) {
    if (isDesktop(context)) {
      return 5;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 2;
    }
  }
}
