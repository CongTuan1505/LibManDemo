<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.UserDAO8, module.User8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    String error = null;
    if ("POST".equals(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            error = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            try {
                User8 u = new UserDAO8().login8(username.trim(), password);
                if (u == null) {
                    error = "Sai tên đăng nhập hoặc mật khẩu.";
                } else if (User8.ROLE_READER.equals(u.getRole())) {
                    session.setAttribute("currentUser", u);
                    response.sendRedirect(ctx + "/view/BanDoc/MainReaderPage8.jsp");
                    return;
                } else if (User8.ROLE_LIBRARIAN.equals(u.getRole())) {
                    session.setAttribute("currentUser", u);
                    response.sendRedirect(ctx + "/view/NhanVienThuVien/MainLibrarianPage8.jsp");
                    return;
                } else {
                    error = "Vai trò không được hỗ trợ.";
                }
            } catch (Exception e) {
                error = "Lỗi kết nối CSDL: " + e.getMessage();
            }
        }
    }
    request.setAttribute("error", error);
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>LibMan - Đăng nhập</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body class="login-page"><div class="box login-box">
<h2>LibMan</h2>
<p class="muted intro">Đăng nhập để sử dụng thư viện.</p>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<form method="post" action="LoginPage8.jsp">
  <div class="row"><label for="username">Tên đăng nhập</label><input id="username" type="text" name="username" autocomplete="username" required></div>
  <div class="row"><label for="password">Mật khẩu</label><input id="password" type="password" name="password" autocomplete="current-password" required></div>
  <button type="submit">Đăng nhập</button>
</form>
<p class="muted demo">Demo: reader1 / librarian1, mật khẩu 123456</p>
</div></body></html>
