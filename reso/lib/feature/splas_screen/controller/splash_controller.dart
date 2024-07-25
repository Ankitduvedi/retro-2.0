import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reso/core/utils/utils.dart';
import 'package:reso/feature/splas_screen/repository/splash_repository.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(
      splashRepository: ref.read(splashRepositoryProvider), ref: ref);
});

class SplashController extends StateNotifier<bool> {
  final SplashRepository _splashRepository;
  final Ref _ref;

  SplashController(
      {required SplashRepository splashRepository, required Ref ref})
      : _splashRepository = splashRepository,
        _ref = ref,
        super(false);

  void intializeWhile(BuildContext context) async {
    state = true;
    final res = await _splashRepository.intializeWhile();
    res.fold((l) => Utils.snackBar(l.message, context), (r) {
      if (r == true) context.pushReplacement('/updateAppScreen');
    });
    state = false;
  }

  void checkCondition(BuildContext context) async {
    state = true;
    final res = await _splashRepository.checkCondition();
    res.fold(
      (l) {
        Utils.snackBar(l.message, context);
      },
      (r) {
        if (r == 1) {
          context.push('/onBoardingScreens');
          return;
        } else if (r == 2) {
          context.push('/');
          return;
        } else if (r == 3) {
          context.push('/welcomeScreen');
          return;
        }
      },
    );
    state = false;
  }
}
