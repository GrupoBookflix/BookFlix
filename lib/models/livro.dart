class Livro {
  String isbn;
  String nome;  
  String imageId;
  String? autor;
  String? ano;
  String? descricao;
  int? paginas;

  Livro({
    required this.isbn,
    required this.nome,
    required this.imageId,
    this.autor,
    this.ano,
    this.descricao,
    this.paginas,
    });
}