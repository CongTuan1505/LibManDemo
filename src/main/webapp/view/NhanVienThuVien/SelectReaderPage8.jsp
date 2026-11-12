<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.ReaderDAO8, dao.LibraryCardDAO8, module.Reader8, java.util.ArrayList" %>
<% String requiredRole = "LIBRARIAN"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    // Scenario 3.0 buoc 4-13: tim ban doc theo ma the (LibraryCardDAO8) hoac ma ban doc (ReaderDAO8), xac nhan
    if ("1".equals(request.getParameter("reset"))) {
        session.removeAttribute("borrowReader");
        session.removeAttribute("borrowCopies");
        session.removeAttribute("pendingReader");
    }
    String error = null;
    if ("POST".equals(request.getMethod())) {
        String action = request.getParameter("action");
        try {
            if ("confirm".equals(action)) {
                Reader8 pending = (Reader8) session.getAttribute("pendingReader");
                if (pending == null) {
                    error = "Chưa chọn bạn đọc.";
                } else {
                    session.setAttribute("borrowReader", pending);
                    session.setAttribute("borrowCopies", new ArrayList<module.DocumentCopy8>());
                    session.removeAttribute("pendingReader");
                    response.sendRedirect("BorrowDocumentsPage8.jsp");
                    return;
                }
            } else {
                String cardId = request.getParameter("cardId");
                String readerId = request.getParameter("readerId");
                Reader8 r = null;
                if (cardId != null && !cardId.trim().isEmpty()) {
                    r = new LibraryCardDAO8().getReaderByCard8(cardId.trim());
                } else if (readerId != null && !readerId.trim().isEmpty()) {
                    r = new ReaderDAO8().getReaderById8(readerId.trim());
                } else {
                    error = "Vui lòng nhập mã thẻ hoặc mã bạn đọc.";
                }
                session.removeAttribute("pendingReader");
                if (r == null) {
                    if (error == null) error = "Không tìm thấy bạn đọc tương ứng. Vui lòng nhập lại.";
                } else if (r.getLibraryCard() == null || !r.getLibraryCard().isActive()) {
                    error = "Bạn đọc không có thẻ còn hiệu lực.";
                } else {
                    session.setAttribute("pendingReader", r);
                }
            }
        } catch (Exception e) {
            error = "Lỗi truy vấn dữ liệu: " + e.getMessage();
        }
    }
    request.setAttribute("error", error);
    request.setAttribute("reader", session.getAttribute("pendingReader"));
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Chọn bạn đọc</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Chọn bạn đọc</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<form method="post" action="SelectReaderPage8.jsp">
  <input type="hidden" name="action" value="find">
  <div class="row">Mã thẻ: <input type="text" name="cardId" value="<c:out value='${param.cardId}'/>"></div>
  <div class="row">Mã bạn đọc: <input type="text" name="readerId" value="<c:out value='${param.readerId}'/>"></div>
  <button type="submit">Tìm bạn đọc</button>
</form>
<c:if test="${not empty reader}">
<h3>Thông tin bạn đọc</h3>
<table style="width:auto">
<tr><th>Mã bạn đọc</th><td><c:out value="${reader.readerId}"/></td></tr>
<tr><th>Họ và tên</th><td><c:out value="${reader.fullName}"/></td></tr>
<tr><th>Mã thẻ</th><td><c:out value="${reader.libraryCard.cardId}"/></td></tr>
<tr><th>Trạng thái thẻ</th><td><c:out value="${reader.libraryCard.status == 'ACTIVE' ? 'Còn hiệu lực' : reader.libraryCard.status}"/></td></tr>
</table>
<form method="post" action="SelectReaderPage8.jsp">
  <input type="hidden" name="action" value="confirm">
  <button type="submit">Xác nhận &amp; vào cho mượn</button>
</form>
</c:if>
<div class="bar"><a class="btn" href="MainLibrarianPage8.jsp">Về trang chủ</a></div>
</div></body></html>
