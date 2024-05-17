import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_ecommerce/constants/app_status.dart';
import 'package:shoes_ecommerce/features/cart/cubit/cart_cubit.dart';
import 'package:shoes_ecommerce/services/navigation_service/navigation_service.dart';
import 'package:shoes_ecommerce/services/navigation_service/routing_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/service_locator.dart';
import '../../../utils/toast_message.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthService authService;
  CartCubit cartCubit;
  AuthCubit(this.authService, this.cartCubit): super(const AuthState());

  final _db = FirebaseFirestore.instance;

  signIn(BuildContext context) async {
    emit(state.copyWith(appStatus: AppStatus.loading));
    try {
      UserCredential? userCredential = await authService.signInWithGoogle();
      await _createUser(userCredential);
      if(userCredential != null) {
        emit(state.copyWith(appStatus: AppStatus.success));
        cartCubit.fetchCart(userCredential.user?.uid);
        locator<NavigationService>().pushReplacement(discoverView);
      } else {
        emit(state.copyWith(appStatus: AppStatus.failure));
      }
    } catch(e) {
      emit(state.copyWith(appStatus: AppStatus.failure));
      toastMessage(message: "$e");
    }
  }

  _createUser(UserCredential? userCredential) async {
    try {
      CollectionReference users = _db.collection('users');

      QuerySnapshot<dynamic> response = await users.where("userId", isEqualTo: userCredential?.user?.uid).get();
      if (response.docs.isEmpty) {
        users
            .doc(userCredential?.user?.uid)
            .set({
              'userId': userCredential?.user?.uid,
              'name': userCredential?.user?.displayName,
              'email': userCredential?.user?.email,
            })
            .then((value) => debugPrint("User added successfully!"))
            .catchError(
              (error) => debugPrint("Failed to add user: $error"),
            );
      }
    } catch (e) {
      rethrow;
    }

  }
}