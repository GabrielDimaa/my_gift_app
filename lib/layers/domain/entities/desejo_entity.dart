import 'package:equatable/equatable.dart';

class DesejoEntity extends Equatable {
  final String id;
  final String descricao;
  final String? imagem;
  final String? link;
  final String? observacao;

  final double faixaPrecoInicial;
  final double faixaPrecoFinal;

  final DateTime dataCriado;

  final bool arquivado;
  final bool finalizado;

  const DesejoEntity({
    required this.id,
    required this.descricao,
    this.imagem,
    this.link,
    this.observacao,
    required this.faixaPrecoInicial,
    required this.faixaPrecoFinal,
    required this.dataCriado,
    required this.arquivado,
    required this.finalizado,
  });

  @override
  List<Object?> get props => [id, descricao, imagem, link, observacao, faixaPrecoInicial, faixaPrecoFinal, dataCriado, arquivado, finalizado];
}
