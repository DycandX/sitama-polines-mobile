import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/main_wrapper.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/sidang_tugas_akhir/sidang_ta_dosen_screen_pembimbing.dart';
import 'package:pbl_sitama/modules/08_home_dosen/profile_page.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_screen.dart';

import 'modules/01_launch/welcome_page.dart';


// import 'package:go_router_example/views/player/player_view.dart';
// import 'package:go_router_example/views/settings/settings_view.dart';
// import 'package:go_router_example/views/settings/sub_setting_view.dart';

// class AppNavigation {
//   AppNavigation._();

//   static String initial = "/home";

//   // Private navigators
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();
//   static final _shellNavigatorHome =
//       GlobalKey<NavigatorState>(debugLabel: 'shellHome');
//   static final _shellNavigatorSettings =
//       GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

//   // GoRouter configuration
//   static final GoRouter router = GoRouter(
//     initialLocation: initial,
//     debugLogDiagnostics: true,
//     navigatorKey: _rootNavigatorKey,
//     routes: [
//       /// MainWrapper
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return MainWrapper(
//             navigationShell: navigationShell,
//           );
//         },
//         branches: <StatefulShellBranch>[
//           /// Brach Home
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorHome,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: "/home",
//                 name: "Home",
//                 builder: (BuildContext context, GoRouterState state) =>
//                     JadwalSidangPage(),
//                 routes: [
//                   // GoRoute(
//                   //   path: 'subHome',
//                   //   name: 'subHome',
//                   //   pageBuilder: (context, state) => CustomTransitionPage<void>(
//                   //     key: state.pageKey,
//                   //     child: const SubHomeView(),
//                   //     transitionsBuilder:
//                   //         (context, animation, secondaryAnimation, child) =>
//                   //             FadeTransition(opacity: animation, child: child),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),

//           //branch bimbingan
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorHome,
//             routes: <RouteBase>[

//             ],
//           ),

//           /// Brach Setting
//           StatefulShellBranch(
//             navigatorKey: _shellNavigatorSettings,
//             routes: <RouteBase>[
//               GoRoute(
//                 path: "/bimbingan",
//                 name: "Bimbingan",
//                 builder: (BuildContext context, GoRouterState state) =>
//                     const MahasiswaBimbingan(),
//                 // routes: [
//                 //   GoRoute(
//                 //     path: "subSetting",
//                 //     name: "subSetting",
//                 //     pageBuilder: (context, state) {
//                 //       return CustomTransitionPage<void>(
//                 //         key: state.pageKey,
//                 //         child: const SubSettingsView(),
//                 //         transitionsBuilder: (
//                 //           context,
//                 //           animation,
//                 //           secondaryAnimation,
//                 //           child,
//                 //         ) =>
//                 //             FadeTransition(opacity: animation, child: child),
//                 //       );
//                 //     },
//                 //   ),
//                 // ],
//               ),
//             ],
//           ),
//         ],
//       ),

//       /// Player
//       // GoRoute(
//       //   parentNavigatorKey: _rootNavigatorKey,
//       //   path: '/player',
//       //   name: "Player",
//       //   builder: (context, state) => PlayerView(
//       //     key: state.pageKey,
//       //   ),
//       // )
//     ],
//   );
// }
class AppNavigation {
  AppNavigation._();

  static String initial = "/welcomepage";

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorWelcome =
      GlobalKey<NavigatorState>(debugLabel: 'shellWelcome');
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorBimbingan =
      GlobalKey<NavigatorState>(debugLabel: 'shellBimbingan'); // New key
  static final _shellNavigatorMenguji =
      GlobalKey<NavigatorState>(debugLabel: 'shellMenguji');
  static final _shellNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: 'shellProfil');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          /// Branch Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome, // Unique key
            routes: <RouteBase>[
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (BuildContext context, GoRouterState state) =>
                    JadwalSidangPage(),
                routes: [
                  GoRoute(
                    path: "subSetting",
                    name: "subSetting",
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child:homeMahasiswaScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Branch Bimbingan
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBimbingan, // Unique key
            routes: <RouteBase>[
              GoRoute(
                path: "/bimbingan",
                name: "Bimbingan",
                builder: (BuildContext context, GoRouterState state) =>
                    const MahasiswaBimbingan(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMenguji, // Unique key
            routes: <RouteBase>[
              GoRoute(
                path: "/menguji",
                name: "Menguji",
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile, // Unique key
            routes: <RouteBase>[
              GoRoute(
                path: "/profile",
                name: "Profile",
                builder: (BuildContext context, GoRouterState state) =>
                    ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWelcome, // Unique key
            routes: <RouteBase>[
              GoRoute(
                path: "/welcomepage",
                name: "welcomepage",
                builder: (BuildContext context, GoRouterState state) =>
                    WelcomePage(),
              ),
            ],
          ),

          /// Branch Settings
        ],
      ),
    ],
  );
}
