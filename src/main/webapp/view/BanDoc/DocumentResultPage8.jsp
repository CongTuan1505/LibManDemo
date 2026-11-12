<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentDAO8, module.Document8, java.util.List" %>
<% String requiredRole = "READER"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    // Vao truc tiep (nut "Quay lai" tu trang chi tiet) -> tim lai theo tu khoa da luu trong session
    if (request.getAttribute("documents") == null) {
        String kw = (String) session.getAttribute("lastKeyword");
        if (kw == null) {
            response.sendRedirect("SearchDocumentPage8.jsp");
            return;
        }
        try {
            request.setAttribute("documents", new DocumentDAO8().getDocumentsByKeyword8(kw));
            request.setAttribute("keyword", kw);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Kết quả tìm kiếm</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Kết quả tìm kiếm</h2>
<p class="muted">Từ khóa: <b><c:out value="${keyword}"/></b></p>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<c:choose>
<c:when test="${empty documents}">
  <p>Không tìm thấy tài liệu phù hợp. Bạn có thể tìm lại với từ khóa khác.</p>
</c:when>
<c:otherwise>
<table>
<tr><th>TT</th><th>Mã tài liệu</th><th>Tên tài liệu</th><th>Loại tài liệu</th><th>Tác giả</th><th>Xem</th></tr>
<c:forEach var="d" items="${documents}" varStatus="st">
<tr>
  <td>${st.count}</td>
  <td><c:out value="${d.documentId}"/></td>
  <td><c:out value="${d.title}"/></td>
  <td><c:out value="${d.documentType.typeName}"/></td>
  <td><c:out value="${d.author}"/></td>
  <td><a href="DocumentDetailsPage8.jsp?documentId=<c:out value='${d.documentId}'/>">Xem chi tiết</a></td>
</tr>
</c:forEach>
</table>
</c:otherwise>
</c:choose>
<div class="bar">
  <a class="btn" href="MainReaderPage8.jsp">Về trang chủ</a>
  <a class="btn" href="SearchDocumentPage8.jsp">Tìm kiếm mới</a>
</div>
</div></body></html>
