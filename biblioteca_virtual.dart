import 'dart:io';

class Livro {
  final String id;
  final String titulo;
  final String autor;
  final int anoPublicacao;
  final String genero;
  final bool disponivel;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    required this.genero,
    this.disponivel = true,
  });

  @override
  String toString() {
    return 'ID: $id\nTítulo: $titulo\nAutor: $autor\nAno: $anoPublicacao\nGênero: $genero\nDisponível: ${disponivel ? "Sim" : "Não"}';
  }

  Livro copyWith({
    String? id,
    String? titulo,
    String? autor,
    int? anoPublicacao,
    String? genero,
    bool? disponivel,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      anoPublicacao: anoPublicacao ?? this.anoPublicacao,
      genero: genero ?? this.genero,
      disponivel: disponivel ?? this.disponivel,
    );
  }
}

class BibliotecaVirtual {
  final Map<String, Livro> _livros = {};

  bool cadastrarLivro(Livro livro) {
    if (_livros.containsKey(livro.id)) {
      print('Erro: Já existe um livro com o ID ${livro.id}');
      return false;
    }
    _livros[livro.id] = livro;
    print('Livro "${livro.titulo}" cadastrado com sucesso!');
    return true;
  }

  bool removerLivroPorId(String id) {
    final livroRemovido = _livros.remove(id);
    if (livroRemovido != null) {
      print('Livro "${livroRemovido.titulo}" removido com sucesso!');
      return true;
    }
    print('Erro: Livro com ID $id não encontrado');
    return false;
  }

  int removerLivrosPorTitulo(String titulo) {
    final idsParaRemover = _livros.entries
        .where((entry) => entry.value.titulo.toLowerCase() == titulo.toLowerCase())
        .map((entry) => entry.key)
        .toList();

    for (var id in idsParaRemover) {
      _livros.remove(id);
    }

    print('${idsParaRemover.length} livro(s) com título "$titulo" removido(s)');
    return idsParaRemover.length;
  }

  void listarLivros() {
    if (_livros.isEmpty) {
      print('A biblioteca está vazia.');
      return;
    }

    print('\n=== LIVROS NA BIBLIOTECA ===');
    _livros.values.forEach((livro) {
      print('---------------------------');
      print(livro);
    });
    print('---------------------------');
    print('Total: ${_livros.length} livro(s)\n');
  }

  List<Livro> buscarPorAutor(String autor) {
    return _livros.values
        .where((livro) => livro.autor.toLowerCase().contains(autor.toLowerCase()))
        .toList();
  }

  List<Livro> buscarPorGenero(String genero) {
    return _livros.values
        .where((livro) => livro.genero.toLowerCase().contains(genero.toLowerCase()))
        .toList();
  }

  bool emprestarLivro(String id) {
    final livro = _livros[id];
    if (livro == null) {
      print('Livro não encontrado!');
      return false;
    }
    if (!livro.disponivel) {
      print('Livro já emprestado!');
      return false;
    }
    _livros[id] = livro.copyWith(disponivel: false);
    print('Livro "${livro.titulo}" emprestado com sucesso!');
    return true;
  }

  bool devolverLivro(String id) {
    final livro = _livros[id];
    if (livro == null) {
      print('Livro não encontrado!');
      return false;
    }
    if (livro.disponivel) {
      print('Livro já está disponível!');
      return false;
    }
    _livros[id] = livro.copyWith(disponivel: true);
    print('Livro "${livro.titulo}" devolvido com sucesso!');
    return true;
  }

  void gerarRelatorio() {
    if (_livros.isEmpty) {
      print('A biblioteca está vazia.');
      return;
    }

    final totalLivros = _livros.length;
    final disponiveis = _livros.values.where((l) => l.disponivel).length;
    final emprestados = totalLivros - disponiveis;

    final generos = <String, int>{};
    for (var livro in _livros.values) {
      generos.update(livro.genero, (value) => value + 1, ifAbsent: () => 1);
    }

    print('\n=== RELATÓRIO DA BIBLIOTECA ===');
    print('Total de livros: $totalLivros');
    print('Disponíveis: $disponiveis');
    print('Emprestados: $emprestados');
    print('\nDistribuição por gênero:');
    generos.forEach((genero, quantidade) {
      print('$genero: $quantidade (${(quantidade / totalLivros * 100).toStringAsFixed(1)}%)');
    });
  }
}

