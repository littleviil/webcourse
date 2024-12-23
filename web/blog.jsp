<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Блог</title>
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

    <h1>Добро пожаловать в наш Блог!</h1>
    <p>Здесь вы можете узнать о новых курсах, событиях и обновлениях на нашей образовательной платформе.</p>

    <div class="blog-posts">
        <h2>Последние новости:</h2>
        <ul>
            <li><strong>Обновление курса по Java</strong>: Мы добавили новые практические задания для студентов.</li>
            <li><strong>Новый курс по Python</strong>: Начните изучать Python с нуля! Все уроки доступны онлайн.</li>
            <li><strong>Курс по веб-разработке</strong>: Новый модуль по созданию динамических веб-приложений с использованием JavaScript.</li>
        </ul>
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
