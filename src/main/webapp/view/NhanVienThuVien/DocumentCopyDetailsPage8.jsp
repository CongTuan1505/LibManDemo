<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentCopyDAO8, module.DocumentCopy8" %>
<% String requiredRole = "LIBRARIAN"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    try {
        String copyId = request.getParameter("copyId");
        DocumentCopy8 cp = copyId == null ? null : new DocumentCopyDAO8().getCopyByCode8(copyId);
        if (cp == null) request.setAttribute("error", "Không tìm thấy bản sao.");
        else request.setAttribute("cp", cp);
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
    }
    String back = request.getParameter("back");
    request.setAttribute("backUrl", "SearchDocumentCopiesPage8.jsp"
            + (back != null && !back.isEmpty() ? "?documentId=" + java.net.URLEncoder.encode(back, "UTF-8") : ""));
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Chi tiết bản sao</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Chi tiết bản sao</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<c:if test="${not empty cp}">
<table style="width:auto">
<tr><th>Mã bản sao</th><td><c:out value="${cp.copyId}"/></td></tr>
<tr><th>Mã tài liệu</th><td><c:out value="${cp.document.documentId}"/></td></tr>
<tr><th>Tên tài liệu</th><td><c:out value="${cp.document.title}"/></td></tr>
<tr><th>Trạng thái</th><td><c:out value="${cp.status == 'AVAILABLE' ? 'Có sẵn' : 'Đang mượn'}"/></td></tr>
</table>
</c:if>
<div class="bar"><a class="btn" href="<c:out value='${backUrl}'/>">Quay lại</a></div>
</div></body></html>
