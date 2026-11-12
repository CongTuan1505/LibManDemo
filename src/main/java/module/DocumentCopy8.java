package module;

import java.util.ArrayList;
import java.util.List;

/** Lop thuc the DocumentCopy8 (khop file A, muc C.I - So do lop thuc the). */
public class DocumentCopy8 {
    public static final String STATUS_AVAILABLE = "AVAILABLE";
    public static final String STATUS_BORROWED = "BORROWED";

    private String copyId;
    private String status;
    private Document8 document;
    private List<LoanDetail8> loanDetails = new ArrayList<>();

    public DocumentCopy8() {
    }

    public String getCopyId() {
        return copyId;
    }

    public void setCopyId(String copyId) {
        this.copyId = copyId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Document8 getDocument() {
        return document;
    }

    public void setDocument(Document8 document) {
        this.document = document;
    }

    public List<LoanDetail8> getLoanDetails() {
        return loanDetails;
    }

    public void setLoanDetails(List<LoanDetail8> loanDetails) {
        this.loanDetails = loanDetails;
    }

    public boolean isAvailable() {
        return STATUS_AVAILABLE.equals(status);
    }
}
