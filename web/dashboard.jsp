<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
if (session == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userRole = (String) session.getAttribute("userRole");
String userName = (String) session.getAttribute("userName");
int userId = (session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : 0;

String url = "jdbc:mysql://localhost:3306/courses_platform";
String dbUser = "root";
String dbPassword = "";

StringBuilder content = new StringBuilder();

// Используем только один блок try для подключения к базе данных
try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword)) {
    if ("student".equalsIgnoreCase(userRole)) {
        // Получение курсов студента
        String courseQuery = "SELECT c.id, c.title, c.description FROM courses c " +
                             "JOIN student_courses sc ON c.id = sc.course_id WHERE sc.student_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(courseQuery)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                content.append("<h2>Ваши доступные курсы:</h2>");
                while (rs.next()) {
                    content.append("<div class='course-button-container'>")
                           .append("<form action='courseDetails.jsp' method='GET'>")
                           .append("<input type='hidden' name='courseId' value='").append(rs.getInt("id")).append("' />")
                           .append("<button type='submit'>")
                           .append("<strong>").append(rs.getString("title")).append("</strong><br>")
                           .append("<span>").append(rs.getString("description")).append("</span>")
                           .append("</button>")
                           .append("</form></div>");
                }
            }
        }

        // Получение информации о преподавателе
        String teacherQuery = "SELECT t.id, t.username FROM users t " +
                              "JOIN student_teacher st ON t.id = st.teacher_id WHERE st.student_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(teacherQuery)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int teacherId = rs.getInt("id");
                    String teacherName = rs.getString("username");

                    // Форма для отправки сообщения преподавателю
                    content.append("<h2>Отправить сообщение преподавателю:</h2>")
                           .append("<form method='POST'>")
                           .append("<label for='teacherName'>Преподаватель:</label>")
                           .append("<input type='text' id='teacherName' name='teacherName' value='")
                           .append(teacherName).append("' readonly>")
                           .append("<input type='hidden' name='teacherId' value='").append(teacherId).append("'>")
                           .append("<label for='message'>Сообщение:</label>")
                           .append("<textarea id='message' name='message' required></textarea>")
                           .append("<button type='submit' name='sendMessage'>Отправить</button>")
                           .append("</form>");
                } else {
                    content.append("<p>Вы не привязаны ни к одному преподавателю.</p>");
                }
            }
        }
    } else if ("teacher".equalsIgnoreCase(userRole)) {
        // Прогресс учеников
        String progressQuery = "SELECT s.username, s.email, c.title, sc.progress FROM users s " +
                               "JOIN student_courses sc ON s.id = sc.student_id " +
                               "JOIN courses c ON c.id = sc.course_id WHERE sc.teacher_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(progressQuery)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                content.append("<h2>Прогресс ваших учеников:</h2>");
                while (rs.next()) {
                    content.append("<p><strong>").append(rs.getString("username")).append("</strong> (")
                           .append(rs.getString("email")).append(") - Курс: ")
                           .append(rs.getString("title")).append(", Прогресс: ")
                           .append(rs.getInt("progress")).append("%</p>");
                }
            }
        }

        // Форма для отправки сообщения ученику
        content.append("<h2>Отправить сообщение ученику:</h2>")
               .append("<form method='POST'>")
               .append("<label for='studentId'>ID ученика:</label>")
               .append("<input type='number' id='studentId' name='studentId' required>")
               .append("<label for='message'>Сообщение:</label>")
               .append("<textarea id='message' name='message' required></textarea>")
               .append("<button type='submit' name='sendMessage'>Отправить</button>")
               .append("</form>");
    } else {
        // Если роль не определена, ничего не показываем
        content.append("<p>У вас нет доступных действий в этой роли.</p>");
    }

    // Обработка отправки сообщений
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("sendMessage") != null) {
        int receiverId = request.getParameter("teacherId") != null ?
                         Integer.parseInt(request.getParameter("teacherId")) :
                         (request.getParameter("studentId") != null ? Integer.parseInt(request.getParameter("studentId")) : 0);
        String message = request.getParameter("message");

        try (PreparedStatement pstmt = conn.prepareStatement("INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)")) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, receiverId);
            pstmt.setString(3, message);
            pstmt.executeUpdate();

            content.append("<p>Сообщение успешно отправлено!</p>");
        } catch (SQLException e) {
            content.append("<p>Ошибка при отправке сообщения: ").append(e.getMessage()).append("</p>");
        }
    }
} catch (SQLException e) {
    content.append("<p>Ошибка: ").append(e.getMessage()).append("</p>");
}
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Личный кабинет</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<style>
    .course-button-container {
        margin: 20px 0; 
    }
    form {
        background-color: #f9f9f9; 
        padding: 20px; 
        border: 1px solid #ddd; 
        border-radius: 8px; 
        margin: 20px 0; 
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
    }

    form label {
        display: block; 
        font-weight: bold; 
        margin: 10px 0 5px; 
    }

    form input[type="number"],
    form textarea {
        width: 98%; 
        padding: 10px; 
        border: 1px solid #ccc;
        border-radius: 4px; 
        font-size: 16px; 
        margin-bottom: 15px; 
    }
</style>
<body>
<div class="center">
    <header>
        <h1>Добро пожаловать, <%= userName %>!</h1>
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
