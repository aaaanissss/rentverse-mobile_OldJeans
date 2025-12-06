import 'package:flutter/material.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/common/screen/navigation_container.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/auth/presentation/pages/profile_pages.dart';
import 'package:rentverse/role/tenant/presentation/pages/chat.dart';
import 'package:rentverse/role/tenant/presentation/pages/home.dart';
import 'package:rentverse/role/tenant/presentation/pages/property/property.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyTestApp());
}

/// Entry point for UI slicing without auth; always loads tenant navigation.
class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: appBackgroundColor),
      home: const NavigationContainer(
        pages: [
          TenantHomePage(),
          TenantPropertyPage(),
          TenantRentPage(),
          TenantChatPage(),
          ProfilePage(),
        ],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            activeIcon: GradientIcon(icon: Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment, color: Colors.grey),
            activeIcon: GradientIcon(icon: Icons.apartment),
            label: 'Property',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long, color: Colors.grey),
            activeIcon: GradientIcon(icon: Icons.receipt_long),
            label: 'Rent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.grey),
            activeIcon: GradientIcon(icon: Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            activeIcon: GradientIcon(icon: Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
