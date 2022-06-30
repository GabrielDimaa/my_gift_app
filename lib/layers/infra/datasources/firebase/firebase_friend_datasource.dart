import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/helpers/params/friend_params.dart';
import '../../helpers/connectivity_network.dart';
import '../../helpers/errors/infra_error.dart';
import '../../helpers/extensions/firebase_exception_extension.dart';
import '../../models/friends_model.dart';
import '../../models/user_model.dart';
import 'constants/collection_reference.dart';
import '../i_friend_datasource.dart';
import '../i_user_account_datasource.dart';

class FirebaseFriendDataSource implements IFriendDataSource {
  final FirebaseFirestore firestore;
  final IUserAccountDataSource userDataSource;

  FirebaseFriendDataSource({required this.firestore, required this.userDataSource});

  @override
  Future<void> addFriend(FriendParams params) async {
    try {
      await ConnectivityNetwork.hasInternet();

      var collUser = firestore.collection(constantUsersReference).doc(params.userId);
      await collUser.collection(constantFriendsReference).doc(params.friendUserId).set({});
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> undoFriend(FriendParams params) async {
    try {
      await ConnectivityNetwork.hasInternet();

      var collUser = firestore.collection(constantUsersReference).doc(params.userId);
      await collUser.collection(constantFriendsReference).doc(params.friendUserId).delete();
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<FriendsModel> getFriends(String userId) async {
    try {
      await ConnectivityNetwork.hasInternet();

      FriendsModel model = FriendsModel(friends: []);

      var collUser = firestore.collection(constantUsersReference).doc(userId);
      final snapshot = await collUser.collection(constantFriendsReference).get();

      if (snapshot.docs.isEmpty) return model;
      
      List<String> usersId = snapshot.docs.map((doc) => doc.id).toList();

      final snapshotUsers = await firestore.collection(constantUsersReference)
          .where(FieldPath.documentId, whereIn: usersId)
          .get();

      for (var doc in snapshotUsers.docs) {
        model.friends.add(UserModel.fromJson(doc.data()..addAll({'id': doc.id})));
      }

      model.friends.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return model;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<List<UserModel>> fetchSearchPersons(String name) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final snapshotUser = await firestore.collection(constantUsersReference)
          .where("searchName", arrayContains: name.toLowerCase())
          .get();

      List<UserModel> users = [];

      for (var doc in snapshotUser.docs) {
        var json = doc.data()..addAll({'id': doc.id});
        users.add(UserModel.fromJson(json));
      }

      return users;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<bool> verifyFriendship(FriendParams params) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final collUser = firestore.collection(constantUsersReference).doc(params.userId);
      final snapshot = await collUser.collection(constantFriendsReference).doc(params.friendUserId).get();
      return snapshot.exists;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
