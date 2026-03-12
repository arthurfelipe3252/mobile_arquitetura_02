# Mobile Arquitetura 02

Projeto desenvolvido na disciplina de Mobile II com o objetivo de entender a arquitetura e divisões de responsabilidades.

## Sobre o Projeto

Aplicativo Flutter que consome a [FakeStore API](https://fakestoreapi.com/products) para listar produtos, exibindo imagem, título e preço de cada item. O foco do projeto é demonstrar a aplicação de **Clean Architecture** com o padrão **MVVM** em um cenário real de consumo de API.

## Tecnologias

- **Flutter** (SDK >=3.18.0)
- **Dart** (SDK >=3.11.1)
- **Dio** (v5.8.0) — cliente HTTP para requisições à API
- **ValueNotifier** — gerenciamento de estado nativo do Flutter

## Arquitetura

O projeto segue os princípios da **Clean Architecture**, organizado em camadas com responsabilidades bem definidas:

```
┌─────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                     │
│  ProductPage · ProductViewModel · ProductState      │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                DOMAIN LAYER                         │
│  Product (Entity) · ProductRepository (contrato)    │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                 DATA LAYER                          │
│  ProductRepositoryImpl · ProductModel               │
│  ProductRemoteDatasource · ProductCacheDatasource   │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                 CORE LAYER                          │
│  HttpClient (wrapper do Dio) · Failure              │
└─────────────────────────────────────────────────────┘
```

### Camadas

| Camada | Responsabilidade | Exemplo |
|--------|-----------------|---------|
| **Domain** | Entidades de negócio e contratos (interfaces) dos repositórios | `Product`, `ProductRepository` |
| **Data** | Implementação dos repositórios, datasources, cache e models (DTOs) | `ProductRepositoryImpl`, `ProductRemoteDatasource`, `ProductCacheDatasource`, `ProductModel` |
| **Presentation** | UI (Pages/Widgets), ViewModels e estado da tela | `ProductPage`, `ProductViewModel`, `ProductState` |
| **Core** | Infraestrutura compartilhada (rede, tratamento de erros) | `HttpClient`, `Failure` |

## Estrutura de Pastas

```
lib/
├── core/
│   ├── errors/
│   │   └── failure.dart
│   └── network/
│       └── http_client.dart
├── data/
│   ├── datasources/
│   │   ├── product_remote_datasource.dart
│   │   └── product_cache_datasource.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── product_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product.dart
│   └── repositories/
│       └── product_repository.dart
├── presentation/
│   ├── pages/
│   │   └── product_page.dart
│   └── viewmodels/
│       ├── product_viewmodel.dart
│       └── product_state.dart
└── main.dart
```

## Padrões Utilizados

- **Repository Pattern** — abstrai a origem dos dados, permitindo trocar a implementação sem afetar o domínio
- **MVVM** — ViewModel como intermediário entre a View e os dados, usando `ValueNotifier` + `ValueListenableBuilder`
- **Injeção de Dependência Manual** — todas as dependências são criadas e injetadas via construtor no `main.dart`
- **Separação Model/Entity** — `ProductModel` (DTO com `fromJson`) é mantido separado da entidade `Product` do domínio

## Como Executar

```bash
# Clonar o repositório
git clone <url-do-repositorio>

# Instalar dependências
flutter pub get

# Executar o app
flutter run
```

## Dependências

| Pacote | Versão | Finalidade |
|--------|--------|------------|
| dio | ^5.8.0+1 | Cliente HTTP para consumo de APIs |
| cupertino_icons | ^1.0.8 | Ícones no estilo iOS |
| flutter_lints | ^6.0.0 | Regras de lint e qualidade de código |

## Perguntas

**1. Em qual camada foi implementado o cache e por quê?**

O cache foi implementado na camada Data, no arquivo `ProductCacheDatasource`. Fiz isso porque o cache é uma forma de acessar dados, igual a API remota, então faz sentido ele ficar junto com os outros datasources. Dessa forma o domínio não precisa saber se o dado veio da API ou do cache, quem decide isso é o repositório.

**2. Por que o ViewModel não realiza chamadas HTTP diretamente?**

Porque o ViewModel faz parte da camada de apresentação, e o papel dele é só cuidar do estado da tela. Se ele fizesse chamadas HTTP direto, ia misturar responsabilidades e ficar tudo acoplado. Qualquer mudança na API ia obrigar a mexer no ViewModel também. Deixando o HTTP nos datasources, cada parte cuida do seu.

**3. O que aconteceria se a interface acessasse diretamente o datasource?**

A tela ia ter que lidar com JSON, URLs e respostas HTTP, coisa que não é responsabilidade dela. Se a API mudasse um campo, ia ter que ir lá na tela consertar. Também não teria como ter o estado de loading ou de erro de forma organizada, e o fallback pro cache não funcionaria, porque a tela não saberia quando usar um ou outro.

**4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?**

Seria bem simples. Bastaria criar um novo datasource que acessa o banco local e trocar ele dentro do `ProductRepositoryImpl`. O contrato `ProductRepository` no domínio não muda, o ViewModel não muda e a tela não muda. É só trocar a implementação por baixo que tudo continua funcionando, porque as camadas de cima dependem da abstração e não da implementação.