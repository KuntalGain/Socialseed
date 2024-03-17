import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socialseed/data/data_source/remote_datasource.dart';
import 'package:socialseed/domain/entities/user_entity.dart';
import 'package:socialseed/domain/repos/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final RemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async =>
      remoteDataSource.createUser(user);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUsers(String uid) =>
      remoteDataSource.getSingleUsers(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInUser(UserEntity user, BuildContext ctx) async =>
      remoteDataSource.signInUser(user, ctx);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user, BuildContext ctx) async =>
      remoteDataSource.signUpUser(user, ctx);

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<String?> uploadImageToStorage(File? file, bool isPost, String child) =>
      remoteDataSource.uploadImageToStorage(file, isPost, child);
}
