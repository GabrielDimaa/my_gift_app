import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/helpers/params/friend_params.dart';
import '../helpers/errors/infra_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';
import 'constants/collection_reference.dart';
import 'i_friend_datasource.dart';
import 'i_user_account_datasource.dart';

class FirebaseFriendDataSource implements IFriendDataSource {
  final FirebaseFirestore firestore;
  final IUserAccountDataSource userDataSource;

  FirebaseFriendDataSource({required this.firestore, required this.userDataSource});

  @override
  Future<FriendModel> addFriend(FriendParams params) async {
    try {
      //Busca os dados do friend
      final UserModel friendModel = await userDataSource.getById(params.friendUserId);

      final Map<String, dynamic> json = {
        'friend_user_id': params.friendUserId,
        'processor_user_id': params.processorUserId,
        'users': [params.friendUserId, params.processorUserId],
        'accepted': false,
      };
      final doc = await firestore.collection(constantFriendsReference).add(json);

      final FriendModel model = FriendModel(
        id: doc.id,
        friendUserId: params.friendUserId,
        processorUserId: params.processorUserId,
        name: friendModel.name,
        email: friendModel.email,
        photo: friendModel.photo,
        accepted: false,
      );

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
  Future<void> undoFriend(String friendUserId, String processorUserId) async {
    try {
      final snapshotUser = await firestore.collection(constantFriendsReference).where('friend_user_id', isEqualTo: friendUserId).where('processor_user_id', isEqualTo: processorUserId).get();

      //Caso tenha linhas repetidas, remove.
      for (var doc in snapshotUser.docs) {
        await firestore.collection(constantFriendsReference).doc(doc.id).delete();
      }
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<List<FriendModel>> getFriends(String userId) async {
    try {
      List<FriendModel> models = [];

      final snapshotUser = await firestore.collection(constantFriendsReference).where('users', arrayContains: userId).get();

      if (snapshotUser.docs.isEmpty) return [];

      for (var doc in snapshotUser.docs) {
        var json = doc.data()..addAll({'id': doc.id});

        //Gabriel: Verifica se o userId é que fez a solicitação de amizade.
        bool isProcessor = json['processor_user_id'] == userId;

        //Condição para buscar valor diferente do userId.
        final UserModel friendModel = await userDataSource.getById(isProcessor ? json['friend_user_id'] : json['processor_user_id']);

        //Insere na lista de models.
        models.add(FriendModel(
          id: doc.id,
          friendUserId: isProcessor ? json['friend_user_id'] : userId,
          processorUserId: isProcessor ? userId : json['friend_user_id'],
          name: friendModel.name,
          email: friendModel.email,
          photo: friendModel.photo,
          accepted: json['accepted'] ?? false,
        ));
      }

      return models;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
