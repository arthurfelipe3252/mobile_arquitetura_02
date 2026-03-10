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
┌──────────────────────────────────────────┐
│         PRESENTATION LAYER               │
│  ProductPage · ProductViewModel          │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│           DOMAIN LAYER                   │
│  Product (Entity) · ProductRepository    │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│            DATA LAYER                    │
│  ProductRepositoryImpl · ProductModel    │
│  ProductRemoteDatasource                 │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│            CORE LAYER                    │
│  HttpClient (wrapper do Dio)             │
└──────────────────────────────────────────┘
```

### Camadas

| Camada | Responsabilidade | Exemplo |
|--------|-----------------|---------|
| **Domain** | Entidades de negócio e contratos (interfaces) dos repositórios | `Product`, `ProductRepository` |
| **Data** | Implementação dos repositórios, datasources e models (DTOs) | `ProductRepositoryImpl`, `ProductRemoteDatasource`, `ProductModel` |
| **Presentation** | UI (Pages/Widgets) e ViewModels para gerenciamento de estado | `ProductPage`, `ProductViewModel` |
| **Core** | Infraestrutura compartilhada (rede, tratamento de erros) | `HttpClient` |

## Estrutura de Pastas

```
lib/
├── core/
│   ├── errors/
│   └── network/
│       └── http_client.dart
├── data/
│   ├── datasources/
│   │   └── product_remote_datasource.dart
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
│       └── product_viewmodel.dart
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