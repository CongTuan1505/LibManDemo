package dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Lop co so cua tat ca DAO (khop so do lop thiet ke: DAO8 co connection() va getConnection()).
 * Doc cau hinh JDBC tu db.properties.
 */
public class DAO8 {
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        Properties p = new Properties();
        try (InputStream in = DAO8.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                p.load(in);
            }
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
        URL = p.getProperty("jdbc.url", "jdbc:mysql://localhost:3306/libman8?useSSL=false&serverTimezone=UTC");
        USER = p.getProperty("jdbc.username", "root");
        PASSWORD = p.getProperty("jdbc.password", "root");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    /** Mo ket noi moi toi CSDL libman8. */
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    protected Connection connection() throws SQLException {
        return getConnection();
    }
}