void carregarLivrosIniciais(BibliotecaVirtual biblioteca) {
  final livros = [
    Livro(
      id: '001',
      titulo: 'Dom Casmurro',
      autor: 'Machado de Assis',
      anoPublicacao: 1899,
      genero: 'Romance',
    ),
    Livro(
      id: '002',
      titulo: '1984',
      autor: 'George Orwell',
      anoPublicacao: 1949,
      genero: 'Ficção Distópica',
    ),
  ];
  
  for (var livro in livros) {
    biblioteca.cadastrarLivro(livro);
  }
}

void _cadastrarLivroInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== CADASTRAR NOVO LIVRO ===');
  
  print('ID (deixe em branco para gerar automaticamente): ');
  final id = stdin.readLineSync() ?? 'L${biblioteca._livros.length + 1}';
  
  print('Título: ');
  final titulo = stdin.readLineSync() ?? 'Sem título';
  
  print('Autor: ');
  final autor = stdin.readLineSync() ?? 'Autor desconhecido';
  
  print('Ano de publicação: ');
  final ano = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
  
  print('Gênero: ');
  final genero = stdin.readLineSync() ?? 'Não especificado';

  final livro = Livro(
    id: id,
    titulo: titulo,
    autor: autor,
    anoPublicacao: ano,
    genero: genero,
  );
  
  biblioteca.cadastrarLivro(livro);
}

void _removerLivroPorIdInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== REMOVER LIVRO POR ID ===');
  biblioteca.listarLivros();
  print('Digite o ID do livro a ser removido: ');
  final id = stdin.readLineSync() ?? '';
  biblioteca.removerLivroPorId(id);
}

void _removerLivroPorTituloInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== REMOVER LIVRO POR TÍTULO ===');
  biblioteca.listarLivros();
  print('Digite o título do livro a ser removido: ');
  final titulo = stdin.readLineSync() ?? '';
  biblioteca.removerLivrosPorTitulo(titulo);
}

void _buscarPorAutorInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== BUSCAR POR AUTOR ===');
  print('Digite o nome do autor: ');
  final autor = stdin.readLineSync() ?? '';
  final resultados = biblioteca.buscarPorAutor(autor);
  
  if (resultados.isEmpty) {
    print('Nenhum livro encontrado para este autor.');
  } else {
    print('\n=== RESULTADOS ===');
    resultados.forEach(print);
  }
}

void _buscarPorGeneroInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== BUSCAR POR GÊNERO ===');
  print('Digite o gênero: ');
  final genero = stdin.readLineSync() ?? '';
  final resultados = biblioteca.buscarPorGenero(genero);
  
  if (resultados.isEmpty) {
    print('Nenhum livro encontrado neste gênero.');
  } else {
    print('\n=== RESULTADOS ===');
    resultados.forEach(print);
  }
}

void _emprestarLivroInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== EMPRESTAR LIVRO ===');
  biblioteca.listarLivros();
  print('Digite o ID do livro a ser emprestado: ');
  final id = stdin.readLineSync() ?? '';
  biblioteca.emprestarLivro(id);
}

void _devolverLivroInterativo(BibliotecaVirtual biblioteca) {
  print('\n=== DEVOLVER LIVRO ===');
  biblioteca.listarLivros();
  print('Digite o ID do livro a ser devolvido: ');
  final id = stdin.readLineSync() ?? '';
  biblioteca.devolverLivro(id);
}

void main() {
  final biblioteca = BibliotecaVirtual();
  carregarLivrosIniciais(biblioteca);

  while (true) {
    print('\n=== MENU PRINCIPAL ===');
    print('1. Cadastrar novo livro');
    print('2. Remover livro por ID');
    print('3. Remover livro por título');
    print('4. Listar todos os livros');
    print('5. Buscar livros por autor');
    print('6. Buscar livros por gênero');
    print('7. Emprestar livro');
    print('8. Devolver livro');
    print('9. Gerar relatório');
    print('0. Sair');
    print('Escolha uma opção: ');

    final opcao = stdin.readLineSync() ?? '';

    switch (opcao) {
      case '1':
        _cadastrarLivroInterativo(biblioteca);
        break;
      case '2':
        _removerLivroPorIdInterativo(biblioteca);
        break;
      case '3':
        _removerLivroPorTituloInterativo(biblioteca);
        break;
      case '4':
        biblioteca.listarLivros();
        break;
      case '5':
        _buscarPorAutorInterativo(biblioteca);
        break;
      case '6':
        _buscarPorGeneroInterativo(biblioteca);
        break;
      case '7':
        _emprestarLivroInterativo(biblioteca);
        break;
      case '8':
        _devolverLivroInterativo(biblioteca);
        break;
      case '9':
        biblioteca.gerarRelatorio();
        break;
      case '0':
        print('Saindo do sistema...');
        exit(0);
      default:
        print('Opção inválida! Tente novamente.');
    }
  }
}