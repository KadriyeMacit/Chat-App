import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_chat_app/models/conversation.dart';
import 'package:my_chat_app/models/profile.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Conversation>> getConversations(String userId) {
    var ref = _firestore.collection('conversations').where('members', arrayContains: userId);

    var convsersationsStream = ref.snapshots();

    var profilesStream = getContacs().asStream();

    return Rx.combineLatest2(
      convsersationsStream,
      profilesStream,
      (QuerySnapshot conversations, List<Profile> profiles) => conversations.docs.map(
        (snapshot) {
          List<String> members = List.from(snapshot['members']);

          var profile = profiles.firstWhere(
            (element) => element.id == members.firstWhere((member) => member != userId),
          );

          return Conversation.fromSnapshot(snapshot, profile);
        },
      ).toList(),
    );
  }

  Future<List<Profile>> getContacs() async {
    var ref = _firestore.collection("profile");

    var documents = await ref.get();

    return documents.docs.map((snapshot) => Profile.fromSnapshot(snapshot)).toList();
  }

  Future<Conversation> startConversation(User user, Profile profile) async {
    var ref = _firestore.collection('conversations');

    var documentRef = await ref.add({
      'displayMessage': '',
      'members': [user.uid, profile.id]
    });

    return Conversation(
      id: documentRef.id,
      displayMassage: '',
      name: profile.userName,
      profileImage: profile.image,
    );
  }

  Future<Conversation> getConversation(String conversationId, String userId) async {
    var profileSnapshot = await _firestore.collection('profile').doc(userId).get();
    var profile = Profile.fromSnapshot(profileSnapshot);
    return Conversation(id: conversationId, name: profile.userName, profileImage: profile.image, displayMassage: '');
  }
}
