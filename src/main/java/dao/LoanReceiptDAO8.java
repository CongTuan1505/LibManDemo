package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

import module.Document8;
import module.DocumentCopy8;
import module.Librarian8;
import module.LoanDetail8;
import module.LoanReceipt8;
import module.Reader8;

public class LoanReceiptDAO8 extends DAO8 {

    private final LoanDetailDAO8 loanDetailDAO = new LoanDetailDAO8();
    private final DocumentCopyDAO8 documentCopyDAO = new DocumentCopyDAO8();

    /** Loi nghiep vu (ban sao khong hop le, danh sach rong...) khac voi loi SQL. */
    public static class LoanException extends Exception {
        private static final long serialVersionUID = 1L;

        public LoanException(String message) {
            super(message);
        }
    }

    /**
     * Scenario 3.0 buoc 52-64: luu phieu muon + chi tiet + cap nhat trang thai ban sao
     * trong MOT giao dich (commit het hoac rollback het).
     *
     * @return loanId vua tao
     */
    public long saveLoanWithDetails8(LoanReceipt8 receipt) throws SQLException, LoanException {
        if (receipt.getLoanDetails() == null || receipt.getLoanDetails().isEmpty()) {
            throw new LoanException("Danh sách mượn chưa có bản sao nào.");
        }
        try (Connection c = connection()) {
            c.setAutoCommit(false);
            try {
                // 1. Kiem tra lai tung ban sao (khoa dong de tranh hai nhan vien cung muon)
                for (LoanDetail8 d : receipt.getLoanDetails()) {
                    String copyId = d.getDocumentCopy().getCopyId();
                    if (!documentCopyDAO.lockAndCheckAvailable8(c, copyId)) {
                        throw new LoanException("Bản sao " + copyId + " không còn sẵn để mượn.");
                    }
                }
                // 2. Phieu muon
                long loanId;
                String sql = "INSERT INTO tblLoanReceipt8 (readerUserId, staffUserId, loanDate, status) VALUES (?,?,?,?)";
                try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setLong(1, receipt.getReader().getUserId());
                    ps.setLong(2, receipt.getLibrarian().getUserId());
                    LocalDate date = receipt.getLoanDate() != null ? receipt.getLoanDate() : LocalDate.now();
                    ps.setDate(3, Date.valueOf(date));
                    ps.setString(4, LoanReceipt8.STATUS_CONFIRMED);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        keys.next();
                        loanId = keys.getLong(1);
                    }
                }
                // 3. Chi tiet phieu muon
                loanDetailDAO.createLoanDetails8(c, loanId, receipt.getLoanDetails());
                // 4. Cap nhat trang thai ban sao -> BORROWED
                for (LoanDetail8 d : receipt.getLoanDetails()) {
                    documentCopyDAO.updateCopyStatus8(c, d.getDocumentCopy().getCopyId(), DocumentCopy8.STATUS_BORROWED);
                }
                c.commit();
                return loanId;
            } catch (SQLException | LoanException | RuntimeException e) {
                c.rollback();
                throw e;
            }
        }
    }

    /** Doc phieu muon + danh sach ban sao (dung cho LoanDetailsPage8). */
    public LoanReceipt8 getLoanById8(long loanId) throws SQLException {
        String head = "SELECT l.loanId, l.loanDate, l.status, "
                + "r.userId AS readerUserId, r.readerCode, r.fullName AS readerName, "
                + "s.userId AS staffUserId, s.staffCode, s.fullName AS staffName "
                + "FROM tblLoanReceipt8 l "
                + "JOIN tblReader8 r ON r.userId = l.readerUserId "
                + "JOIN tblLibrarian8 s ON s.userId = l.staffUserId WHERE l.loanId = ?";
        String lines = "SELECT ld.loanDetailId, c.copyId, c.status, d.documentId, d.title "
                + "FROM tblLoanDetail8 ld JOIN tblDocumentCopy8 c ON c.copyId = ld.copyId "
                + "JOIN tblDocument8 d ON d.documentId = c.documentId "
                + "WHERE ld.loanId = ? ORDER BY ld.loanDetailId";
        try (Connection c = connection()) {
            LoanReceipt8 receipt;
            try (PreparedStatement ps = c.prepareStatement(head)) {
                ps.setLong(1, loanId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;
                    }
                    receipt = new LoanReceipt8();
                    receipt.setLoanId(rs.getLong("loanId"));
                    receipt.setLoanDate(rs.getDate("loanDate").toLocalDate());
                    receipt.setStatus(rs.getString("status"));
                    Reader8 reader = new Reader8();
                    reader.setUserId(rs.getLong("readerUserId"));
                    reader.setReaderId(rs.getString("readerCode"));
                    reader.setFullName(rs.getString("readerName"));
                    receipt.setReader(reader);
                    Librarian8 staff = new Librarian8();
                    staff.setUserId(rs.getLong("staffUserId"));
                    staff.setStaffId(rs.getString("staffCode"));
                    staff.setFullName(rs.getString("staffName"));
                    receipt.setLibrarian(staff);
                }
            }
            try (PreparedStatement ps = c.prepareStatement(lines)) {
                ps.setLong(1, loanId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LoanDetail8 ld = new LoanDetail8();
                        ld.setLoanDetailId(rs.getLong("loanDetailId"));
                        DocumentCopy8 cp = new DocumentCopy8();
                        cp.setCopyId(rs.getString("copyId"));
                        cp.setStatus(rs.getString("status"));
                        Document8 doc = new Document8();
                        doc.setDocumentId(rs.getString("documentId"));
                        doc.setTitle(rs.getString("title"));
                        cp.setDocument(doc);
                        ld.setDocumentCopy(cp);
                        ld.setLoanReceipt(receipt);
                        receipt.getLoanDetails().add(ld);
                    }
                }
            }
            return receipt;
        }
    }
}
