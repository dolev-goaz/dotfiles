---
name: typescript
description: Guidelines for writing TypeScript code in the repository.
---

# TypeScript Coding Guidelines

When writing TypeScript code in this repository, please follow these guidelines to maintain code quality and consistency:

## Type Annotations

1.  Always use explicit type annotations for function parameters and return types. This helps improve code readability and maintainability. Do not use the `any` type unless absolutely necessary, and provide a justification in comments when you do.

    - Good Example:
      ```typescript
      function add(a: number, b: number): number {
        return a + b;
      }
      ```
    - Bad Example:
      ```typescript
      function add(a: any, b: any) {
        return a + b;
      }
      ```

2.  Use interfaces or type aliases to define complex types and data structures. This promotes code reuse and makes it easier to understand the shape of data being used.

    - Good Example:
      ```typescript
      interface User {
        id: number;
        name: string;
        email: string;
      }
      ```
    - Bad Example:
      ```typescript
      const user = {
        id: 1,
        name: "John Doe",
        email: "
      ```

3.  Do not use inline types, instead define the interface beforehand for better readability and maintainability.

    - Good Example:

      ```typescript
      interface Product {
        id: number;
        name: string;
        price: number;
      }

      function getProduct(): Product {
        return { id: 1, name: "Laptop", price: 999 };
      }
      ```

    - Bad Example:
      ```typescript
      function getProduct(): { id: number; name: string; price: number } {
        return { id: 1, name: "Laptop", price: 999 };
      }
      ```

4.  Prefer using `interface` over `type` for defining object shapes, unless you need to use union types or other advanced type features that `type` provides.

    - Good Example:
      ```typescript
      interface Car {
        make: string;
        model: string;
        year: number;
      }
      ```
    - Bad Example:
      ```typescript
      type Car = {
        make: string;
        model: string;
        year: number;
      };
      ```

5.  When defining an enum, prefer using const enums instead of regular enums for more predictable code.

    - Good Example:
      ```typescript
      const Direction = {
        Up,
        Down,
        Left,
        Right,
      } as const;
      type TDirection = (typeof Direction)[keyof typeof Direction];
      ```
    - Bad Example:
      ```typescript
      enum Direction {
        Up,
        Down,
        Left,
        Right,
      }
      ```

6.  When defining union types, prefer defining then from an enum rather than a union of string literals, as it provides better type safety and readability.

- Good Example:

  ```typescript
  const UserRole = {
    Admin = "admin",
    User = "user",
    Guest = "guest",
  } as const;
  type TUserRole = (typeof UserRole)[keyof typeof UserRole];

  function getUserRole(role: TUserRole) {
    // ...
  }
  ```

- Bad Example:

  ```typescript
  type UserRole = "admin" | "user" | "guest";

  function getUserRole(role: UserRole) {
    // ...
  }
  ```

## Function and Variable Declarations

1. Use `const` for variables that are not reassigned after their initial declaration. This helps prevent accidental reassignments and makes it clear that the variable is meant to be immutable.

   - Good Example:
     ```typescript
     const MAX_USERS = 100;
     ```
   - Bad Example:
     ```typescript
     let MAX_USERS = 100;
     ```

2. Use `let` for variables that need to be reassigned. Avoid using `var` as it has function scope and can lead to unexpected behavior.

   - Good Example:
     ```typescript
     let userCount = 0;
     userCount += 1;
     ```
   - Bad Example:
     ```typescript
     var userCount = 0;
     userCount += 1;
     ```

3. When defining functions, prefer using `function` declarations for named functions and arrow functions for anonymous, inline functions. This promotes better readability and consistency.

   - Good Example:

     ```typescript
     const users: TUser[] = [];
     function getFullName(user: TUser): number {
       return [user.firstName, user.lastName].join(" ");
     }

     const userNames = users.map(getFullName);
     // OR
     const users: TUser[] = [];
     const userNames = users.map((user: TUser) =>
       [user.firstName, user.lastName].join(" "),
     );
     ```

   - Bad Example:

     ```typescript
     const users: TUser[] = [];
     const userNames = users.map(function (user: TUser) {
       return [user.firstName, user.lastName].join(" ");
     });
     ```

