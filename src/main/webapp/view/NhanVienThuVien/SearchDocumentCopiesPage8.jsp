<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentCopyDAO8, module.DocumentCopy8, java.util.*" %>
<% String requiredRole = "LIBRARIAN"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    if (session.getAttribute("borrowReader") == null) {
        response.sendRedirect("SelectReaderPage8.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<DocumentCopy8> chosen = (List<DocumentCopy8>) session.getAttribute("borrowCopies");
    if (chosen == null) {
        chosen = new ArrayList<DocumentCopy8>();
        session.setAttribute("borrowCopies", chosen);
    }
    DocumentCopyDAO8 copyDAO = new DocumentCopyDAO8();
    String error = null;

    if ("POST".equals(request.getMethod())) {
        // Scenario 3.0 buoc 40-48: chon ban sao -> checkAvailable8 -> them vao danh sach muon
        String[] ids = request.getParameterValues("copyId");
        StringBuilder err = new StringBuilder();
        int added = 0;
        try {
            if (ids == null || ids.length == 0) {
                err.append("Chưa chọn bản sao nào. ");
            } else {
                for (String id : ids) {
                    DocumentCopy8 cp = copyDAO.getCopyByCode8(id);
                    boolean dup = false;
                    for (DocumentCopy8 x : chosen) { if (x.getCopyId().equals(id)) dup = true; }
                    if (cp == null) err.append("Không tìm thấy bản sao ").append(id).append(". ");
                    else if (dup) err.append("Bản sao ").append(id).append(" đã có trong danh sách. ");
                    else if (!copyDAO.checkAvailable8(id)) err.append("Bản sao ").append(id).append(" đang được mượn. ");
                    else { chosen.add(cp); added++; }
                }
            }
        } catch (Exception e) {
            err.append("Lỗi truy vấn dữ liệu: ").append(e.getMessage());
        }
        if (err.length() > 0) session.setAttribute("flashError", err.toString().trim());
        if (added > 0) session.setAttribute("flashOk", "Đã thêm " + added + " bản sao vào danh sách mượn.");
        response.sendRedirect("BorrowDocumentsPage8.jsp");
        return;
    }

    // GET: ?documentId=...  (tat ca ban sao cua tai lieu)  hoac  ?copyId=...  (tra cuu theo ma ban sao)
    String documentId = request.getParameter("documentId");
    String copyCode = request.getParameter("copyCode");
    List<DocumentCopy8> list = new ArrayList<DocumentCopy8>();
    try {
        if (copyCode != null && !copyCode.trim().isEmpty()) {
            DocumentCopy8 cp = copyDAO.getCopyByCode8(copyCode.trim());
            if (cp == null) error = "Không tìm thấy bản sao " + copyCode.trim() + ".";
            else list.add(cp);
        } else if (documentId != null && !documentId.trim().isEmpty()) {
            list = copyDAO.getCopiesByDocument8(documentId.trim());
            if (list.isEmpty()) error = "Tài liệu này chưa có bản sao.";
        }
    } catch (Exception e) {
        error = "Lỗi truy vấn dữ liệu: " + e.getMessage();
    }
    request.setAttribute("error", error);
    request.setAttribute("list", list);
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Tra cứu bản sao</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Tra cứu bản sao</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<form method="get" action="SearchDocumentCopiesPage8.jsp">
  Mã bản sao: <input type="text" name="copyCode" value="<c:out value='${param.copyCode}'/>">
  <button type="submit">Tra cứu</button>
</form>
<c:if test="${not empty list}">
<form method="post" action="SearchDocumentCopiesPage8.jsp">
<table>
<tr><th>TT</th><th>Mã bản sao</th><th>Tên tài liệu</th><th>Trạng thái</th><th>Chọn</th><th>Chi tiết</th></tr>
<c:forEach var="cp" items="${list}" varStatus="st">
<tr><td>${st.count}</td><td><c:out value="${cp.copyId}"/></td><td><c:out value="${cp.document.title}"/></td>
    <td><c:out value="${cp.status == 'AVAILABLE' ? 'Có sẵn' : 'Đang mượn'}"/></td>
    <td><input type="checkbox" name="copyId" value="<c:out value='${cp.copyId}'/>" ${cp.status == 'AVAILABLE' ? '' : 'disabled'}></td>
    <td><a href="DocumentCopyDetailsPage8.jsp?copyId=<c:out value='${cp.copyId}'/>&back=<c:out value='${param.documentId}'/>">Xem</a></td></tr>
</c:forEach>
</table>
<button type="submit">Thêm bản sao</button>
</form>
</c:if>
<div class="bar"><a class="btn" href="BorrowDocumentsPage8.jsp">Quay lại</a></div>
</div></body></html>
