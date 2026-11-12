package module;

import java.util.ArrayList;
import java.util.List;

/** Lop thuc the Librarian8 (khop file A, muc C.I - So do lop thuc the). */
public class Librarian8 extends User8 {
    private String staffId;
    private String fullName;
    private String phone;
    private List<LoanReceipt8> loanReceipts = new ArrayList<>();

    public Librarian8() {
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public List<LoanReceipt8> getLoanReceipts() {
        return loanReceipts;
    }

    public void setLoanReceipts(List<LoanReceipt8> loanReceipts) {
        this.loanReceipts = loanReceipts;
    }
}
