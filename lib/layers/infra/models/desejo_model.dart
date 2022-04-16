import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:equatable/equatable.dart';

class DesejoModel extends Equatable {
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

  const DesejoModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'imagem': imagem,
      'link': link,
      'observacao': observacao,
      'faixa_preco_inicial': faixaPrecoInicial,
      'faixa_preco_final': faixaPrecoFinal,
      'data_criado': dataCriado.toIso8601String(),
      'arquivado': arquivado,
      'finalizado': finalizado,
    };
  }

  factory DesejoModel.fromJson(Map<String, dynamic> json) {
    return DesejoModel(
      id: json['id'],
      descricao: json['descricao'],
      imagem: json['imagem'],
      link: json['link'],
      observacao: json['observacao'],
      faixaPrecoInicial: json['faixa_preco_inicial'],
      faixaPrecoFinal: json['faixa_preco_final'],
      dataCriado: DateTime.parse(json['data_criado']),
      arquivado: json['arquivado'],
      finalizado: json['finalizado'],
    );
  }

  static bool validateJson(Map<String, dynamic>? json) {
    return json != null &&
        json.keys.toSet().containsAll([
          'id',
          'descricao',
          'faixa_preco_inicial',
          'faixa_preco_final',
          'data_criado',
          'arquivado',
          'finalizado',
        ]);
  }

  @override
  List<Object?> get props => [id, descricao, imagem, link, observacao, faixaPrecoInicial, faixaPrecoFinal, dataCriado, arquivado, finalizado];
}
