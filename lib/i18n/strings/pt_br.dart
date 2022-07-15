import '../translation.dart';

class PtBr implements Translation {
  @override
  String get locale => "pt_BR";

  @override
  String get symbol => "R\$";

  //region General
  @override
  String get login => "Login";

  @override
  String get loginWithGoogle => "Entrar com o Google";

  @override
  String get signupWithGoogle => "Cadastrando-se com o Google";

  @override
  String get loginOu => "ou";

  @override
  String get email => "Email";

  @override
  String get emailHint => "Digite seu email";

  @override
  String get confirmEmail => "Confirmar Email";

  @override
  String get explicationConfirmEmail => "Enviamos uma confirmação de email para o seu endereço. Localize-o na sua caixa de entrada e siga o procedimento.";

  @override
  String get explicationConfirmedEmail => "Caso já tenha confirmado, conclua o cadastro.";

  @override
  String get resendEmail => "Reenviar email";

  @override
  String get resent => "Reenviado";

  @override
  String get seconds => "segundo(s)";

  @override
  String get back => "Voltar";

  @override
  String get clear => "Limpar";

  @override
  String get completingRegistration => "Concluindo cadastro";

  @override
  String get signingUp => "Cadastrando-se";

  @override
  String get signingUpWithGoogle => "Cadastrando-se com Google";

  @override
  String get loggingIn => "Fazendo login";

  @override
  String get loggingInWithGoogle => "Fazendo login com Google";

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
  String get photoProfile => "Foto de perfil";

  @override
  String get removePhoto => "Remover foto";

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
  String get completeAccount => "Concluir cadastro";

  @override
  String get gallery => "Galeria";

  @override
  String get camera => "Câmera";

  @override
  String get close => "Fechar";

  @override
  String get wishlists => "Listas de Desejos";

  @override
  String get editList => "Editar Lista";

  @override
  String get newList => "Nova Lista";

  @override
  String get notFoundWishlists => "Nenhuma lista de desejos encontrada.";

  @override
  String get noneWishlists => "Nenhuma lista adicionada neste perfil.";

  @override
  String get notFoundWishes => "Nenhum desejo encontrado.";

  @override
  String get noneWishes => "Nenhum desejo adicionado.";

  @override
  String get createWishlist => "Criar lista de desejos";

  @override
  String get wishlist => "Lista de Desejos";

  @override
  String get labelWishlist => "Nome da lista";

  @override
  String get hintWishlist => "Digite o nome da lista";

  @override
  String get labelTag => "Nome";

  @override
  String get hintTag => "Digite o nome da tag";

  @override
  String get save => "Salvar";

  @override
  String get tag => "Tag";

  @override
  String get tags => "Tags";

  @override
  String get addTag => "Add";

  @override
  String get wishes => "Desejos";

  @override
  String get wish => "Desejo";

  @override
  String get addWishes => "Adicionar desejos";

  @override
  String get seeWishes => "Ver desejos";

  @override
  String get tagNormal => "Normal";

  @override
  String get createTag => "Criar tag";

  @override
  String get editTag => "Editar tag";

  @override
  String get colorTag => "Cor";

  @override
  String get savingTag => "Salvando tag";

  @override
  String get savingWishlist => "Salvando lista de desejos";

  @override
  String get deletingWishlist => "Excluindo lista de desejos";

  @override
  String get noneWishSelected => "Nenhum desejo selecionado";

  @override
  String get wishSelected => "Desejo selecionado";

  @override
  String get wishesSelected => "Desejos selecionados";

  @override
  String get cancel => "Cancelar";

  @override
  String get confirm => "Confirmar";

  @override
  String get titleNoneWish => "Nenhum desejo encontrado";

  @override
  String get messageNoneWish => "Deseja salvar a lista sem nenhum desejo adicionado?";

  @override
  String get newWish => "Novo Desejo";

  @override
  String get editWish => "Editar Desejo";

  @override
  String get image => "Imagem";

  @override
  String get labelDescription => "Descrição";

  @override
  String get hintDescriptionWish => "Digite a descrição do desejo";

  @override
  String get labelLinkWish => "Link";

  @override
  String get hintLinkWish => "Insira o Link do site";

  @override
  String get labelPriceRangeWish => "Faixa de preço";

  @override
  String get labelNoteWish => "Observação";

  @override
  String get hintNoteWish => "Digite a observação";

  @override
  String get greaterThan => "Maior que";

  @override
  String get savingWish => "Salvando desejo";

  @override
  String get addImage => "Adicionar imagem";

  @override
  String get imageWish => "Image do desejo";

  @override
  String get opening => "Abrindo";

  @override
  String get removeImage => "Remover imagem";

  @override
  String get delete => "Excluir";

  @override
  String get edit => "Editar";

  @override
  String get confirmDeleteWish => "Deseja excluir permanentemente este desejo?";

  @override
  String get confirmDeleteWishlist => "Deseja excluir permanentemente esta lista de desejos?";

  @override
  String get confirmDeleteTag => "Deseja excluir permanentemente esta tag?";

  @override
  String get deletingWish => "Excluindo desejo";

  @override
  String get deletingTag => "Excluindo tag";

  @override
  String get linkSite => "Link do site";

  @override
  String get copyLink => "Copiar link";

  @override
  String get copiedLink => "Copiado para área de transferência.";

  @override
  String get gotToLink => "Ir para o site";

  @override
  String get messageConfirmGoToLink => "Deseja sair do aplicativo e ir para o site?";

