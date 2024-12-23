document.addEventListener('DOMContentLoaded', function() {
    // Обработчик для кнопки "Войти или зарегистрироваться"
    const loginRegisterBtn = document.getElementById('loginRegisterBtn');
    const formContainer = document.querySelector('.form-container');
    const profileActions = document.getElementById('profile-actions');
    const logoutBtn = document.getElementById('logoutBtn');
    const coursesBtn = document.getElementById('coursesBtn');
    const progressBtn = document.getElementById('progressBtn');
    const teacherCoursesBtn = document.getElementById('teacherCoursesBtn');
    const teacherProgressBtn = document.getElementById('teacherProgressBtn');

    // Если пользователь уже вошел, скрываем форму входа/регистрации
    if (loginRegisterBtn && !formContainer) {
        loginRegisterBtn.style.display = 'none';
    }

    // Показать/скрыть форму регистрации/входа
    if (loginRegisterBtn) {
        loginRegisterBtn.addEventListener('click', function() {
            formContainer.style.display = 'block';  // Показываем форму
        });
    }

    // Обработчик для выхода из профиля
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function() {
            // Очистка сессии (в случае, если используете сессию)
            window.location.href = 'logout.jsp'; // Перенаправление на страницу выхода
        });
    }

    // Показать элементы для пользователя (ученик/учитель)
    if (profileActions && coursesBtn && progressBtn && teacherCoursesBtn && teacherProgressBtn) {
        if (profileActions.style.display === 'none') {
            profileActions.style.display = 'block'; // Показываем панель профиля
        }

        // В зависимости от роли показываем соответствующие кнопки
        if (coursesBtn) {
            coursesBtn.style.display = 'block';
        }
        if (progressBtn) {
            progressBtn.style.display = 'block';
        }
        if (teacherCoursesBtn) {
            teacherCoursesBtn.style.display = 'block';
        }
        if (teacherProgressBtn) {
            teacherProgressBtn.style.display = 'block';
        }
    }
});