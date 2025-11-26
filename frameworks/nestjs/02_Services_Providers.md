# 🛠️ Services & Providers: Business Logic Best Practices Checklist

The Service layer, defined by the `@Injectable()` decorator, holds the **core business logic** of your application. These providers are Singleton by default and are the central piece of the Dependency Injection system.

This checklist focuses on **Testability, Error Management, and Data Layer Abstraction**.

## 1. Core Structure and Responsibility

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[S]** | **Single Responsibility** | A service must adhere to the Single Responsibility Principle (SRP). It should handle logic related to **one specific domain/feature** (e.g., `UserService` manages users, not payments). |
| **[S]** | **Injectable Decorator** | Every provider class **must** be decorated with **`@Injectable()`** to allow the IoC Container to manage and inject it correctly. |
| **[S]** | **Dependency Injection (DI)** | Use the constructor exclusively to inject all necessary dependencies (e.g., other services, configuration, or data repositories). Avoid manual instantiation (`new Class()`). |
| **[S]** | **Abstraction** | Services should ideally depend on **Abstractions** (Interfaces) rather than concrete implementations, especially when dealing with data access (Database Repositories) or third-party APIs. |

## 2. Data Access and Persistence

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[A]** | **Repository Pattern** | Implement the **Repository Pattern** to separate domain logic from data persistence details (ORM, SQL, NoSQL). The service should interact with the database **only** through a repository interface/class. |
| **[A]** | **Avoid Direct DB Calls** | The service layer must **never** contain raw SQL queries or complex ORM logic. Delegate all persistence details to the dedicated Repository layer. |
| **[A]** | **Transaction Management** | Implement clear, atomic transaction management for operations that involve multiple data changes. Transactions should be initiated and committed/rolled back within the service methods. |
| **[A]** | **Data Consistency** | Ensure all methods handle data consistency checks before persistence (e.g., checking for duplicate usernames before creating a new user). |

## 3. Error Handling and Exceptions

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[P]** | **Throwing HTTP Exceptions** | Services are the authoritative layer for throwing exceptions. Use **built-in NestJS HTTP Exceptions** (e.g., `NotFoundException`, `ConflictException`, `BadRequestException`) to signal errors. |
| **[P]** | **Avoid `try-catch` Bloat** | Avoid unnecessary `try-catch` blocks inside the service methods. Let the exceptions bubble up to the global **Exception Filters** for standardized formatting, unless you need to catch a specific error to execute fallback logic. |
| **[P]** | **Custom Exceptions** | For complex domain errors, create **Custom Exceptions** that extend `HttpException` (or a base class) to provide unique, context-rich error codes to the client. |

## 4. Performance and Asynchronicity

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[P]** | **Async by Default** | All service methods that interact with I/O (Database, File System, Network) must be `async` and return a `Promise<T>`. This ensures the Node.js event loop remains non-blocking. |
| **[P]** | **Memoization/Caching Logic** | Implement internal caching logic (Memoization) within the service for expensive computational results that are required multiple times during a single request or across short periods. |
| **[P]** | **Batching/Bulk Operations** | When performing multiple related writes/updates, look for opportunities to use database **bulk operations** instead of looping through individual writes to improve I/O efficiency. |

## 5. Testing and Maintainability

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[M]** | **Unit Testing Focus** | Services must have comprehensive **Unit Test coverage** (using **Jest**). Unit tests should verify the business logic *without* touching the actual database or external resources. |
| **[M]** | **Mocking Dependencies** | When testing a service, all its dependencies (Repositories, other Services) must be **Mocked** or **Stubbed** to isolate the service logic under test. |
| **[M]** | **Code Standards** | Maintain clean, idiomatic TypeScript code. Use interfaces to define contracts for input (DTOs) and output data structures. |