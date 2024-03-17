import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialseed/app/cubits/auth/auth_cubit.dart';
import 'package:socialseed/app/cubits/credential/credential_cubit.dart';
import 'package:socialseed/app/cubits/get_single_user/get_single_user_cubit.dart';
import 'package:socialseed/app/cubits/users/user_cubit.dart';
import 'package:socialseed/app/screens/home_screen.dart';
import 'package:socialseed/app/screens/signin_screen.dart';
import 'package:socialseed/app/screens/signup_screen.dart';
import 'package:socialseed/app/widgets/opacity_leaf_animation.dart';
import 'package:socialseed/firebase_options.dart';
import 'package:socialseed/utils/constants/ongenerate_routes.dart';
import 'dependency_injection.dart' as di;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        title: "Socialseed",
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoutes.route,
        initialRoute: "/",
        routes: {
          "/": (ctx) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return HomeScreen(
                    uid: state.uid,
                  );
                } else {
                  return SplashScreen();
                }
              },
            );
          },
        },
      ),
    );
  }
}
