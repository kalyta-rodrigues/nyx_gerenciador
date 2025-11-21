# NYX TAREFAS

NYX é um aplicativo Flutter simples e funcional para gerenciamento de tarefas diárias, organizado por data em um calendário interativo.
Ele inclui login, cadastro, calendário, criação de tarefas, prioridade e busca.

## 📱 Funcionalidades principais

🔐 1. Login

Permite que o usuário entre usando e-mail e senha.

Dados de login são cadastrados localmente (não possui banco de dados ainda).

Valida preenchimento dos campos.

Exibe mensagens de erro usando SnackBar.

Após login válido, redireciona para o Calendário.

📝 2. Cadastro

O usuário pode criar uma nova conta informando:

Nome completo

E-mail

Senha

Confirmação de senha

Validações existentes:

✔ Preenchimento obrigatório
✔ Senha com mínimo 6 caracteres
✔ Senhas devem coincidir

Após cadastrar, retorna os dados para a tela de Login.

📅 3. Calendário

Usa o pacote TableCalendar para exibir um calendário estilizado.

Funcionalidades:

Seleção de data

Alterar visualização (mês → semana)

Destaque no dia atual

Interface tematizada com fundo personalizado

Botão "Ver Tarefas do Dia" que leva à lista de tarefas da data escolhida

✔ 4. Gerenciamento de Tarefas

Cada dia possui sua própria lista de tarefas.

Funcionalidades incluídas:

➕ Adicionar tarefa

Usuário digita uma nova tarefa

Seleciona prioridade:

🔴 Alta

🟡 Média

🔵 Baixa

Inserção animada na lista (AnimatedList)

🔍 Barra de pesquisa

Filtra tarefas em tempo real pelo texto.

⭐ Prioridade visual

Cada tarefa possui uma borda/colorização de acordo com sua prioridade.

🔄 Marcar como concluída

Ao clicar no ícone de "check", a tarefa é marcada como concluída.

Automaticamente muda de posição na lista (concluídas vão para o final).

🗑 Excluir tarefa

Tarefas concluídas podem ser deletadas.

Remoção animada na lista.

### 🧱 Estrutura das Páginas

/pages
├── login_page.dart
├── cadastro_page.dart
├── calendario_page.dart
└── tarefa_page.dart

🔧 main.dart

Configura rotas

Define idioma padrão para pt-BR

Remove o banner de debug

Controla navegação entre as telas

#### 🎨 Destaques do Design

Tema escuro elegante com fundo personalizado (plano_fundo4.png)

Componentes arredondados e modernos

Textos claros para boa leitura

Botões com cor temática #AF7812

Animações suaves ao adicionar/excluir itens

#### 🚀 Tecnologias Usadas

Flutter

Dart

##### 📂 Como rodar o projeto

Certifique-se de ter o Flutter instalado:

flutter --version

Instale pacotes:

flutter pub get

Rode o app:

flutter run
