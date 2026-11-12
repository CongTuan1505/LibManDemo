<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.LoanReceiptDAO8, module.LoanReceipt8" %>
<% String requiredRole = "LIBRARIAN"; %>
<%@ include file="../common/Auth8.jspf" %>
<%
    try {
        long loanId = Long.parseLong(request.getParameter("loanId"));
        LoanReceipt8 loan = new LoanReceiptDAO8().getLoanById8(loanId);
        if (loan == null) {
            request.setAttribute("error", "Không tìm thấy phiếu mượn.");
        } else {
            request.setAttribute("loan", loan);
            request.setAttribute("dueDate", loan.getLoanDate().plusDays(14)); // han tra = ngay muon + 14 ngay
        }
    } catch (Exception e) {
        request.setAttribute("error", "Không đọc được phiếu mượn: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Chi tiết phiếu mượn</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/Style8.css"></head>
<body><div class="box">
<h2>Chi tiết phiếu mượn</h2>
<c:if test="${not empty error}"><div class="err"><c:out value="${error}"/></div></c:if>
<c:if test="${not empty loan}">
<div class="ok noprint">Tạo phiếu mượn thành công.</div>
<table style="width:auto">
<tr><th>Mã phiếu mượn</th><td>PM<c:out value="${loan.loanId}"/></td></tr>
<tr><th>Mã bạn đọc</th><td><c:out value="${loan.reader.readerId}"/></td></tr>
<tr><th>Họ tên</th><td><c:out value="${loan.reader.fullName}"/></td></tr>
<tr><th>Nhân viên lập phiếu</th><td><c:out value="${loan.librarian.staffId}"/> - <c:out value="${loan.librarian.fullName}"/></td></tr>
<tr><th>Ngày mượn</th><td>${loan.loanDate}</td></tr>
<tr><th>Hạn trả</th><td>${dueDate}</td></tr>
<tr><th>Trạng thái</th><td><c:out value="${loan.status == 'CONFIRMED' ? 'Đã xác nhận' : loan.status}"/></td></tr>
</table>
<table>
<tr><th>TT</th><th>Mã bản sao</th><th>Tên tài liệu</th></tr>
<c:forEach var="d" items="${loan.loanDetails}" varStatus="st">
<tr><td>${st.count}</td><td><c:out value="${d.documentCopy.copyId}"/></td><td><c:out value="${d.documentCopy.document.title}"/></td></tr>
</c:forEach>
</table>
</c:if>
<div class="bar noprint">
  <button type="button" onclick="window.print()">In phiếu mượn</button>
  <a class="btn" href="MainLibrarianPage8.jsp">Về trang chủ</a>
</div>
</div></body></html>
