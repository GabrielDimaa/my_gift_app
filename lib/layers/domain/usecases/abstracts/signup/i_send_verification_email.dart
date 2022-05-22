abstract class ISendVerificationEmail {
  Future<void> send(String userId);
}