4. If the logic is complex or the code itself is unclear, prefer named functions for better stack traces and readability.
   - Good Example:
     ```typescript
     const users: TUser[] = [];
     function getTaxBracket(user: TUser): string {
       if (user.income < 30000) return "Low";
       if (user.income < 100000) return "Middle";
       return "High";
     }
     const taxBrackets = users.map(getTaxBracket);
     ```
   - Bad Example:
     ```typescript
     const users: TUser[] = [];
     const taxBrackets = users.map((user: TUser) => {
       if (user.income < 30000) return "Low";
       if (user.income < 100000) return "Middle";
       return "High";
     });
     ```

## Function and Variable Naming

1. Use descriptive and meaningful names for functions and variables that clearly indicate their purpose and intent. Avoid using abbreviations or single-letter names unless they are widely understood in the context (e.g., `i` for loop index).

   - Good Example:
     ```typescript
     const userList: TUser[] = [];
     function calculateTotalPrice(items: TItem[]): number {
       return items.reduce((total, item) => total + item.price, 0);
     }
     ```
   - Bad Example:
     ```typescript
     const ul: TUser[] = [];
     function calc(items: TItem[]): number {
       return items.reduce((t, i) => t + i.price, 0);
     }
     ```

2. For boolean variables, use names that imply a true/false value, such as `is`, `has`, `can`, or `should`.

   - Good Example:
     ```typescript
     const isLoggedIn = true;
     const hasPermission = false;
     ```
   - Bad Example:
     ```typescript
     const loggedIn = true;
     const permission = false;
     ```

3. For functions that perform an action, use verb-based names that clearly indicate what the function does.

   - Good Example:
     ```typescript
     function sendEmail(to: string, subject: string, body: string): void {
       // ...
     }
     ```
   - Bad Example:
     ```typescript
     function email(to: string, subject: string, body: string): void {
       // ...
     }
     ```

4. For functions that return a value, use noun-based names that describe the value being returned.
   - Good Example:
     ```typescript
     function getUserById(id: number): TUser | null {
       // ...
     }
     ```
   - Bad Example:
     ```typescript
     function user(id: number): TUser | null {
       // ...
     }
     ```

## Comments

1. Do not over-comment your code. Strive for self-explanatory code through good naming and structure. Use comments to explain the "why" behind complex logic or decisions, not the "what" which should be clear from the code itself. If the code is not clear enough to be understood without comments, consider refactoring it for better readability instead of adding more comments. You should not need to add comments to explain what a function does if it is well-named and straightforward.

   - Good Example:
     ```typescript
     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       return subtotal * (1 + taxRate);
     }
     ```
   - Bad Example:
     ```typescript
     // This function calculates the total price of items in the cart.
     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       // Calculate the subtotal by summing up the price of each item.
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       // Apply tax to the subtotal and return the final total price.
       return subtotal * (1 + taxRate);
     }
     ```

2. Use JSDoc comments for public functions and complex logic to provide additional context and documentation for other developers who may use or maintain the code in the future.

   - Good Example:
     ```typescript
     /**
      * Calculates the total price of items in the cart, including tax.
      * @param items - An array of items, each with a price property.
      * @param taxRate - The tax rate to apply to the subtotal (e.g., 0.07 for 7% tax).
      * @returns The total price after applying tax.
      */
     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       return subtotal * (1 + taxRate);
     }
     ```
   - Bad Example:
     ```typescript
     // This function calculates the total price of items in the cart, including tax.
     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       return subtotal * (1 + taxRate);
     }
     ```

## Refactoring

1. When rewriting code, do not keep the old code as comments/backup file. If you need to keep the old code for reference, use version control (e.g., git) to manage changes and revert if necessary. Keeping old code as comments can lead to confusion and clutter in the codebase.

   - Good Example:
     ```typescript
     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       return subtotal * (1 + taxRate);
     }
     ```
   - Bad Example:

     ```typescript
     // Old code kept as comments
     // function calculateTotalPrice(items: TItem[], taxRate: number): number {
     //   let total = 0;
     //   for (const item of items) {
     //     total += item.price;
     //   }
     //   return total * (1 + taxRate);
     // }

     function calculateTotalPrice(items: TItem[], taxRate: number): number {
       const subtotal = items.reduce((total, item) => total + item.price, 0);
       return subtotal * (1 + taxRate);
     }
     ```

   - Good Example 2:
     ```
     todo-list.service.ts
     ```
   - Bad Example 2:
     ```
     todo-list.service.ts
     todo-list.service.old.ts
     ```
