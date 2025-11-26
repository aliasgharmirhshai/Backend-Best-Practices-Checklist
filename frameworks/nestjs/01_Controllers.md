# 🚀 Controllers: The Production-Grade API Gateway Checklist

Controllers are the entry point of your NestJS application, responsible for handling incoming HTTP requests and returning responses. Implementing them correctly is crucial for **maintainability, security, and performance**.

This checklist ensures your controllers adhere to the **Separation of Concerns** principle and are ready for large-scale production use.

## 1. Core Structure and Separation of Concerns

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[S]** | **Thin Controller Principle** | The controller must be **"Thin."** It must **not** contain complex **Business Logic**, direct **Database Access** (SQL, ORM calls), or external API integration. Delegate all such tasks to the injected **Service/Provider** layer. |
| **[S]** | **Dependency Injection (DI)** | Use the constructor for **Dependency Injection** to inject all required services. Ensure injected services are declared as `private readonly` properties. |
| **[S]** | **Module Registration** | Verify that the Controller class is correctly listed in the `controllers` array of the associated **Module** (e.g., `AppModule`, `UsersModule`) to ensure it is loaded by NestJS. |
| **[S]** | **Prefixing** | Use the `@Controller('resource-name')` decorator (e.g., `'users'`) to apply a descriptive route prefix for better organization and grouping of related endpoints. |

## 2. Input and Validation (Data Integrity)

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[A]** | **Data Transfer Objects (DTOs)** | Define a dedicated **TypeScript Class** (not an Interface) for every complex incoming payload (`@Body()`, `@Query()`, etc.). Classes are required for runtime reflection by Pipes. |
| **[A]** | **Validation Pipe** | Apply the **`ValidationPipe`** (preferably globally) to the incoming DTOs. Ensure `class-validator` decorators (`@IsNotEmpty()`, `@IsString()`, `@IsEmail()`, etc.) are used within the DTOs to enforce data integrity. |
| **[A]** | **Data Transformation** | Use built-in or custom **Pipes** (e.g., **`ParseIntPipe`**, **`ParseUUIDPipe`**) for route (`@Param()`) and query parameters to automatically convert and validate primitive types. |
| **[A]** | **Security - Whitelisting** | Configure **`ValidationPipe`** with **`whitelist: true`** and **`forbidNonWhitelisted: true`** to automatically strip any fields not explicitly defined in the DTO, effectively protecting against **Mass Assignment** attacks. |

## 3. Security and Authorization

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[A]** | **Authentication Check** | Ensure all protected routes have a mechanism for **Authentication** (Is the user logged in?). This must be handled by a **Guard** (e.g., `JwtAuthGuard`) applied using **`@UseGuards()`**. |
| **[A]** | **Authorization Check** | For routes performing actions or accessing sensitive data, use an **RBAC/Policy Guard** to handle **Authorization** (Does the user have permission for this action?). |
| **[A]** | **Rate Limiting** | Apply a **Rate Limiting** mechanism (Guard or Middleware) to protect endpoints from brute-force attacks and abuse, ensuring service stability. |

## 4. Response Handling and Error Management

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[P]** | **Standard Response Mode** | **AVOID** injecting the native response object using `@Res()` without the `passthrough: true` option. Adhere to the **Standard NestJS Response Mode** (just return the data) to keep **Interceptors** and **Exception Filters** active. |
| **[P]** | **HTTP Status Codes** | Use the **`@HttpCode(statusCode)`** decorator for static, non-default status codes (e.g., `204 No Content`). For dynamic status codes, **throw built-in `HttpExceptions`** (e.g., `new NotFoundException()`) from the **Service Layer**. |
| **[P]** | **Custom Headers** | Use the **`@Header('Key', 'Value')`** decorator for adding static response headers (e.g., Cache-Control) at the handler level. |

## 5. Performance and Asynchronicity

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[P]** | **Async/Await** | Use the **`async/await`** syntax for all methods that call asynchronous operations. The controller method signature must return a **`Promise<T>`** (or `Observable<T>`) to ensure **non-blocking I/O** and maximize Node.js throughput. |
| **[P]** | **Caching** | For data that rarely changes, consider using the NestJS Caching module and the **`@CacheKey()`** / **`@CacheTTL()`** decorators on `GET` endpoints to reduce load on services and the database. |

## 6. Testing and Maintainability

| Status | Principle | Description |
| :---: | :--- | :--- |
| **[M]** | **Test Coverage** | Write **Unit Tests** for the controller using **Jest**. Tests should only verify: **1. Correct Service Call** (controller calls the mocked service method with the right inputs) and **2. Correct Output** (controller returns the data received from the service). |
| **[M]** | **Documentation (Swagger)** | Add **Swagger** decorators (e.g., `@ApiOperation()`, `@ApiBody()`, `@ApiResponse()`) to the controller and its methods for auto-generating interactive API documentation. |
| **[M]** | **Idiomatic Code** | Follow TypeScript/ESLint/Prettier conventions and use clear, descriptive method names (`findAll`, `create`, `update`, `remove`). |