  @override
  String get dashboard => "Dashboard";

  @override
  String get friends => "Amigos";

  @override
  String get archive => "Arquivados";

  @override
  String get config => "Configurações";

  @override
  String get hello => "Olá";

  @override
  String get logout => "Sair";

  @override
  String get editMyData => "Editar meus dados";

  @override
  String get editData => "Editar dados";

  @override
  String get changePassword => "Alterar senha";

  @override
  String get theme => "Tema";

  @override
  String get goingOut => "Saindo";

  @override
  String get confirmLogout => "Deseja sair?\nSeus login não será lembrado ao abrir o aplicativo.";

  @override
  String get searchFriend => "Buscar";

  @override
  String get search => "Pesquise";

  @override
  String get findPeople => "Encontre pessoas";

  @override
  String get messageSearchDelegate => "Pesquise outras pessoas para adicioná-las aos amigos.";

  @override
  String get messageNotFoundSearchDelegate => "Nenhum resultado encontrado para";

  @override
  String get noneFriendAdd => "Nenhum amigo adicionado.\nPara você visualizar a lista de desejos dos seus amigos, basta adicioná-los.";

  @override
  String get noneTagRegister => "Nenhuma tag cadastrada.";

  @override
  String get notFoundFriend => "Nenhum amigo encontrado";

  @override
  String get undoFriend => "Desfazer amizade";

  @override
  String get undo => "Desfazer";

  @override
  String get add => "Adicionar";

  @override
  String get addFriend => "Adicionar aos amigos";

  @override
  String get addingFriend => "Adicionando aos amigos";

  @override
  String get undoFriendConfirm => "Tem certeza que deseja desfazer a amizade?";

  @override
  String get undoingFriend => "Desfazendo amizade";

  @override
  String get profile => "Perfil";

  @override
  String get exit => "Sair";

  @override
  String get exitMessage => "Você deseja realmente sair?";

  @override
  String get savingData => "Salvando dados";

  @override
  String get alterPhoto => "Alterar foto";

  @override
  String get resetPassword => "Redefinir senha";

  @override
  String get explicationSendResetPassword => "Redefinição de senha enviado para seu endereço de email.";

  @override
  String get explicationCodeResetPassword => "Insira o código enviado para seu endereço de email.";

  @override
  String get explicationEmailResetPassword => "Insira o endereço de email para enviarmos a redefinição de senha.";

  @override
  String get send => "Enviar";

  @override
  String get sent => "Enviado";

  @override
  String get sending => "Enviando";

  @override
  String get resendCode => "Reenviar código";

  @override
  String get discard => "Descartar";

  @override
  String get discardChangesMessage => "Tem certeza que deseja descartar as alterações?";
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

  @override
  String get noImageSelected => "Nenhuma imagem selecionada!";
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
  String get nameColorTagError => "Nome ou cor da tag não informada.";

  @override
  String get nameTagNotInformedError => "Nome da tag não informada.";

  @override
  String get colorTagNotInformedError => "Cor da tag não informada.";

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
  String get codeNotInformedError => "Código não informado";

  @override
  String get shortPasswordError => "Senha muito curta.";

  @override
  String get permissionDeniedError => "Sem permissão.";

  @override
  String get withoutPermissionCameraError => "Sem permissão para acessar a câmera.";

  @override
  String get withoutPermissionGalleryError => "Sem permissão para acessar a galeria.";

  @override
  String get unauthenticatedError => "Credenciais inválidas.";

  @override
  String get unavailableError => "O serviço está indisponível no momento.";

  @override
  String get resourceExhaustedError => "Não foi possível concluir a operação. Verifique se o seu dispositivo possui espaço no armazenamento.";

  @override
  String get dataLoadError => "Houve um erro ao carregar os dados.";

  @override
  String get loginError => "Não foi possível fazer login. Tente novamente.";

  @override
  String get logoutError => "Não foi possível fazer logout. Tente novamente.";

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

  @override
  String get imagePickerError => "Não foi possível selecionar a imagem. Tente novamente.";

  @override
  String get imageCropperError => "Não foi possível cortar a imagem.";

  @override
  String get descriptionNotInformed => "Descrição não informada.";

  @override
  String get tagNotInformed => "Tag não selecionada.";

  @override
  String get wishlistLinked => "Lista de desejos não vinculada.";

  @override
  String get priceNotInformed => "Faixa de preço não informada.";

  @override
  String get priceMinMaxError => "Preço mínimo maior que o máximo.";

  @override
  String get addFriendError => "Não foi possível adicionar amigo. Tente novamente.";

  @override
  String get getFriendError => "Não foi possível buscar amigo.";

  @override
  String get fetchFriendError => "Não foi possível carregar amigos.";

  @override
  String get undoFriendError => "Não foi possível adicionar amigo. Tente novamente.";

  @override
  String get getProfileError => "Não foi possível carregar os dados do perfil.";

  @override
  String get noAccessError => "Você não tem acesso para editar.";

  @override
  String get sendCodeError => "Houve um erro ao enviar código para o email.";

  @override
  String get tagUsedByWishlistError => "Tag está sendo utilizada por uma ou mais listas de desejos.";

  @override
  String get wishlistNotFoundError => "Lista de desejos não encontrada.";

  @override
  String get wishNotFoundError => "Desejo não encontrado";

  @override
  String get tagNotFoundError => "Tag não encontrada.";
  //endregion
}
