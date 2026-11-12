<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentDAO8, dao.DocumentCopyDAO8, module.Document8, module.DocumentCopy8, java.util.List" %>
<% String requiredRole = "READER"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    String documentId = request.getParameter("documentId");
    try {
        Document8 doc = documentId == null ? null : new DocumentDAO8().getDocumentById8(documentId);
        if (doc == null) {
            request.setAttribute("error", "Không tìm thấy thông tin chi tiết tài liệu.");
        } else {
            DocumentCopyDAO8 copyDAO = new DocumentCopyDAO8();
            List<DocumentCopy8> copies = copyDAO.getCopiesByDocument8(documentId);
            request.setAttribute("doc", doc);
            request.setAttribute("copies", copies);
            request.setAttribute("availableCount", copyDAO.countAvailableCopies8(documentId));
        }
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi truy vấn dữ liệu: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Chi tiết tài liệu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Chi tiết tài liệu</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<c:if test="${not empty doc}">
<table style="width:auto">
<tr><th>Mã tài liệu</th><td><c:out value="${doc.documentId}"/></td></tr>
<tr><th>Tên tài liệu</th><td><c:out value="${doc.title}"/></td></tr>
<tr><th>Tác giả</th><td><c:out value="${doc.author}"/></td></tr>
<tr><th>Loại tài liệu</th><td><c:out value="${doc.documentType.typeName}"/></td></tr>
<tr><th>Nhà xuất bản</th><td><c:out value="${doc.publisher}"/></td></tr>
<tr><th>Năm xuất bản</th><td><c:out value="${doc.publishYear}"/></td></tr>
<tr><th>Mô tả</th><td><c:out value="${doc.description}"/></td></tr>
<tr><th>Số bản sao có sẵn</th><td>${availableCount} / ${copies.size()}</td></tr>
</table>
<h3>Các bản sao</h3>
<table>
<tr><th>TT</th><th>Mã bản sao</th><th>Trạng thái</th></tr>
<c:forEach var="cp" items="${copies}" varStatus="st">
<tr><td>${st.count}</td><td><c:out value="${cp.copyId}"/></td>
    <td><c:out value="${cp.status == 'AVAILABLE' ? 'Có sẵn' : 'Đang mượn'}"/></td></tr>
</c:forEach>
</table>
</c:if>
<div class="bar"><a class="btn" href="DocumentResultPage8.jsp">Quay lại</a></div>
</div></body></html>
