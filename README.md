# MindFlash

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter](https://flutter.dev/docs/get-started/install) (versão mínima recomendada: 3.0.0)
- [Android Studio](https://developer.android.com/studio) ou outro ambiente de desenvolvimento compatível
- [Firebase CLI](https://firebase.google.com/docs/cli) (para configurar o Firebase)

---

## Passos para Executar o Projeto

### 1. Instalar o Flutter

Se você ainda não tem o Flutter instalado, siga as instruções no [site oficial](https://flutter.dev/docs/get-started/install). Após a instalação, verifique se o Flutter está funcionando corretamente:

```bash
$ flutter doctor
```

Certifique-se de que todas as dependências estão instaladas e configuradas.


### 1. Clonar o Repositório

No terminal, execute o seguinte comando para clonar o repositório:

```bash
$ git clone https://github.com/Brunno-Bocardo/app-flashcard.git
```


### 2. Navegar para o Diretório do Projeto

```bash
$ cd app-flashcard
$ code .
$ cd app_flashcard
```


### 3. Restaure o repositório

Execute os comandos abaixo para garantir que o ambiente esteja limpo e as dependências sejam instaladas corretamente:

```bash
$ flutter clean
$ flutter pub cache repair
$ flutter pub get
```

### 4. Instalar o Firebase CLI

- Tutorial seguido: https://www.youtube.com/watch?v=2VQEossWnxY

#### 4.1 Criar um Projeto no Firebase
- Acesse o [Firebase Console](https://console.firebase.google.com/).
- Crie um novo projeto ou selecione um existente.

#### 4.2 Habilitar Autenticação
- No Firebase Console, vá para a seção **Authentication**.
- Habilite o método de autenticação por **E-mail e Senha**.

#### 4.3 Instale o Firebase
Baixe e instale o Firebase CLI seguindo as instruções no [site oficial](https://firebase.google.com/docs/cli). Após a instalação, verifique se está funcionando corretamente:

```bash
$ flutter pub add firebase_core
$ flutter pub add firebase_auth
$ npm install -g firebase-tools
```

Confira a versão e se certifique de estar logado:

```bash
$ firebase --version
$ firebase login
```

### 4. Instalar o FlutterFire CLI

```bash
$ dart pub global activate flutterfire_cli
```

Ao rodar esse comando, ele vai retornar um caminho, vamos usá-lo para adiciona-lo ao PATH:
1. Vá em Painel de Controle > Sistema > Configurações Avançadas > Variáveis de Ambiente.
2. Em "Variáveis de usuário", encontre a variável Path e clique em Editar.
3. Adicione o caminho copiado.
4. Clique em OK em tudo.
5. Reinicie o terminal (feche e abra o terminal).

```bash
$ flutterfire --version
$ flutterfire configure
```

Siga as instruções no terminal para selecionar o projeto Firebase e as plataformas (Android, iOS, etc.). Isso irá gerar o arquivo `firebase_options.dart` na pasta `lib`.

