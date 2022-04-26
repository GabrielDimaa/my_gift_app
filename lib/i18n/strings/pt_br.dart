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
  String get emailNotVerifiedError => "Email não verificado.";

  @override
  String get emailInvalidError => "Email inválido.";

  @override
  String get passwordError => "Senha inválida.";

  @override
  String get shortPasswordError => "Senha muito curta.";

  @override
  String get permissionDeniedError => "Sem permissão.";

  @override
  String get unauthenticatedError => "Credenciais inválidas.";

  @override
  String get unavailableError => "O serviço está indisponível no momento.";

  @override
  String get resourceExhaustedError => "Não foi possível concluir a operação. Verifique se o seu dispositivo possui espaço no armazenamento.";

  @override
  String get loginError => "Não foi possível fazer login. Tente novamente.";

  @override
  String get signUpError => "Não foi possível criar sua conta de usuário. Tente novamente.";

  @override
  String get loginNotFoundError => "Email ou senha estão incorretos.";

  @override
  String get actionCodeError => "Código de ação expirou ou já foi usado.";

  @override
  String get getError => "Não foi possível concluir a busca.";

  @override
  String get saveError => "Não foi possível salvar. Tente novamente";

  @override
  String get deleteError => "Não foi possível excluir. Tente novamente";
  //endregion
}
