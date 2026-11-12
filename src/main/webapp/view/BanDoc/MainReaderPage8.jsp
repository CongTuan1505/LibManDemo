<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String requiredRole = "READER"; %>
<%@ include file="../common/Auth8.jspf" %>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Trang chủ bạn đọc</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Trang chủ bạn đọc</h2>
<p>Xin chào, <b><c:out value="${sessionScope.currentUser.fullName}"/></b></p>
<div class="bar">
  <a class="btn" href="SearchDocumentPage8.jsp">Tìm tài liệu</a>
  <a class="btn" href="${pageContext.request.contextPath}/view/LogoutPage8.jsp">Đăng xuất</a>
</div>
</div></body></html>
