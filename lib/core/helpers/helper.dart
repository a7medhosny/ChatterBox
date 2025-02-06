String generateChatId(String uid1, String uid2) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatId = uids.fold("", (id, uid) => "$id$uid");
  return chatId;
}
