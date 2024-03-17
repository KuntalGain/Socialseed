import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialseed/data/data_source/remote_datasource.dart';
import 'package:socialseed/data/models/user_model.dart';
import 'package:socialseed/domain/entities/user_entity.dart';
import 'package:socialseed/utils/constants/color_const.dart';
import 'package:socialseed/utils/constants/firebase_const.dart';
import 'package:uuid/uuid.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  RemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((newDoc) {
      final newUser = UserModel(
        uid: uid,
        username: user.username,
        fullname: user.fullname,
        email: user.email,
        bio: user.bio,
        imageUrl: user.imageUrl,
        friends: user.friends,
        milestones: user.milestones,
        likedPages: user.likedPages,
        posts: user.posts,
        joinedDate: user.joinedDate,
        isVerified: user.isVerified,
        badges: user.badges,
        followerCount: user.followerCount,
        followingCount: user.followingCount,
        stories: user.stories,
      ).toJson();

      if (!newDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((err) {
      print(err.toString());
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUsers(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);

    return userCollection.snapshots().map(
        (query) => query.docs.map((e) => UserModel.fromSnapShot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user, BuildContext context) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: user.email!,
          password: user.password!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login Successfull',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'User Not Exist',
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Password Is Wrong , Try Again',
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Something Went Wrong',
        )));
      }
    }
  }

  @override
  Future<void> signOut() async => await firebaseAuth.signOut();

  @override
  Future<void> signUpUser(UserEntity user, BuildContext context) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth
            .createUserWithEmailAndPassword(
          email: user.email!,
          password: user.password!,
        )
            .then((value) async {
          if (value.user?.uid != null) {
            await createUser(user);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Account Creation Successfull',
              ),
              backgroundColor: Colors.green,
            ),
          );
        });

        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'User Already Exists',
          ),
          backgroundColor: AppColor.redColor,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Something Went wrong (${e.code})',
          ),
          backgroundColor: AppColor.redColor,
        ));
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    Map<String, dynamic> userInformation = Map();

    if (user.username != "" && user.username != null)
      userInformation['username'] = user.username;
    if (user.fullname != "" && user.fullname != null)
      userInformation['fullname'] = user.fullname;
    if (user.email != "" && user.email != null)
      userInformation['email'] = user.email;
    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;
    if (user.imageUrl != "" && user.imageUrl != null)
      userInformation['imageUrl'] = user.imageUrl;
    if (user.friends != "" && user.friends != null)
      userInformation['friends'] = user.friends;
    if (user.milestones != "" && user.milestones != null)
      userInformation['milestones'] = user.milestones;
    if (user.likedPages != "" && user.likedPages != null)
      userInformation['likedPages'] = user.likedPages;
    if (user.posts != "" && user.posts != null)
      userInformation['posts'] = user.posts;
    if (user.username != "" && user.username != null)
      userInformation['username'] = user.username;
    if (user.followerCount != "" && user.followerCount != null)
      userInformation['followerCount'] = user.followerCount;
    if (user.followingCount != "" && user.followingCount != null)
      userInformation['followingCount'] = user.followingCount;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String?> uploadImageToStorage(
      File? file, bool isPost, String child) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(child)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);

      final uploadTask = ref.putFile(file!);

      final imageUrl =
          (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

      return await imageUrl;
    }
  }
}
