<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userRole = (String) session.getAttribute("userRole");
    int userId = (session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : 0;
    int courseId = Integer.parseInt(request.getParameter("courseId"));

    String url = "jdbc:mysql://localhost:3306/courses_platform";
    String dbUser = "root";
    String dbPassword = "";

    StringBuilder content = new StringBuilder();

    try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword)) {
        // Получаем информацию о курсе
        String courseQuery = "SELECT title, description FROM courses WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(courseQuery)) {
            pstmt.setInt(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    content.append("<h2>Информация о курсе: ").append(rs.getString("title")).append("</h2>")
                           .append("<p><strong>Описание:</strong> ").append(rs.getString("description")).append("</p>");
                } else {
                    content.append("<p>Курс не найден.</p>");
                }
            }
        }

        // Для преподавателя — показываем студентов с их прогрессом
        if ("teacher".equalsIgnoreCase(userRole)) {
            String studentsQuery = "SELECT s.id, s.username, sc.progress FROM users s " +
                                   "JOIN student_courses sc ON s.id = sc.student_id WHERE sc.course_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(studentsQuery)) {
                pstmt.setInt(1, courseId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    content.append("<h3>Студенты, проходящие этот курс:</h3>");
                    while (rs.next()) {
                        content.append("<form method='POST' action='updateProgress.jsp'>")
                               .append("<input type='hidden' name='studentId' value='").append(rs.getInt("id")).append("' />")
                               .append("<input type='hidden' name='courseId' value='").append(courseId).append("' />")
                               .append("<p><strong>").append(rs.getString("username")).append("</strong> - Прогресс: ")
                               .append(rs.getInt("progress")).append("%</p>")
                               .append("<label for='progress'>Изменить прогресс:</label>")
                               .append("<input type='checkbox' name='progress' value='1' ")
                               .append(rs.getInt("progress") == 100 ? "checked" : "")
                               .append(" /> Завершено")
                               .append("<button type='submit'>Обновить</button>")
                               .append("</form>");
                    }
                }
            }

            // Случайная информация о курсе
            String randomContentQuery = "SELECT content FROM random_course_info ORDER BY RAND() LIMIT 1"; // Выбираем случайную информацию
            try (PreparedStatement pstmt = conn.prepareStatement(randomContentQuery);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    content.append("<h3>Случайная информация о курсе:</h3>")
                           .append("<p>").append(rs.getString("content")).append("</p>");
                }
            }
        }

        // Для студентов — показываем информацию о курсе
        else if ("student".equalsIgnoreCase(userRole)) {
            content.append("<h3>Вы записаны на этот курс. Продолжайте обучение!</h3>");
        }

    } catch (SQLException e) {
        content.append("<p>Ошибка: ").append(e.getMessage()).append("</p>");
    }
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Информация о курсе</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="center">
    <header>
        <h1>Информация о курсе</h1>
        <nav>
            <ul>
                <li><a href="index.jsp">Главная</a></li>
                <li><a href="blog.jsp">Блог</a></li>
                <li><a href="about.jsp">О нас</a></li>
            </ul>
        </nav>
        <div id="profile-actions">
            <button id="logoutBtn">Выйти</button>
        </div>
    </header>
    <main>
        <%= content.toString() %>
    </main>
</div>
<script>
    document.getElementById('logoutBtn').addEventListener('click', function() {
        window.location.href = 'logout.jsp';
    });
</script>
</body>
</html>
