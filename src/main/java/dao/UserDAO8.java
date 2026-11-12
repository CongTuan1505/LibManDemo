package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.nio.charset.StandardCharsets;

import module.Librarian8;
import module.Reader8;
import module.User8;

/**
 * Dang nhap (use case Login). A khong dat ten DAO nay, nen day la lop bo sung theo quy uoc DAO8.
 */
public class UserDAO8 extends DAO8 {

    /** @return Reader8 / Librarian8 tuy vai tro, hoac null neu sai tai khoan/mat khau. */
    public User8 login8(String username, String plainPassword) throws SQLException {
        String sql = "SELECT userId, username, role FROM tblUser8 WHERE username = ? AND password = ?";
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, sha256Hex(plainPassword));
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                long userId = rs.getLong("userId");
                String role = rs.getString("role");
                User8 user;
                if (User8.ROLE_READER.equals(role)) {
                    user = loadReader(c, userId);
                } else if (User8.ROLE_LIBRARIAN.equals(role)) {
                    user = loadLibrarian(c, userId);
                } else {
                    return null;
                }
                if (user == null) {
                    return null;
                }
                user.setUserId(userId);
                user.setUsername(rs.getString("username"));
                user.setRole(role);
                return user; // khong dua password ra ngoai
            }
        }
    }

    private Reader8 loadReader(Connection c, long userId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT readerCode, fullName, email, phone FROM tblReader8 WHERE userId = ?")) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Reader8 r = new Reader8();
                r.setReaderId(rs.getString(1));
                r.setFullName(rs.getString(2));
                r.setEmail(rs.getString(3));
                r.setPhone(rs.getString(4));
                return r;
            }
        }
    }

    private Librarian8 loadLibrarian(Connection c, long userId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT staffCode, fullName FROM tblLibrarian8 WHERE userId = ?")) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Librarian8 l = new Librarian8();
                l.setStaffId(rs.getString(1));
                l.setFullName(rs.getString(2));
                return l;
            }
        }
    }

    static String sha256Hex(String s) {
        try {
            byte[] h = MessageDigest.getInstance("SHA-256").digest(s.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : h) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
