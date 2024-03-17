import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socialseed/domain/entities/user_entity.dart';

abstract class RemoteDataSource {
  // credential
  Future<void> signInUser(UserEntity user, BuildContext context);
  Future<void> signUpUser(UserEntity user, BuildContext context);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUsers(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);

  Future<String?> uploadImageToStorage(File? file, bool isPost, String child);
}
