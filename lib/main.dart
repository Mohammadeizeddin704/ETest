import 'package:etest/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:etest/features/common/presentation/splash.dart';
import 'package:etest/features/top_up/presentation/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:etest/features/top_up/presentation/bloc/top_up/top_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => di.sl<AuthBloc>()..add(GetUserEvent())),
              BlocProvider(
                  create: (_) => di.sl<BeneficiaryBloc>()..add(const GetBeneficiariesEvent())),
              BlocProvider(
                  create: (_) => di.sl<TopUpBloc>()..add(const GetTransactionsEvent())),
            ],
            child: const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'E Mobile Recharge',
                home: SplashScreen()));
      },
      child: const SplashScreen(),
    );
  }
}
