package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import module.LibraryCard8;
import module.Reader8;
import module.User8;

public class ReaderDAO8 extends DAO8 {

    /** Cot chung de dung lai trong LibraryCardDAO8. */
    static final String SELECT_READER_WITH_CARD =
            "SELECT u.userId, u.username, u.role, r.readerCode, r.fullName, r.email, r.phone, "
          + "k.cardId, k.issueDate, k.status AS cardStatus "
          + "FROM tblReader8 r JOIN tblUser8 u ON u.userId = r.userId "
          + "LEFT JOIN tblLibraryCard8 k ON k.readerUserId = r.userId ";

    /** Scenario 3.0 buoc 6: tim ban doc theo ma ban doc (readerCode). */
    public Reader8 getReaderById8(String readerId) throws SQLException {
        // Neu co nhieu the, uu tien the dang ACTIVE (ORDER BY ... LIMIT 1)
        String sql = SELECT_READER_WITH_CARD + "WHERE r.readerCode = ? "
                   + "ORDER BY (k.status = 'ACTIVE') DESC, k.issueDate DESC LIMIT 1";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapReaderWithCard(rs) : null;
            }
        }
    }

    static Reader8 mapReaderWithCard(ResultSet rs) throws SQLException {
        Reader8 r = new Reader8();
        r.setUserId(rs.getLong("userId"));
        r.setUsername(rs.getString("username"));
        r.setRole(User8.ROLE_READER);
        r.setReaderId(rs.getString("readerCode"));
        r.setFullName(rs.getString("fullName"));
        r.setEmail(rs.getString("email"));
        r.setPhone(rs.getString("phone"));
        String cardId = rs.getString("cardId");
        if (cardId != null) {
            LibraryCard8 card = new LibraryCard8();
            card.setCardId(cardId);
            Date issue = rs.getDate("issueDate");
            card.setIssueDate(issue == null ? null : issue.toLocalDate());
            card.setStatus(rs.getString("cardStatus"));
            card.setReader(r);
            r.setLibraryCard(card);
        }
        return r;
    }
}
