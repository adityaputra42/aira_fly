# PSS Mobile — Aira Fly

Flutter mobile application for the Passenger Service System (PSS). The app provides customer-facing airline services, including flight search, booking, ancillary selection, wallet, ticket management, check-in, notifications, and an AI-powered conversational booking assistant.

The application is built with Flutter and Dart. Its codebase is organized by feature and follows Clean Architecture boundaries (`data`, `domain`, and `presentation`) for the major business modules.

---

## Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Features](#features)
- [AI Booking Assistant](#ai-booking-assistant)
- [Backend Communication](#backend-communication)
- [Getting Started](#getting-started)
- [Useful Commands](#useful-commands)

---

## Overview

PSS Mobile is the customer-facing Flutter application in the PSS ecosystem. The application supports two ways to use the booking services:

1. **Screen-based experience** — customers use dedicated screens and forms to search flights, select fares, enter passenger details, manage bookings, and access other airline services.
2. **Conversational experience** — customers use the AI Assistant to express travel requirements in natural language or by voice. The assistant guides the customer through flight search, flight/fare selection, passenger submission, booking confirmation, and wallet payment.

Both experiences communicate with the PSS backend. The mobile application is responsible for presentation, user interaction, client-side validation, and API integration; authoritative booking and payment business rules belong to the backend.

The Flutter application title configured in `MaterialApp.router` is **Aira Fly**.

---

## Technology Stack

| Area | Package / Technology | Usage |
|---|---|---|
| Framework | Flutter | Cross-platform mobile application |
| Language | Dart | Application implementation |
| State management | `flutter_bloc`, `bloc`, `equatable` | BLoC/Cubit state and event handling |
| Dependency injection | `get_it` | Service locator and dependency registration |
| Navigation | `go_router` | Declarative routing and page transitions |
| HTTP client | `dio` | REST API communication and interceptors |
| Functional error handling | `fpdart` | `Either<Failure, T>` repository/use-case results |
| Local preferences | `shared_preferences` | Tokens and lightweight user/application preferences |
| Environment configuration | `envied`, `envied_generator` | Compile-time environment configuration |
| Speech recognition | `speech_to_text` | Voice input for the AI Assistant |
| Text-to-speech | `flutter_tts` | Spoken AI responses |
| Push notifications | `firebase_core`, `firebase_messaging` | Firebase initialization and push messaging |
| Local notifications | `flutter_local_notifications` | Displaying local notifications |
| Connectivity | `internet_connection_checker_plus` | Network connectivity checks |
| UI utilities | `cached_network_image`, `shimmer`, `animations`, `animate_do` | Image loading, loading placeholders, and UI animation |
| Barcode | `syncfusion_flutter_barcodes` | Barcode/boarding-pass related UI |
| Image selection | `image_picker` | Image selection |

The package versions and Dart SDK constraint are defined in [`pubspec.yaml`](pubspec.yaml).

> **Persistence note:** This project does not use Isar. Lightweight local values are stored with `shared_preferences`. The application does not define an Isar database layer.

---

## Architecture

The codebase follows Clean Architecture boundaries within feature-oriented modules.

```text
┌───────────────────────────────────────────────────────┐
│                    Presentation                       │
│                                                       │
│  Screens • Widgets • BLoC • Cubit • UI State          │
└──────────────────────────┬────────────────────────────┘
                           │
                           ▼
┌───────────────────────────────────────────────────────┐
│                       Domain                           │
│                                                       │
│  Entities • Repository Contracts • Use Cases • Rules  │
└──────────────────────────┬────────────────────────────┘
                           │
                           ▼
┌───────────────────────────────────────────────────────┐
│                        Data                             │
│                                                       │
│  Repository Implementations • Models • Data Sources   │
└──────────────────────────┬────────────────────────────┘
                           │
                ┌──────────┴──────────┐
                ▼                     ▼
        ┌───────────────┐     ┌────────────────┐
        │   Remote API  │     │ Local Prefs    │
        │      Dio      │     │ SharedPrefs    │
        └───────────────┘     └────────────────┘
```

### Layer responsibilities

#### Presentation

Contains screens, reusable feature widgets, and state-management components.

- BLoC is used for event-driven workflows such as authentication, flight search, booking, payment, wallet, notifications, and AI conversation handling.
- Cubit is used for simpler state transitions, such as application theme and main navigation state.
- Widgets render state and forward user actions to the relevant BLoC/Cubit.

#### Domain

Contains business-facing abstractions independent of Flutter widgets and HTTP implementation details.

- Entities represent application concepts.
- Repository contracts define the operations required by each feature.
- Use cases represent individual application operations.
- Domain rules contain validations that belong to the feature's business model, such as AI passenger category and age validation.

Repository operations commonly return `Either<Failure, T>` through `fpdart`, keeping expected failures explicit at the domain boundary.

#### Data

Implements domain repository contracts and handles external data.

- Remote data sources execute API requests.
- Models parse API responses and map them to domain entities.
- Repository implementations coordinate data sources, connectivity checks, parsing, and error conversion.
- `DioClient` centralizes HTTP configuration and request interceptors.

### Dependency injection

`get_it` is configured in:

```text
lib/app/init_dependencies.dart
```

Feature data sources, repository implementations, use cases, and BLoCs are registered there. This keeps dependency construction outside UI widgets and makes feature dependencies explicit.

### Application bootstrap

The application entry point is:

```text
lib/main.dart
```

Startup initializes Flutter bindings, Firebase, `SharedPreferences`, and the dependency container before running the application. Global providers include the main navigation Cubit, theme Cubit, authentication BLoC, and user Cubit.

---

## Project Structure

The following is the structure observed in the project archive, simplified to show the main source directories:

```text
lib/
├── app/
│   ├── app.dart
│   ├── init_dependencies.dart
│   ├── routes/
│   │   ├── app_routes.dart
│   │   └── route_names.dart
│   └── theme/
│
├── core/
│   ├── animation/
│   ├── common/
│   │   ├── cubit/
│   │   ├── entities/
│   │   └── widget/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── usecase/
│   └── utils/
│
├── features/
│   ├── AiAssistant/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── flight/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   ├── main/
│   ├── master/
│   ├── notifications/
│   ├── onboarding/
│   ├── profile/
│   ├── setting/
│   ├── splash/
│   ├── ticket/
│   └── wallet/
│
├── firebase_options.dart
└── main.dart
```

Feature naming and folder conventions reflect the existing source code. In particular, the AI module is currently named `AiAssistant` and uses `presentations` in the notifications module.

---

## Features

### 1. Application foundation

- Splash screen and onboarding.
- Main application navigation with a custom bottom navigation bar.
- Centralized routing with `GoRouter`.
- Light/dark theme state.
- Shared UI components, loading overlay, animations, and snackbar helpers.
- Network connectivity checking.

### 2. Authentication

Located in `lib/features/auth/`.

- Sign in.
- Sign up.
- Sign-up success screen.
- Current-user retrieval.
- Local access-token and refresh-token handling.
- Authenticated API requests.
- Access-token refresh and request retry handling through the Dio interceptor.

### 3. Home and flight search

Located in `lib/features/home/` and `lib/features/flight/`.

- Flight search form.
- Airport search and selection.
- Departure and return date selection.
- Passenger quantity selection.
- Cabin/seat-class selection.
- Flight search results.
- Flight and itinerary details.
- Fare-class retrieval and selection.

### 4. Booking and passenger management

Located in `lib/features/flight/`.

- Passenger booking form.
- Passenger information handling.
- Booking / PNR creation.
- PNR detail retrieval.
- Booking lookup by booking code.
- Customer PNR listing.
- PNR cancellation.
- Booking detail and price summary screens.

### 5. Ancillary services

The flight module contains ancillary data, domain operations, and UI flows for:

- Baggage selection and purchase.
- Meal selection and purchase.
- Seat selection.
- Ancillary catalog and category retrieval.
- Ancillary purchase lookup by PNR.
- Ancillary purchase cancellation.

### 6. Payment

Located in `lib/features/flight/`.

- Payment creation.
- Payment detail retrieval.
- Payment lookup by PNR.
- Payment workflow integration with the backend.

Available payment channels and transaction outcomes are determined by backend responses and validation.

### 7. Wallet

Located in `lib/features/wallet/`.

- Wallet balance retrieval.
- Wallet transaction history.
- Wallet top-up request.
- Top-up status retrieval.

The wallet screen displays balance and transaction history. Top-up processing depends on the backend payment flow and its payment notification/status lifecycle.

### 8. Ticket and check-in

Located in `lib/features/ticket/`.

- Ticket listing.
- Ticket detail.
- Check-in request.
- Boarding-pass retrieval.
- Booking-code lookup UI.

### 9. Profile and settings

Located in `lib/features/profile/` and `lib/features/setting/`.

- Profile retrieval.
- Profile update.
- Application settings screen.
- Theme preference.

### 10. Notifications

Located in `lib/features/notifications/`.

- Firebase Cloud Messaging initialization.
- Push-notification permission handling.
- Device registration and unregistration through backend use cases.
- Notification listing.
- Unread notification count.
- Mark notification as read.
- Mark all notifications as read.
- Local notification presentation and notification interaction streams.

### 11. Master data

Located in `lib/features/master/`.

- Country calling-code retrieval.
- Country-code search dialog.

---

# AI Booking Assistant

The AI Assistant is an integrated conversational booking interface in the mobile application. It is implemented as a dedicated screen and has its own BLoC, domain entities, use cases, repository, and remote data source.

The feature is more than a chat interface: the mobile client handles explicit booking actions returned by the assistant and sends structured commands to the PSS backend.

## AI Assistant capabilities

### Conversational messaging

- Start a new AI conversation.
- Retrieve or resume the active conversation.
- Retrieve a conversation by ID.
- Send text messages.
- Send voice transcripts with a distinct input type.
- Retry a failed message.
- Cancel an eligible conversation.
- Render assistant turns into typed chat messages.

### Voice interaction

Voice functionality is implemented with `speech_to_text` and `flutter_tts`.

- Speech-to-text input using the `id_ID` locale.
- Partial transcript display while listening.
- Automatic submission when a final transcript is received.
- Text-to-speech for assistant replies.
- Optional voice replies.
- Listening/speaking state and voice overlay.
- Voice services are stopped when the application leaves the resumed lifecycle state or when a form is opened.

### Flight and fare selection

The AI booking flow supports structured flight selection:

- Departure flight option selection.
- Return flight option selection when applicable.
- Fare-class selection.
- Flight offer, segment, and fare information rendering.

The selected fare is represented by a fare-class ID. Cabin/seat class and fare class are distinct concepts in the flight data model.

### Passenger and contact submission

The assistant flow collects passenger and contact information through a dedicated form.

Passenger categories:

- `ADT` — Adult.
- `CHD` — Child.
- `INF` — Infant.

The domain rules include validation for passenger names, email, phone number, nationality code, date of birth, and passenger age against the travel dates.

### Booking confirmation

- Display booking confirmation details returned by the backend.
- Submit booking confirmation using the server-provided `summary_hash`.
- Display booking information, including booking code/PNR and hold-expiration information when returned.

### Wallet payment

- Display payment confirmation details.
- Submit payment confirmation using the server-provided `summary_hash`.
- Refresh/check payment status.
- The AI booking payment flow is intended to use the authenticated customer's PSS wallet, subject to backend authorization and validation.

The client does not calculate or independently authorize the final payable amount. The backend remains authoritative for pricing, booking state, payment eligibility, and transaction results.

## AI booking lifecycle

```text
Customer
   │
   ▼
AI Assistant screen
   │
   ├── Text input
   └── Voice input (speech-to-text)
   │
   ▼
Start / Resume Conversation
   │
   ▼
Send Message
   │
   ▼
Backend AI Assistant
   │
   ├── Understand travel requirements
   └── Return structured assistant turn
   │
   ▼
Flight offers
   │
   ▼
Customer selects flight and fare
   │
   ▼
Passenger & contact form
   │
   ▼
Submit passenger information
   │
   ▼
Booking confirmation summary
   │
   ▼
Customer confirms booking
   │
   ▼
Booking / PNR result
   │
   ▼
Payment confirmation summary
   │
   ▼
Customer confirms wallet payment
   │
   ▼
Refresh payment status
   │
   ▼
Final booking/payment status
```

The flow is state-driven. The latest `AiTurnEntity` controls which actions are currently valid, rather than allowing the UI to advance through every step unconditionally.

## AI module structure

```text
features/AiAssistant/
├── data/
│   ├── ai_api_exception.dart
│   ├── datasources/
│   │   └── ai_assistant_remote_data_sources.dart
│   ├── models/
│   │   └── ai_assistant_model.dart
│   └── repositories/
│       └── ai_assistant_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── ai_assistant_entity.dart
│   │   └── chat_entity.dart
│   ├── repository/
│   │   └── ai_assistant_repository.dart
│   ├── rules/
│   │   └── ai_passenger_rules.dart
│   └── usecases/
│       ├── start_ai_conversation.dart
│       ├── get_active_ai_conversation.dart
│       ├── get_ai_conversation.dart
│       ├── send_ai_message.dart
│       ├── select_ai_flight.dart
│       ├── submit_ai_passengers.dart
│       ├── confirm_ai_booking.dart
│       ├── confirm_ai_payment.dart
│       ├── refresh_ai_payment.dart
│       └── cancel_ai_conversation.dart
│
└── presentation/
    ├── bloc/
    │   ├── ai_assistant_bloc.dart
    │   ├── ai_assistant_event.dart
    │   ├── ai_assistant_state.dart
    │   └── ai_chat_mapper.dart
    ├── screen/
    │   ├── chat_screen.dart
    │   ├── chat_history_screen.dart
    │   └── passanger_contact_form_screen.dart
    ├── voice/
    │   ├── ai_voice_ports.dart
    │   ├── ai_voice_controller.dart
    │   └── ai_voice_overlay.dart
    └── widget/
        ├── chat_input.dart
        ├── chat_message_bubble.dart
        ├── chat_typing_indicator.dart
        ├── chat_suggestions.dart
        ├── chat_drawer.dart
        └── ...
```

## AI API integration

The AI remote data source uses `DioClient` and the endpoint definitions in `lib/core/constants/endpoint.dart`.

The client-side operations include:

| Operation | Purpose |
|---|---|
| Start conversation | Create a new assistant conversation |
| Get active conversation | Resume the active conversation |
| Get conversation by ID | Load a specific conversation |
| Send message | Submit text or voice transcript |
| Select flight | Submit departure/return option and fare class |
| Submit passengers | Submit contact and passenger data |
| Confirm booking | Confirm a booking summary |
| Confirm payment | Confirm a payment summary and channel |
| Check payment | Refresh payment status |
| Cancel conversation | Cancel an eligible conversation |

The AI Assistant is integrated through the PSS backend API; the mobile application does not connect directly to an LLM provider.

---

## Backend Communication

All remote feature data is accessed through the backend REST API using the shared `DioClient`.

### Dio client responsibilities

The shared client configures:

- Base URL from the selected environment.
- JSON request/response defaults.
- Connection and receive timeouts.
- Authorization header injection from the local token data source.
- Request/response logging interceptor.
- Handling of HTTP `401` responses.
- Refresh-token coordination to avoid parallel refresh requests.
- Retrying the failed request with the refreshed access token.
- Session invalidation and forced logout handling.

The AI Assistant, authentication, flight, booking, payment, wallet, profile, ticket, and notification remote data sources use the shared networking layer.

### Backend architecture context

The mobile application is a client of the PSS backend. The backend project uses a Go Modular Monolith architecture with CQRS. From the mobile application's perspective, backend modules are accessed through versioned API endpoints and represented by feature-specific remote data sources and repository contracts.

---
### Environment variables with Envied

Environment configuration is defined in:

```text
lib/core/constants/environment.dart
```

The project uses `envied` with an `.env` file and generated Dart code. The selected `APP_ENV` determines which API base URL is used:

- `dev`
- `staging`
- `prod`

Expected environment keys:

```env
APP_ENV=staging
DEV_URL=https://your-development-api
STAGING_URL=https://your-staging-api
PRODUCTION_URL=https://your-production-api
APP_USERNAME_LOGIN=your-development-username
APP_PASSWORD_LOGIN=your-development-password
```

Use actual values only in your local environment. Do not commit `.env` or expose credentials in documentation, issue reports, or screenshots.

`envied` obfuscation should not be treated as a substitute for secret management. Values embedded in a client application can potentially be extracted.

### Firebase

Firebase is initialized through `firebase_options.dart`. Platform-specific Firebase configuration must be provided for the platforms being built.

---

## Getting Started

### Prerequisites

- Flutter SDK compatible with the Dart SDK constraint in `pubspec.yaml` (`^3.13.0`).
- Dart SDK.
- Android Studio / Android SDK for Android development.
- Xcode for iOS development on macOS.
- Access to a running PSS backend environment.
- Firebase configuration for the target platform.
- Local `.env` configuration.

### 1. Clone the repository

```bash
git clone https://github.com/adityaputra42/aira_fly.git
cd pss_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment

Create a local `.env` file in the project root using the keys listed in [Environment variables with Envied](#environment-variables-with-envied).

Do not copy production credentials into a shared repository.

### 4. Generate Envied code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the application

```bash
flutter run
```

Make sure the configured API base URL points to a reachable backend environment.

---

## Useful Commands

### Analyze source code

```bash
flutter analyze
```

### Run tests

```bash
flutter test
```

### Build Android APK

```bash
flutter build apk --release
```

### Build Android App Bundle

```bash
flutter build appbundle --release
```

### Build iOS

```bash
flutter build ios --release
```

## License

This project is licensed under the MIT License.

---

Developed by **Aditya Putra Pratama**
