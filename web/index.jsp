<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Проверка авторизации пользователя
    boolean isLoggedIn = session.getAttribute("user") != null;
    String userRole = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("user");
    String message = null;
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String action = request.getParameter("action");
    String selectedRole = request.getParameter("role"); // Получаем выбранную роль

    // Инициализация переменных для работы с базой данных
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String coursesInfo = "";

    // Блок для получения списка курсов
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/courses_platform", "root", "");

        // Получение списка курсов
        String query = "SELECT title, description FROM courses LIMIT 5";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            coursesInfo += "<li><strong>" + rs.getString("title") + "</strong>: " + rs.getString("description") + "</li>";
        }
    } catch (Exception e) {
        coursesInfo = "<p>Не удалось загрузить информацию о курсах.</p>";
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            coursesInfo += "<p>Ошибка закрытия ресурсов: " + e.getMessage() + "</p>";
        }
    }

    // Блок для обработки логина и регистрации
    try {
        // Регистрация драйвера
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Установите строку подключения, имя пользователя и пароль прямо в коде
        String dbUrl = "jdbc:mysql://localhost:3306/courses_platform";
        String dbUser = "root";  // Укажите ваше имя пользователя
        String dbPassword = "";  // Укажите ваш пароль

        // Устанавливаем соединение с базой данных
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        if ("login".equals(action)) {
            // SQL запрос для проверки пользователя
            String query = "SELECT id, username, role FROM users WHERE email = ? AND password = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email);
            pstmt.setString(2, password); // Пароль должен быть зашифрован
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Если пользователь найден, сохраняем его данные в сессию
                int userId = rs.getInt("id");
                String username = rs.getString("username");
                String role = rs.getString("role");

                session.setAttribute("userId", userId);
                session.setAttribute("userName", username);
                session.setAttribute("userRole", role);

                // Перенаправляем на страницу dashboard
                response.sendRedirect("dashboard.jsp");
                return;
            } else {
                message = "Неверный email или пароль!";
            }
        } else if ("register".equals(action)) {
            // Регистрация нового пользователя
            String username = request.getParameter("username");

            // Если роль не выбрана, задаем роль как "user" по умолчанию
            if (selectedRole == null || selectedRole.isEmpty()) {
                selectedRole = "user"; // Роль по умолчанию
            }

            // SQL запрос для добавления пользователя
            String query = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, password); // Пароль должен быть зашифрован
            pstmt.setString(4, selectedRole); // Используем выбранную роль

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Регистрация прошла успешно! Теперь вы можете войти.";
            } else {
                message = "Ошибка при регистрации. Попробуйте снова.";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "Ошибка при обработке данных: " + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            message = "Ошибка при закрытии соединения: " + e.getMessage();
        }
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Образовательная Платформа</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .form-container {
            background-color: #f68b3f; /* Рыжий цвет */
            padding: 20px;
            border-radius: 8px;
            width: 300px;
            margin: 0 auto;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            padding-right: 40px;
        }
        .form-container input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #e7732a;
            border-radius: 4px;
        }
        .form-container button {
            background-color: #e66400;
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 10px;
        }
        .form-container button:hover {
            background-color: #c88e00;
        }
        .form-container h2 {
            color: #fff;
        }
        .success-message, .error-message {
            color: white;
            padding: 10px;
            margin-bottom: 20px;
            text-align: center;
            padding-left: 10px;
        }
        .success-message {
            background-color: #28a745;
        }
        .error-message {
            background-color: #dc3545;
            padding-left: 10px;
        }
        .switch-action {
            text-align: center;
            color: #fff;
        }
        .switch-action a {
            color: #fff;
            text-decoration: underline;
        }
        /* Стили для select (выпадающий список) */
.form-container select {
    background-color: #fff; /* Белый фон для выпадающего списка */
    border: 1px solid #e36b36; /* Рыжая граница */
    border-radius: 5px;
    padding: 10px;
    font-size: 14px;
    color: #333;
    width: 100%; /* Чтобы select занимал всю ширину */
    cursor: pointer;
    margin: 10px;
}

/* Стили для option (варианты в выпадающем списке) */
.form-container select option {
    background-color: #fff;
    color: #333;
}
    </style>
</head>
<body>
<div class="center">
    <header>
        <div class="logo">
            <img src="css/images/logo.png" alt="Логотип">
            <h1 class="title_header">Образовательная Платформа</h1>
        </div>
        <nav>
            <ul>
                <li><a href="index.jsp">Главная</a></li>
                <li><a href="blog.jsp">Блог</a></li>
                <li><a href="about.jsp">О нас</a></li>
            </ul>
        </nav>
    </header>

    <h1>Добро пожаловать на нашу образовательную платформу!</h1>

    <% if (!isLoggedIn) { %>
        <div id="loginRegisterBtn" class="btn_view" style="display:none;"></div>
    <% } else { 
        if (userRole.equals("student")) { %>
            <button id="coursesBtn" class="btn_view">Перейти к курсам</button>
            <button id="progressBtn" class="btn_view">Мой личный прогресс</button>
        <% } else if (userRole.equals("teacher")) { %>
            <button id="teacherCoursesBtn" class="btn_view">Курсы с учениками</button>
            <button id="teacherProgressBtn" class="btn_view">Прогресс учеников</button>
        <% }
    } %>

    <div id="aboutCourses">
        <h2>Доступные курсы:</h2>
        <ul>
            <%= coursesInfo %>
        </ul>
    </div>

    <div class="form-container center" <%=(isLoggedIn) ? "style='display:none;'" : ""%> >
        <h2><%= (action != null && action.equals("register")) ? "Регистрация" : "Вход" %></h2>

        <% if (message != null) { %>
            <div class="<%= message.contains("успешно") ? "success-message" : "error-message" %>"><%= message %></div>
        <% } %>

        <% if (action != null && action.equals("register")) { %>
            <form method="POST" action="index.jsp">
                <input type="hidden" name="action" value="register">
                <div>
                    <label for="username">Имя пользователя:</label>
                    <input type="text" name="username" id="username" required>
                </div>
                <div>
                    <label for="email">Email:</label>
                    <input type="email" name="email" id="email" required>
                </div>
                <div>
                    <label for="password">Пароль:</label>
                    <input type="password" name="password" id="password" required>
                </div>
                <div>
                    <label for="role">Роль:</label>
                    <select name="role" id="role" required>
                        <option value="user">Ученик</option>
                        <option value="teacher">Учитель</option>
                    </select>
                </div>
                <div>
                    <button type="submit">Зарегистрироваться</button>
                </div>
            </form>
            <div class="switch-action">
                <p>Уже есть аккаунт? <a href="index.jsp">Войти</a></p>
            </div>
        <% } else { %>
            <form method="POST" action="index.jsp">
                <input type="hidden" name="action" value="login">
                <div>
                    <label for="email">Email:</label>
                    <input type="email" name="email" id="email" required>
                </div>
                <div>
                    <label for="password">Пароль:</label>
                    <input type="password" name="password" id="password" required>
                </div>
                <div>
                    <button type="submit">Войти</button>
                </div>
            </form>
            <div class="switch-action">
                <p>Нет аккаунта? <a href="index.jsp?action=register">Зарегистрироваться</a></p>
            </div>
        <% } %>
    </div>
</div>

<script src="js/script.js"></script>
</body>
</html>
