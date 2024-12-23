<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Завершаем текущую сессию
    session.invalidate();
    response.sendRedirect("index.jsp");
%>