# MathMatric

**MathMatric** is a Grade 12 Mathematics learning platform designed to bring curriculum-based learning, examination preparation, tutoring, masterclasses, and competitive learning into one student experience.

The platform is being built with a strong focus on **offline-capable learning, structured mathematics practice, human tutoring, and scalable backend infrastructure**.

> **Status:** Actively under development.

---

## Overview

MathMatric is being developed for Grade 12 Mathematics students, with the goal of supporting the full learning journey, from independent practice and examination preparation to live tutoring, masterclasses, and competitive learning.

The platform is built around three major learning experiences:

### Tutoring Sessions

Students will be able to discover tutors, view profiles and availability, request sessions, and book online or in-person lessons.

### Masterclasses

Masterclasses will provide structured teaching experiences around important mathematics topics and examination preparation.

### Dynamic Quizzes & Competitions

MathMatric will deliver dynamic mathematics quizzes on a recurring basis, allowing students to practise consistently, track their performance, compete through leaderboards, and eventually participate in mathematics competitions.

These experiences are supported by a backend designed for reliable scheduling, payments, refunds, transactions, tutor payouts, and other production-level marketplace requirements.

---

# Core Features

## Mathematics Learning

* Grade 12 Mathematics curriculum
* Curriculum-aligned topics
* Difficulty levels
* Practice questions
* Progress tracking
* Study sessions
* Past examination papers
* Examination memoranda
* Offline curriculum access

## Tutoring Sessions

The Tutor Marketplace is being built to allow students to:

* Discover tutors
* Search and filter tutors
* View tutor profiles
* View tutor availability
* Choose online or in-person tutoring
* Request tutoring sessions
* Book tutoring sessions
* Manage booking status

The marketplace also includes backend infrastructure for:

* Booking concurrency
* Payment processing
* Refunds
* Financial transactions
* Platform fees
* Tutor payouts
* Provider integrations
* Webhook processing
* Financial idempotency

## Masterclasses

Masterclasses are a major upcoming feature of MathMatric.

They are intended to provide structured learning experiences around topics and examination preparation, including focused sessions such as:

* Topic masterclasses
* Examination-focused sessions
* Paper-specific preparation
* High-pressure revision sessions
* Last-push examination preparation

Masterclasses are currently under development.

## Dynamic Quizzes

MathMatric will introduce recurring dynamic quizzes designed to keep students practising consistently throughout the year.

The planned system will evolve from:

```text
Weekly Quizzes
      ↓
Performance Tracking
      ↓
Leaderboards
      ↓
Competitions
```

The long-term goal is to make mathematics practice more engaging through recurring challenges, measurable progress, and competitive learning.

This feature is currently under development.

---

# Technology Stack

## Mobile Application

* **Flutter**
* **Dart**
* **flutter_bloc**
* **GoRouter**

## Backend

* **TypeScript**
* **Firebase Cloud Functions**
* **Firebase Authentication**
* **Cloud Firestore**
* **Firebase Storage**

The mobile application is built with Flutter and Dart, while the backend services are implemented in TypeScript using Firebase Cloud Functions.

## Local Storage

* **Drift**
* **SQLite**

Drift is used to support local curriculum storage and offline learning.

## Architecture

* Clean Architecture
* BLoC state management
* Repository pattern
* Dependency injection with GetIt
* Domain-driven separation of business logic
* Provider abstractions for external financial services

## Testing

* Flutter/Dart unit tests
* TypeScript unit tests
* Firebase Emulator Suite
* Firestore integration tests
* Backend integration testing

---

# Architecture

At a high level, MathMatric separates the mobile application, domain logic, local storage, and Firebase backend.

```text
                    MathMatric
                        │
          ┌─────────────┴─────────────┐
          │                           │
     Flutter App                  Firebase Backend
          │                           │
    ┌─────┴─────┐              ┌─────┴──────────┐
    │           │              │                │
Presentation  Domain         Firestore      Cloud Functions
    │           │              │                │
   BLoC      Use Cases        Data         Business Services
              │                              │
        Repositories                  ┌──────┴───────┐
              │                       │              │
        ┌─────┴─────┐            Marketplace    Financial
        │           │                 │              │
      Firebase    Drift           Booking        Payments
                                  Tutors          Refunds
                                  Availability   Transactions
                                                 Payouts
```

The financial system is designed around provider-independent domain logic, allowing external payment and payout providers to be integrated without coupling the core financial domain to a specific provider.

---

# Financial Infrastructure

The Tutor Marketplace includes a production-oriented financial architecture.

Implemented components include:

* Payment lifecycle
* Refund lifecycle
* Financial transaction records
* Platform fee calculation
* Tutor payout lifecycle
* Provider abstraction
* Provider identity protection
* Payment webhooks
* Payout infrastructure
* Idempotent financial operations
* Firestore transaction-based consistency
* Concurrency protection

All monetary values are represented using **integer cents** rather than floating-point values.

The current financial architecture is provider-independent.

### Current provider integration

**Peach Payments** is the planned payment and payout provider for the production integration.

The internal financial domain is intentionally separated from the provider:

```text
MathMatric Financial Domain
            │
     Provider Interfaces
            │
      ┌─────┴─────┐
      │           │
 PaymentProvider  PayoutProvider
      │           │
      └─────┬─────┘
            │
      Peach Payments
```

---

# Project Status

