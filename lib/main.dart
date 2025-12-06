//lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/bloc/auth/auth_cubit.dart';
import 'package:rentverse/common/bloc/auth/auth_state.dart';
import 'package:rentverse/common/bloc/navigation/navigation_cubit.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/core/services/notification_service.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/auth/domain/entity/user_entity.dart';
import 'package:rentverse/features/auth/presentation/pages/auth_pages.dart';
import 'package:rentverse/features/auth/presentation/pages/profile_pages.dart';
import 'package:rentverse/role/lanlord/presentation/pages/chat.dart';
import 'package:rentverse/role/lanlord/presentation/pages/dashboard.dart';
import 'package:rentverse/role/lanlord/presentation/pages/history.dart';
import 'package:rentverse/role/tenant/presentation/pages/chat.dart';
import 'package:rentverse/role/tenant/presentation/pages/home.dart';
import 'package:rentverse/role/tenant/presentation/pages/property/property.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent.dart';
import 'package:rentverse/common/screen/navigation_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeFirebase();
  await setupServiceLocator();
  final notificationService = sl<NotificationService>();
  await notificationService.initLocalNotifications();
  await notificationService.configureForegroundPresentation();
  notificationService.listenForegroundMessages();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (context) => sl<NavigationCubit>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: appBackgroundColor,

          // scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final nav = _buildNavigationConfig(state.user);
              return NavigationContainer(pages: nav.pages, items: nav.items);
            } else if (state is UnAuthenticated) {
              return const AuthPages();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}

class _NavigationConfig {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;

  const _NavigationConfig({required this.pages, required this.items});
}

_NavigationConfig _buildNavigationConfig(UserEntity user) {
  if (user.isLandlord) {
    return _NavigationConfig(
      pages: const [
        LandlordDashboardPage(),
        LandlordHistoryPage(),
        LandlordChatPage(),
        ProfilePage(),
      ],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: Colors.grey),
          activeIcon: GradientIcon(icon: Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history, color: Colors.grey),
          activeIcon: GradientIcon(icon: Icons.history),
          label: 'History',
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
    );
  }

  // Default to tenant navigation when no landlord role is present
  return _NavigationConfig(
    pages: const [
      TenantHomePage(),
      TenantPropertyPage(),
      TenantRentPage(),
      TenantChatPage(),
      ProfilePage(),
    ],
    items: const [
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
  );
}
