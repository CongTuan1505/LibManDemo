package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import module.Document8;
import module.DocumentCopy8;

public class DocumentCopyDAO8 extends DAO8 {

    private static final String SELECT_BASE =
            "SELECT c.copyId, c.status, d.documentId, d.title "
          + "FROM tblDocumentCopy8 c JOIN tblDocument8 d ON c.documentId = d.documentId ";

    /** Scenario 3.0 buoc 24: lay danh sach ban sao cua mot tai lieu. */
    public List<DocumentCopy8> getCopiesByDocument8(String documentId) throws SQLException {
        List<DocumentCopy8> list = new ArrayList<>();
        try (Connection c = connection();
             PreparedStatement ps = c.prepareStatement(SELECT_BASE + "WHERE c.documentId = ? ORDER BY c.copyId")) {
            ps.setString(1, documentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    /** Scenario 3.0 buoc 33: tim ban sao theo ma ban sao (quet / nhap). */
    public DocumentCopy8 getCopyByCode8(String copyId) throws SQLException {
        try (Connection c = connection();
             PreparedStatement ps = c.prepareStatement(SELECT_BASE + "WHERE c.copyId = ?")) {
            ps.setString(1, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /** Scenario 3.0 buoc 42: ban sao co san (AVAILABLE) hay khong. */
    public boolean checkAvailable8(String copyId) throws SQLException {
        try (Connection c = connection();
             PreparedStatement ps = c.prepareStatement("SELECT status FROM tblDocumentCopy8 WHERE copyId = ?")) {
            ps.setString(1, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && DocumentCopy8.STATUS_AVAILABLE.equals(rs.getString(1));
            }
        }
    }

    /** So ban sao con san cua mot tai lieu (hien thi o DocumentDetailsPage8). */
    public int countAvailableCopies8(String documentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM tblDocumentCopy8 WHERE documentId = ? AND status = ?";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, documentId);
            ps.setString(2, DocumentCopy8.STATUS_AVAILABLE);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    /**
     * Khoa ban ghi (SELECT ... FOR UPDATE) va kiem tra con AVAILABLE.
     * Goi trong giao dich cua LoanReceiptDAO8.saveLoanWithDetails8.
     */
    public boolean lockAndCheckAvailable8(Connection c, String copyId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT status FROM tblDocumentCopy8 WHERE copyId = ? FOR UPDATE")) {
            ps.setString(1, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && DocumentCopy8.STATUS_AVAILABLE.equals(rs.getString(1));
            }
        }
    }

    /** Scenario 3.0 buoc 62: cap nhat trang thai ban sao (dung chung ket noi/giao dich da mo). */
    public void updateCopyStatus8(Connection c, String copyId, String status) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement("UPDATE tblDocumentCopy8 SET status = ? WHERE copyId = ?")) {
            ps.setString(1, status);
            ps.setString(2, copyId);
            ps.executeUpdate();
        }
    }

    public void updateCopyStatus8(String copyId, String status) throws SQLException {
        try (Connection c = connection()) {
            updateCopyStatus8(c, copyId, status);
        }
    }

    private DocumentCopy8 map(ResultSet rs) throws SQLException {
        DocumentCopy8 cp = new DocumentCopy8();
        cp.setCopyId(rs.getString("copyId"));
        cp.setStatus(rs.getString("status"));
        Document8 d = new Document8();
        d.setDocumentId(rs.getString("documentId"));
        d.setTitle(rs.getString("title"));
        cp.setDocument(d);
        return cp;
    }
}
