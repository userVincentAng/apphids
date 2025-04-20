import 'package:flutter/foundation.dart';

bool get isMobile => !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
bool get isWeb => kIsWeb;