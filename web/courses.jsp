<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Курсы</title>
    <link rel="stylesheet" href="css/style.css">
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
                <li><a href="courses.jsp">Курсы</a></li>
            </ul>
        </nav>
    </header>

    <div class="courses">
        <h1>Все курсы</h1>

        <!-- Имитируем список курсов в JSP -->
        <%
            // Создаем массив курсов для имитации данных
            String[][] courses = {
                {"1", "Курс по Java", "Изучите основы программирования на Java.", "85"},
                {"2", "Курс по Python", "Основы программирования на Python.", "90"},
                {"3", "Курс по веб-разработке", "Создание сайтов с использованием HTML, CSS и JavaScript.", "75"}
            };

            // Цикл для отображения всех курсов
            for (int i = 0; i < courses.length; i++) {
                String courseId = courses[i][0];
                String courseName = courses[i][1];
                String courseDescription = courses[i][2];
                String passRate = courses[i][3];
        %>

        <div class="course-card">
            <h2><%= courseName %></h2>
            <p><%= courseDescription %></p>
            <p><strong>Успеваемость ученика: </strong> <%= passRate %>%</p>
            <a href="course-details.jsp?courseId=<%= courseId %>">Подробнее</a>
        </div>

        <%
            }
        %>
    </div>
</div>

<script src="js/script.js"></script>
</body>
</html>
