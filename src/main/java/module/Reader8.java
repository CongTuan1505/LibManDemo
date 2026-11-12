package module;

import java.util.ArrayList;
import java.util.List;

/** Lop thuc the Reader8 (khop file A, muc C.I - So do lop thuc the). */
public class Reader8 extends User8 {
    private String readerId;
    private String fullName;
    private String email;
    private String phone;
    private LibraryCard8 libraryCard;
    private List<LoanReceipt8> loanReceipts = new ArrayList<>();

    public Reader8() {
    }

    public String getReaderId() {
        return readerId;
    }

    public void setReaderId(String readerId) {
        this.readerId = readerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LibraryCard8 getLibraryCard() {
        return libraryCard;
    }

    public void setLibraryCard(LibraryCard8 libraryCard) {
        this.libraryCard = libraryCard;
    }

    public List<LoanReceipt8> getLoanReceipts() {
        return loanReceipts;
    }

    public void setLoanReceipts(List<LoanReceipt8> loanReceipts) {
        this.loanReceipts = loanReceipts;
    }
}
