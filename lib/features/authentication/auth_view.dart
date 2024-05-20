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

  final TextEditingController _userName = TextEditingController();

  @override
  void dispose() {
    _userName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(locator(), context.read<CartCubit>()),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Button.outlined(
                        label: "Continue with google",
                        prefixIcon: Image.asset("assets/icons/google.jpg", height: 20, width: 20,),
                        onTap: () {
                          context.read<AuthCubit>().signIn(context);
                        },
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Guest Login"),
                        ),
                        onTap: () {
                          context.read<AuthCubit>().signInAnonymously();
                        },
                      ),
                    ],
                  ),
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
