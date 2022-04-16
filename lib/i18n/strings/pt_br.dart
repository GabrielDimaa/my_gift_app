import 'package:desejando_app/i18n/translation.dart';

class PtBr implements Translation {
  //region Error
  @override
  String get unexpectedError => "Aconteceu algo inesperado.";

  @override
  String get connectionError => "Sem conexão com a internet.";

  @override
  String get alreadyExistsError => "Dado já foi cadastrado no aplicativo.";

  @override
  String get abortedError => "Houve um problema interno. A operação foi cancelada.";

  @override
  String get cancelledError => "Operação cancelada.";

  @override
  String get internalError => "Houve um problema interno. Tente novamente.";

  @override
  String get invalidArgumentError => "Valor inválido.";

  @override
  String get notFoundError => "Nenhum resultado encontrado.";

  @override
  String get emailInUseError => "Email já foi cadastrado.";

  @override
  String get emailInvalidError => "Email inválido.";

  @override
  String get passwordError => "Senha inválida.";

  @override
  String get permissionDeniedError => "Sem permissão.";

  @override
  String get unauthenticatedError => "Credenciais inválidas.";

  @override
  String get unavailableError => "O serviço está indisponível no momento.";

  @override
  String get resourceExhaustedError => "Não foi possível concluir a operação. Verifique se o seu dispositivo possui espaço no armazenamento.";
  //endregion
}
