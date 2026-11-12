package module;

import java.util.ArrayList;
import java.util.List;

/** Lop thuc the DocumentType8 (khop file A, muc C.I - So do lop thuc the). */
public class DocumentType8 {
    private Long typeId;
    private String typeName;
    private String description;
    private List<Document8> documents = new ArrayList<>();

    public DocumentType8() {
    }

    public Long getTypeId() {
        return typeId;
    }

    public void setTypeId(Long typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Document8> getDocuments() {
        return documents;
    }

    public void setDocuments(List<Document8> documents) {
        this.documents = documents;
    }
}
