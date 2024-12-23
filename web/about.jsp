<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>О нас</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="center">
    <header>
        <div class="logo">
            <img src="css/images/logo.png" alt="Логотип"></img>
            <h1 class="title_header">Образовательная Платформа</h1>
        </div>
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

    <div class="info">
    <h1>О нашей платформе</h1>
    <p>Мы создаем инновационную образовательную платформу, которая позволяет студентам и учителям легко и удобно обучаться и преподавать онлайн. Наша цель — предоставить доступ к качественным курсам для всех.</p>

    <h2>Наша миссия</h2>
    <p>Мы стремимся изменить традиционное образование, сделав его доступным для всех людей по всему миру, независимо от их местоположения.</p>

    <h2>Команда</h2>
    <p>Мы — команда опытных педагогов, разработчиков и дизайнеров, работающих для того, чтобы создать лучший образовательный опыт для вас!</p>
</div>
</div>

<script src="js/script.js"></script>
<script>
    document.getElementById('logoutBtn').addEventListener('click', function() {
        window.location.href = 'logout.jsp';
    });
</script>
</body>
</html>
