package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import module.LoanDetail8;

public class LoanDetailDAO8 extends DAO8 {

    /** Scenario 3.0 buoc 56: luu chi tiet phieu muon (moi ban sao mot dong) trong giao dich da mo. */
    public void createLoanDetails8(Connection c, long loanId, List<LoanDetail8> details) throws SQLException {
        String sql = "INSERT INTO tblLoanDetail8 (loanId, copyId) VALUES (?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            for (LoanDetail8 d : details) {
                ps.setLong(1, loanId);
                ps.setString(2, d.getDocumentCopy().getCopyId());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
}
