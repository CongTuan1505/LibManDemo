<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.DocumentDAO8, dao.LoanReceiptDAO8, module.*, java.time.LocalDate, java.util.*" %>
<% String requiredRole = "LIBRARIAN"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    Reader8 reader = (Reader8) session.getAttribute("borrowReader");
    if (reader == null) {
        response.sendRedirect("SelectReaderPage8.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<DocumentCopy8> copies = (List<DocumentCopy8>) session.getAttribute("borrowCopies");
    if (copies == null) {
        copies = new ArrayList<DocumentCopy8>();
        session.setAttribute("borrowCopies", copies);
    }
    String error = (String) session.getAttribute("flashError");
    String ok = (String) session.getAttribute("flashOk");
    session.removeAttribute("flashError");
    session.removeAttribute("flashOk");

    if ("POST".equals(request.getMethod())) {
        String action = request.getParameter("action");
        try {
            if ("lookup".equals(action)) {
                // Scenario 3.0 buoc 15-22: nhap ma tai lieu -> DocumentDAO8.getDocumentById8 -> trang tra cuu ban sao
                String documentId = request.getParameter("documentId");
                if (documentId == null || documentId.trim().isEmpty()) {
                    error = "Vui lòng nhập mã tài liệu.";
                } else if (new DocumentDAO8().getDocumentById8(documentId.trim()) == null) {
                    error = "Không tìm thấy tài liệu có mã " + documentId.trim() + ".";
                } else {
                    response.sendRedirect("SearchDocumentCopiesPage8.jsp?documentId="
                            + java.net.URLEncoder.encode(documentId.trim(), "UTF-8"));
                    return;
                }
            } else if ("remove".equals(action)) {
                String copyId = request.getParameter("copyId");
                for (Iterator<DocumentCopy8> it = copies.iterator(); it.hasNext();) {
                    if (it.next().getCopyId().equals(copyId)) { it.remove(); }
                }
            } else if ("submit".equals(action)) {
                // Scenario 3.0 buoc 50-65: LoanReceiptDAO8.saveLoanWithDetails8 (1 giao dich)
                if (copies.isEmpty()) {
                    error = "Danh sách mượn chưa có bản sao nào. Hãy thêm ít nhất một bản sao.";
                } else {
                    LoanReceipt8 receipt = new LoanReceipt8();
                    receipt.setReader(reader);
                    receipt.setLibrarian((Librarian8) currentUser);
                    receipt.setLoanDate(LocalDate.now());
                    for (DocumentCopy8 cp : copies) {
                        LoanDetail8 d = new LoanDetail8();
                        d.setDocumentCopy(cp);
                        d.setLoanReceipt(receipt);
                        receipt.getLoanDetails().add(d);
                    }
                    try {
                        long loanId = new LoanReceiptDAO8().saveLoanWithDetails8(receipt);
                        session.removeAttribute("borrowCopies");
                        session.removeAttribute("borrowReader");
                        response.sendRedirect("LoanDetailsPage8.jsp?loanId=" + loanId);
                        return;
                    } catch (LoanReceiptDAO8.LoanException ex) {
                        error = ex.getMessage();
                    }
                }
            }
        } catch (Exception e) {
            error = "Lỗi xử lý: " + e.getMessage();
        }
    }
    request.setAttribute("error", error);
    request.setAttribute("ok", ok);
    request.setAttribute("reader", reader);
    request.setAttribute("copies", copies);
    request.setAttribute("today", LocalDate.now());
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Cho mượn tài liệu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Cho mượn tài liệu</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<c:if test="${not empty ok}"><div class="ok"><c:out value="${ok}"/></div></c:if>
<p>Mã bạn đọc: <b><c:out value="${reader.readerId}"/></b> &nbsp; Họ tên: <b><c:out value="${reader.fullName}"/></b>
   &nbsp; Thẻ: <b><c:out value="${reader.libraryCard.cardId}"/></b> &nbsp; Ngày mượn: <b>${today}</b></p>

<form method="post" action="BorrowDocumentsPage8.jsp">
  <input type="hidden" name="action" value="lookup">
  Mã tài liệu: <input type="text" name="documentId">
  <button type="submit">Tra cứu</button>
</form>

<h3>Danh sách bản sao mượn</h3>
<table>
<tr><th>TT</th><th>Mã bản sao</th><th>Mã tài liệu</th><th>Tên tài liệu</th><th>Xóa</th></tr>
<c:forEach var="cp" items="${copies}" varStatus="st">
<tr><td>${st.count}</td><td><c:out value="${cp.copyId}"/></td>
    <td><c:out value="${cp.document.documentId}"/></td><td><c:out value="${cp.document.title}"/></td>
    <td><form method="post" action="BorrowDocumentsPage8.jsp" style="margin:0">
        <input type="hidden" name="action" value="remove">
        <input type="hidden" name="copyId" value="<c:out value='${cp.copyId}'/>">
        <button type="submit">Xóa</button></form></td></tr>
</c:forEach>
<c:if test="${empty copies}"><tr><td colspan="5" class="muted">Chưa có bản sao nào.</td></tr></c:if>
</table>

<div class="bar">
  <a class="btn" href="MainLibrarianPage8.jsp">Về trang chủ</a>
  <a class="btn" href="SearchDocumentCopiesPage8.jsp">Tra cứu bản sao theo mã</a>
  <form method="post" action="BorrowDocumentsPage8.jsp" style="display:inline">
    <input type="hidden" name="action" value="submit">
    <button type="submit">Lập phiếu mượn (Submit)</button>
  </form>
</div>
</div></body></html>
