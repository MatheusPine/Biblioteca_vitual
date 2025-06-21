Forma de uso: Execute o código no bash:  dart run biblioteca_virtual.dart 
Após executar o código vai aparecer as seguintes opções:


=== MENU PRINCIPAL ===
1. Cadastrar novo livro
2. Remover livro por ID
3. Remover livro por título
4. Listar todos os livros
5. Buscar livros por autor
6. Buscar livros por gênero
7. Emprestar livro
8. Devolver livro
9. Gerar relatório
0. Sair
Escolha uma opção:




Classe Livro
Representa um livro na biblioteca com seus atributos básicos e funcionalidades.

Atributos:
id (String): Identificador único do livro

titulo (String): Título da obra

autor (String): Autor do livro

anoPublicacao (int): Ano de publicação

genero (String): Gênero literário

disponivel (bool): Status de disponibilidade (default: true)

Métodos:
toString(): Retorna string formatada com todos os dados do livro

copyWith(): Cria uma cópia do livro permitindo alterar alguns atributos

Classe BibliotecaVirtual
Gerencia a coleção de livros e operações da biblioteca.

Métodos Principais:
Gerenciamento de Livros:

cadastrarLivro(): Adiciona novo livro à biblioteca

removerLivroPorId(): Remove livro pelo ID

removerLivrosPorTitulo(): Remove todos os livros com título correspondente

Busca e Listagem:

listarLivros(): Exibe todos os livros cadastrados

buscarPorAutor(): Retorna lista de livros por autor

buscarPorGenero(): Retorna lista de livros por gênero

Controle de Empréstimos:

emprestarLivro(): Marca livro como indisponível

devolverLivro(): Marca livro como disponível

Relatórios:

gerarRelatorio(): Exibe estatísticas da biblioteca

Funções Auxiliares
carregarLivrosIniciais(): Popula a biblioteca com livros de exemplo

Funções _*Interativo(): Lidam com entrada do usuário para cada operação






