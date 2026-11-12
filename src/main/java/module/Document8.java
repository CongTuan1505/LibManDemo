package module;

import java.util.ArrayList;
import java.util.List;

/** Lop thuc the Document8 (khop file A, muc C.I - So do lop thuc the). */
public class Document8 {
    private String documentId;
    private String title;
    private String author;
    private String publisher;
    private Integer publishYear;
    private String description;
    private DocumentType8 documentType;
    private List<DocumentCopy8> copies = new ArrayList<>();

    public Document8() {
    }

    public String getDocumentId() {
        return documentId;
    }

    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Integer getPublishYear() {
        return publishYear;
    }

    public void setPublishYear(Integer publishYear) {
        this.publishYear = publishYear;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public DocumentType8 getDocumentType() {
        return documentType;
    }

    public void setDocumentType(DocumentType8 documentType) {
        this.documentType = documentType;
    }

    public List<DocumentCopy8> getCopies() {
        return copies;
    }

    public void setCopies(List<DocumentCopy8> copies) {
        this.copies = copies;
    }
}
