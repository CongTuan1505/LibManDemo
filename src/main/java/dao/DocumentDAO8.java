package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import module.Document8;
import module.DocumentType8;

public class DocumentDAO8 extends DAO8 {

    private static final String SELECT_BASE =
            "SELECT d.documentId, d.title, d.author, d.publisher, d.publishYear, d.description, "
          + "t.typeId, t.typeName, t.description AS typeDescription "
          + "FROM tblDocument8 d JOIN tblDocumentType8 t ON d.typeId = t.typeId ";

    /** Scenario 3.0 buoc 6: tim tai lieu co ten chua tu khoa. */
    public List<Document8> getDocumentsByKeyword8(String keyword) throws SQLException {
        List<Document8> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE d.title LIKE ? ESCAPE '\\\\' ORDER BY d.documentId";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + escapeLike(keyword) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    /** Lay chi tiet tai lieu theo ma (dung cho DocumentDetailsPage8 va BorrowDocumentsPage8). */
    public Document8 getDocumentById8(String documentId) throws SQLException {
        String sql = SELECT_BASE + "WHERE d.documentId = ?";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, documentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    private static String escapeLike(String s) {
        return s.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }

    private Document8 map(ResultSet rs) throws SQLException {
        Document8 d = new Document8();
        d.setDocumentId(rs.getString("documentId"));
        d.setTitle(rs.getString("title"));
        d.setAuthor(rs.getString("author"));
        d.setPublisher(rs.getString("publisher"));
        int year = rs.getInt("publishYear");
        d.setPublishYear(rs.wasNull() ? null : year);
        d.setDescription(rs.getString("description"));
        DocumentType8 t = new DocumentType8();
        t.setTypeId(rs.getLong("typeId"));
        t.setTypeName(rs.getString("typeName"));
        t.setDescription(rs.getString("typeDescription"));
        d.setDocumentType(t);
        return d;
    }
}
