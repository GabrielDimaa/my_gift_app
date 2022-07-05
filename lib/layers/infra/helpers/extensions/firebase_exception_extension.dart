import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../exceptions/errors.dart';
import '../../../../i18n/resources.dart';

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
  Error get getInfraError {
    switch(code.toUpperCase()) {
      case "ABORTED":
      case "FAILED_PRECONDITION": return StandardError(R.string.abortedError);
      case "ALREADY_EXISTS": return StandardError(R.string.alreadyExistsError);
      case "CANCELLED": return StandardError(R.string.cancelledError);
      case "INTERNAL": return StandardError(R.string.internalError);
      case "INVALID_ARGUMENT": return StandardError(R.string.invalidArgumentError);
      case "NOT_FOUND": return StandardError(R.string.actionCodeError);
      case "PERMISSION_DENIED": return StandardError(R.string.permissionDeniedError);
      case "RESOURCE_EXHAUSTED": return StandardError(R.string.resourceExhaustedError);
      case "UNAUTHENTICATED": return StandardError(R.string.unauthenticatedError);
      case "UNAVAILABLE": return StandardError(R.string.unavailableError);
      case "DEADLINE_EXCEEDED":
      case "DATA_LOSS":
      case "OUT_OF_RANGE":
      case "UNIMPLEMENTED":
      default: return UnexpectedError();
    }
  }
}
