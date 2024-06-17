class Livro {
  String isbn;
  String nome;  
  String imageId;
  String genero;
  String? autor;
  String? ano;
  String? descricao;
  int? paginas;

  Livro({
    required this.isbn,
    required this.nome,
    required this.imageId,
    required this.genero,
    this.autor,
    this.ano,
    this.descricao,
    this.paginas,
    });

    String getIsbn() {
      return isbn;
    }
}