MathMatric is an actively developed project.

## Completed / Substantially Implemented

### Learning Foundation

* Flutter application foundation
* Clean Architecture
* Firebase integration
* Local curriculum database
* Drift offline storage
* Curriculum data architecture
* Practice question architecture
* Progress tracking architecture
* Examination paper architecture

### Tutor Marketplace

* Tutor discovery
* Tutor pagination
* Tutor profiles
* Tutor search
* Teaching mode filtering
* Tutor availability
* Booking creation
* Booking status lifecycle
* Booking concurrency protection

### Financial System

* Payment domain
* Payment lifecycle
* Refund domain
* Refund calculations
* Transaction infrastructure
* Payment transactions
* Payment webhooks
* Tutor payout domain
* Platform fee calculation
* Tutor payout eligibility
* Payout transactions
* Payout lifecycle
* Payout provider abstraction
* Payout provider identity
* Payout initiation
* Firestore emulator integration testing

---

# Currently Under Development

## Peach Payments Integration

The internal payment and payout architecture is complete and is being connected to a real payment provider.

The next financial milestone is integrating **Peach Payments**, initially through its sandbox environment.

This will connect the existing financial architecture to real payment and payout infrastructure while keeping provider-specific logic isolated behind the existing abstractions.

## Masterclasses

The Masterclass system is one of the major upcoming learning experiences in MathMatric.

The system will support structured mathematics teaching experiences alongside the existing independent-learning and tutoring systems.

## Dynamic Quiz System

The dynamic quiz system is another major upcoming feature.

The planned progression is:

```text
Dynamic Quiz Generation
        ↓
Weekly Quiz Delivery
        ↓
Student Attempts
        ↓
Performance Tracking
        ↓
Leaderboards
        ↓
Competitive Events
        ↓
Mathematics Competitions
```

These systems are part of the next major phase of product development.

---

# Roadmap

MathMatric is being developed as a broader learning ecosystem rather than a collection of isolated features.

```text
                         MATHMATRIC
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
 Independent Learning   Tutoring Sessions    Competitive Learning
        │                    │                    │
        │                    │                    ▼
        │                    │              Dynamic Quizzes
        │                    │                    │
        │                    │                    ▼
        │                    │               Weekly Challenges
        │                    │                    │
        │                    │                    ▼
        │                    │                Leaderboards
        │                    │                    │
        │                    │                    ▼
        │                    │               Competitions
        │                    │
        │                    ▼
        │              Tutor Marketplace
        │                    │
        │             ┌──────┴──────┐
        │             │             │
        │          Online       In-Person
        │             │             │
        │             └──────┬──────┘
        │                    │
        │                 Booking
        │                    │
        │              Payments/Refunds
        │                    │
        │               Tutor Payouts
        │
        ▼
 Curriculum & Exam Preparation
        │
        ├── Topics
        ├── Practice
        ├── Difficulty Levels
        ├── Progress Tracking
        ├── Past Papers
        └── Offline Learning

                    +
                    
                 Masterclasses
                    │
          ┌─────────┼─────────┐
          │         │         │
       Topics    Exam Prep   Paper Prep
```

### Product direction

```text
Phase 1
Curriculum + Independent Learning
        ↓
Phase 2
Tutor Marketplace + Tutoring Sessions
        ↓
Phase 3
Financial Infrastructure + Payments
        ↓
Phase 4
Peach Payments Integration
        ↓
Phase 5
Masterclasses
        ↓
Phase 6
Dynamic Weekly Quizzes
        ↓
Phase 7
Leaderboards + Competitive Learning
        ↓
Phase 8
Mathematics Competitions
```

The exact implementation order may evolve as the product develops.

---

# Development

## Prerequisites

You will need:

* Flutter SDK
* Dart SDK
* Node.js
* Firebase CLI
* Java/JDK for Firebase Emulator Suite

## Clone the repository

```bash
git clone https://github.com/iChunu-Siyanda/MathMatric.git
cd MathMatric
```

## Install Flutter dependencies

```bash
flutter pub get
```

## Run the application

```bash
flutter run
```

Backend development requires the Firebase configuration and Cloud Functions environment described in the project documentation.

---

# Testing

Flutter tests:

```bash
flutter test
```

Backend tests are maintained within the Cloud Functions project.

The Firebase Emulator Suite is used for backend and Firestore integration testing without relying on production data.

Financial workflows are tested against scenarios involving:

* duplicate requests
* concurrent operations
* webhook replay
* provider identity collisions
* payment failures
* refunds
* payout failures
* transaction consistency

---

# Screenshots

Screenshots and product demonstrations will be added as the major student experiences reach their polished UI stage.

---

# Long-Term Vision

MathMatric aims to become more than a mathematics practice application.

The long-term vision is to create an ecosystem where students can:

**Learn → Practise → Get Help → Attend Masterclasses → Challenge Themselves → Compete**

with the curriculum, tutoring, and competitive experiences connected through a single platform.

The project is actively under development, with major upcoming work focused on **Peach Payments, Masterclasses, and the dynamic quiz and competition ecosystem**.

---

# Author

**Siyanda Mchunu**

GitHub: [@iChunu-Siyanda](https://github.com/iChunu-Siyanda)
LinkedIn: [Siyanda-Mchunu](https://www.linkedin.com/in/siyanda-mchunu-ichunu/)
