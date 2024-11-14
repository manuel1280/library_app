# README

**Development approach**

To create a basic API with essential functionality, I typically use the following gem stack and I structured the data across three tables—User, Book, and Borrowing—to keep the organization simple. I kept controllers lean by placing most of the logic within the models and followed a TDD (test-driven development) approach. Additionally, I limited the use of serializers in responses and simplified some tests by minimizing the use of factories to improve their performance.

* SQLite3: The database gem for storing and retrieving data in the development environment.
* JBuilder: The JSON builder gem for generating JSON responses in the API.
* Devise Token Auth: The authentication gem for managing user authentication and authorization.
* Faker: The data generator gem for creating fake data in the development and testing environments.
* RSpec-Rails: The testing gem for writing unit and integration tests for the application.
* Shoulda-Matchers: The gem for simplifying test assertions, making them more readable.
* FactoryBot Rails: The gem for creating test data and fixtures.


Based on the provided code snippets, I'll create brief API documentation for each endpoint. Please note that some endpoints might be missing, and this documentation is based on the available information.

**Users Controller**

* **GET /users/create**: Returns HTTP success (200 OK)
* **GET /users/destroy**: Returns HTTP success (200 OK)

**Borrowings Controller**

* **GET /borrowings/create**: Returns HTTP success (200 created)
* **GET /borrowings/update**: Returns HTTP success (200 OK)
* **GET /borrowings/destroy**: Returns HTTP success (200 OK)
* **GET /borrowings/show**: Returns HTTP success (200 OK)
* **GET /borrowings/index**: Returns HTTP success (200 OK)

**Dashboards Controller**

* **GET /admin_borrowings**: Returns a summary report of borrowings, including total books, total borrowings, total borrowed books today, total books due today, and members overdue.
* **GET /member_borrowings**: Returns a report of borrowings for a specific member, including borrowed books with due dates and overdue status.

**Books Controller**

* **POST /books**: Creates a new book with the provided title, author, genre, ISBN, and total copies.
* **GET /books**: Returns a list of books with their IDs and titles.
* **GET /books/:id**: Returns a specific book with its ID and title.

Please note that this documentation is incomplete and might not cover all available endpoints. Additionally, the request and response formats (e.g., JSON, XML) are not specified.
