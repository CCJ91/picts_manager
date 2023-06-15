package com.epitech.pictsmanager.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "tags")
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int tagId;

    @Column(name = "name", nullable = false, unique = true, length = 50)
    private String tagName;

    @OneToMany(mappedBy = "tag", cascade = CascadeType.ALL)
    private Set<ImageTag> tagSet;

    public int getTagId() {
        return tagId;
    }

    public void setTagId(int tagId) {
        this.tagId = tagId;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}
