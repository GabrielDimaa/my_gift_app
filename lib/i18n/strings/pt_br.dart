import '../translation.dart';

class PtBr implements Translation {
  //region General
  @override
  String get login => "Login";

  @override
  String get loginWithGoogle => "Entrar com o Google";

  @override
  String get signupWithGoogle => "Cadastrar-se com o Google";

  @override
  String get loginOu => "ou";

  @override
  String get email => "Email";

  @override
  String get emailHint => "Digite seu email";

  @override
  String get password => "Senha";

  @override
  String get passwordHint => "Digite sua senha";

  @override
  String get confirmPassword => "Confirmar senha";

  @override
  String get confirmPasswordHint => "Confirme sua senha";

  @override
  String get name => "Nome";

  @override
  String get nameHint => "Digite seu nome completo";

  @override
  String get photo => "Foto";

  @override
  String get addPhotoProfile => "Adicionar foto de perfil";

  @override
  String get enter => "Entrar";

  @override
  String get advance => "Avançar";

  @override
  String get doNotHaveAccount => "Não tem uma conta?";

  @override
  String get alreadyHaveAccount => "Já possui uma conta?";

  @override
  String get register => "Cadastrar-se";

  @override
  String get makeLogin => "Fazer login";

  @override
  String get createAccount => "Criar conta";
  //endregion

  //region Validation
  @override
  String get requiredField => "Campo obrigatório!";

  @override
  String get emailInvalidField => "Email inválido!";

  @override
  String get phoneInvalidField => "Número inválido!";

  @override
  String get shortPasswordField => "Senha deve conter pelo menos 8 caracteres!";

  @override
  String get passwordsNotMatchField => "As senhas não coincidem!";
  //endregion

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
  String get invalidDataError => "Dados inválidos.";

  @override
  String get withoutPermissionError => "Sem permissão.";

  @override
  String get nameTagEmptyError => "Nome da tag precisa ser informado.";

  @override
  String get colorTagEmptyError => "Cor da tag precisa ser informada.";

  @override
  String get wishlistUninformedError => "Lista de desejos não informada.";

  @override
  String get emailInUseError => "Email já foi cadastrado.";

  @override
  String get emailNotVerifiedError => "Email não verificado.";

  @override
  String get emailInvalidError => "Email inválido.";

  @override
  String get emailNotInformedError => "Email não informado.";

  @override
  String get passwordError => "Senha inválida.";

  @override
  String get passwordNotInformedError => "Senha não informada.";

  @override
  String get nameNotInformedError => "Nome não informado.";

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
  String get sendVerificationEmailError => "Não foi possível enviar email de verificação. Tente novamente.";

  @override
  String get checkEmailVerifiedError => "Não foi possível averiguar a confirmação de email. Tente novamente.";

  @override
  String get loginNotFoundError => "Email ou senha estão incorretos.";

  @override
  String get actionCodeError => "Código de ação expirou ou já foi usado.";

  @override
  String get getError => "Não foi possível concluir a busca.";

  @override
  String get saveError => "Houve um erro ao salvar.";

  @override
  String get deleteError => "Não foi possível excluir. Tente novamente.";

  @override
  String get uploadImageError => "Não foi possível salvar a imagem. Tente novamente.";

  @override
  String get deleteImageError => "Não foi possível remover a imagem. Tente novamente.";
  //endregion
}
