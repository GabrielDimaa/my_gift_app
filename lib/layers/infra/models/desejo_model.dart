import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:equatable/equatable.dart';

class DesejoModel extends Equatable {
  final String id;
  final String descricao;
  final String imagem;
  final String link;
  final String observacao;

  final double faixaPrecoInicial;
  final double faixaPrecoFinal;

  final DateTime dataCriado;

  final bool arquivado;
  final bool finalizado;

  const DesejoModel({
    required this.id,
    required this.descricao,
    required this.imagem,
    required this.link,
    required this.observacao,
    required this.faixaPrecoInicial,
    required this.faixaPrecoFinal,
    required this.dataCriado,
    required this.arquivado,
    required this.finalizado,
  });

  DesejoEntity toEntity() {
    return DesejoEntity(
      id: id,
      descricao: descricao,
      imagem: imagem,
      link: link,
      observacao: observacao,
      faixaPrecoInicial: faixaPrecoInicial,
      faixaPrecoFinal: faixaPrecoFinal,
      dataCriado: dataCriado,
      arquivado: arquivado,
      finalizado: finalizado,
    );
  }

  @override
  List<Object?> get props => [id, descricao, imagem, link, observacao, faixaPrecoInicial, faixaPrecoFinal, dataCriado, arquivado, finalizado];
}
