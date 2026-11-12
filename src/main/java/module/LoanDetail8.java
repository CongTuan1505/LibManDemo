package module;

import java.time.LocalDate;

/** Lop thuc the LoanDetail8 (khop file A, muc C.I - So do lop thuc the). */
public class LoanDetail8 {
    private Long loanDetailId;
    private LocalDate returnDate;
    private LoanReceipt8 loanReceipt;
    private DocumentCopy8 documentCopy;

    public LoanDetail8() {
    }

    public Long getLoanDetailId() {
        return loanDetailId;
    }

    public void setLoanDetailId(Long loanDetailId) {
        this.loanDetailId = loanDetailId;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public LoanReceipt8 getLoanReceipt() {
        return loanReceipt;
    }

    public void setLoanReceipt(LoanReceipt8 loanReceipt) {
        this.loanReceipt = loanReceipt;
    }

    public DocumentCopy8 getDocumentCopy() {
        return documentCopy;
    }

    public void setDocumentCopy(DocumentCopy8 documentCopy) {
        this.documentCopy = documentCopy;
    }
}
