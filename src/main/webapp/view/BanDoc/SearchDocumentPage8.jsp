<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentDAO8, module.Document8, java.util.List" %>
<% String requiredRole = "READER"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    // Scenario 3.0 buoc 4-10: nhap tu khoa -> DocumentDAO8.getDocumentsByKeyword8 -> chuyen sang DocumentResultPage8
    String error = null;
    if ("POST".equals(request.getMethod())) {
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            error = "Vui lòng nhập tên tài liệu cần tìm.";
        } else {
            try {
                keyword = keyword.trim();
                List<Document8> documents = new DocumentDAO8().getDocumentsByKeyword8(keyword);
                session.setAttribute("lastKeyword", keyword);
                request.setAttribute("keyword", keyword);
                request.setAttribute("documents", documents);
%>
<jsp:forward page="DocumentResultPage8.jsp"/>
<%
                return;
            } catch (Exception e) {
                error = "Lỗi truy vấn dữ liệu: " + e.getMessage();
            }
        }
    }
    request.setAttribute("error", error);
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Tìm tài liệu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Tìm tài liệu</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<form method="post" action="SearchDocumentPage8.jsp">
  Từ khóa: <input type="text" name="keyword" value="<c:out value='${param.keyword}'/>">
  <button type="submit">Tìm kiếm</button>
</form>
<div class="bar"><a class="btn" href="MainReaderPage8.jsp">Về trang chủ</a></div>
</div></body></html>
