package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import module.Reader8;

public class LibraryCardDAO8 extends DAO8 {

    /** Scenario 3.0 buoc 6: tim ban doc theo ma the (quet the). Ket qua kem the o Reader8.getLibraryCard(). */
    public Reader8 getReaderByCard8(String cardId) throws SQLException {
        String sql = ReaderDAO8.SELECT_READER_WITH_CARD + "WHERE k.cardId = ?";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, cardId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? ReaderDAO8.mapReaderWithCard(rs) : null;
            }
        }
    }
}
