package module;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Lop thuc the LoanReceipt8 (khop file A, muc C.I - So do lop thuc the). */
public class LoanReceipt8 {
    public static final String STATUS_CONFIRMED = "CONFIRMED";

    private Long loanId;
    private LocalDate loanDate;
    private String status;
    private Reader8 reader;
    private Librarian8 librarian;
    private List<LoanDetail8> loanDetails = new ArrayList<>();

    public LoanReceipt8() {
    }

    public Long getLoanId() {
        return loanId;
    }

    public void setLoanId(Long loanId) {
        this.loanId = loanId;
    }

    public LocalDate getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(LocalDate loanDate) {
        this.loanDate = loanDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Reader8 getReader() {
        return reader;
    }

    public void setReader(Reader8 reader) {
        this.reader = reader;
    }

    public Librarian8 getLibrarian() {
        return librarian;
    }

    public void setLibrarian(Librarian8 librarian) {
        this.librarian = librarian;
    }

    public List<LoanDetail8> getLoanDetails() {
        return loanDetails;
    }

    public void setLoanDetails(List<LoanDetail8> loanDetails) {
        this.loanDetails = loanDetails;
    }
}
