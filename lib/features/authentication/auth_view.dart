import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/authentication/cubit/auth_cubit.dart';
import 'package:shoes_ecommerce/features/authentication/cubit/auth_state.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/services/service_locator.dart';
import 'package:shoes_ecommerce/widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(locator(), context.read<CartCubit>()),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Button.outlined(
                  label: "Continue with google",
                  prefixIcon: Image.asset("assets/icons/google.jpg", height: 20, width: 20,),
                  onTap: () {
                    context.read<AuthCubit>().signIn(context);
                  },
                ),
              ),
              state.appStatus == AppStatus.loading
                  ? Container(
                      color: Colors.black12,
                      child: const LoadingWidget(),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
