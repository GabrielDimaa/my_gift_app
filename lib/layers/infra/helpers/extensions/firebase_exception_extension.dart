import 'package:cloud_firestore/cloud_firestore.dart';

import '../../errors/infra_error.dart';

/*
[ABORTED] A operação foi abortada, normalmente devido a um problema de simultaneidade, como abortos de transações, etc.
[ALREADY_EXISTS] Algum documento que tentamos criar já existe.
[CANCELLED] A operação foi cancelada (normalmente pelo chamador).
[DATA_LOSS] Perda ou corrupção de dados irrecuperáveis.
[DEADLINE_EXCEEDED] O prazo expirou antes que a operação pudesse ser concluída.
[FAILED_PRECONDITION] A operação foi rejeitada porque o sistema não está em um estado necessário para a execução da operação.
[INTERNAL] Erros internos. Significa que alguns invariantes esperados pelo sistema subjacente foram quebrados.
[INVALID_ARGUMENT] O cliente especificou um argumento inválido.
[NOT_FOUND] Algum documento solicitado não foi encontrado.
[OUT_OF_RANGE] A operação foi tentada além do intervalo válido.
[PERMISSION_DENIED] O chamador não tem permissão para executar a operação especificada.
[RESOURCE_EXHAUSTED] Algum recurso foi esgotado, talvez uma cota por usuário, ou talvez todo o sistema de arquivos esteja sem espaço.
[UNAUTHENTICATED] A solicitação não possui credenciais de autenticação válidas para a operação.
[UNAVAILABLE] O serviço está indisponível no momento. Esta é provavelmente uma condição transitória e pode ser corrigida tentando novamente com um backoff.
[UNIMPLEMENTED] A operação não está implementada ou não é suportada/ativada.
[UNKNOWN] Erro desconhecido ou um erro de um domínio de erro diferente.

https://firebase.google.com/docs/reference/android/com/google/firebase/firestore/FirebaseFirestoreException.Code
 */

extension FirebaseExceptionExtension on FirebaseException {
  InfraError get getInfraError {
    switch(code.toUpperCase()) {
      case "ABORTED": return AbortedInfraError();
      case "ALREADY_EXISTS": return AlreadyExistsInfraError();
      case "CANCELLED": return CancelledInfraError();
      case "DATA_LOSS": return UnexpectedInfraError();
      case "DEADLINE_EXCEEDED": return UnexpectedInfraError();
      case "FAILED_PRECONDITION": return AbortedInfraError();
      case "INTERNAL": return InternalInfraError();
      case "INVALID_ARGUMENT": return InvalidArgumentInfraError();
      case "NOT_FOUND": return NotFoundInfraError();
      case "OUT_OF_RANGE": return UnexpectedInfraError();
      case "PERMISSION_DENIED": return PermissionDeniedInfraError();
      case "RESOURCE_EXHAUSTED": return ResourceExhaustedInfraError();
      case "UNAUTHENTICATED": return UnauthenticatedInfraError();
      case "UNAVAILABLE": return UnavailableInfraError();
      case "UNIMPLEMENTED": return UnexpectedInfraError();
      case "UNKNOWN": return UnexpectedInfraError();
      default: return UnexpectedInfraError();
    }
  }
}