package module;

import java.time.LocalDate;

/** Lop thuc the LibraryCard8 (khop file A, muc C.I - So do lop thuc the). */
public class LibraryCard8 {
    public static final String STATUS_ACTIVE = "ACTIVE";

    private String cardId;
    private LocalDate issueDate;
    private String status;
    private Reader8 reader;

    public LibraryCard8() {
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public LocalDate getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(LocalDate issueDate) {
        this.issueDate = issueDate;
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

    public boolean isActive() {
        return STATUS_ACTIVE.equals(status);
    }
}
