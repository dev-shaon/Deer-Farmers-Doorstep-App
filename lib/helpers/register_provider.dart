// import 'package:kabirumar/provider/verification_masjid_provider.dart';
import 'package:provider/provider.dart';
import 'package:size_matter_swt/providers/auth_provider.dart';
import 'package:size_matter_swt/providers/subscription_provider.dart';

var providers = [
  ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
  ChangeNotifierProvider<SubscriptionProvider>(create: (context) => SubscriptionProvider()),
];