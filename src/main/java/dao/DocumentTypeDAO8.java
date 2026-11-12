package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import module.DocumentType8;

public class DocumentTypeDAO8 extends DAO8 {

    private static final String SELECT_BY_ID =
            "SELECT typeId, typeName, description FROM tblDocumentType8 WHERE typeId = ?";
    private static final String SELECT_ALL =
            "SELECT typeId, typeName, description FROM tblDocumentType8 ORDER BY typeName";

    public DocumentType8 getTypeById8(long typeId) throws SQLException {
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(SELECT_BY_ID)) {
            ps.setLong(1, typeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<DocumentType8> getAllTypes8() throws SQLException {
        List<DocumentType8> list = new ArrayList<>();
        try (Connection c = connection(); PreparedStatement ps = c.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    private DocumentType8 map(ResultSet rs) throws SQLException {
        DocumentType8 t = new DocumentType8();
        t.setTypeId(rs.getLong("typeId"));
        t.setTypeName(rs.getString("typeName"));
        t.setDescription(rs.getString("description"));
        return t;
    }
}
