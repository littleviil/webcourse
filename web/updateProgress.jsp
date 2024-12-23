<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = Integer.parseInt(request.getParameter("studentId"));
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    boolean isProgressCompleted = "1".equals(request.getParameter("progress")); // true, если галочка была установлена

    String url = "jdbc:mysql://localhost:3306/courses_platform";
    String dbUser = "root";
    String dbPassword = "";

    try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword)) {
        // Обновляем прогресс в базе данных
        String updateProgressQuery = "UPDATE student_courses SET progress = ? WHERE student_id = ? AND course_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(updateProgressQuery)) {
            pstmt.setInt(1, isProgressCompleted ? 100 : 0);  // Устанавливаем 100% если прогресс завершен
            pstmt.setInt(2, studentId);
            pstmt.setInt(3, courseId);
            pstmt.executeUpdate();

            response.sendRedirect("courseDetails.jsp?courseId=" + courseId); // Перенаправляем обратно на страницу курса
        }
    } catch (SQLException e) {
        out.println("<p>Ошибка: ").append(e.getMessage()).append("</p>");
    }
%>
