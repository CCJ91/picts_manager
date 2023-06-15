package com.epitech.pictsmanager.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
@Table(name = "images_tags")
public class ImageTag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer imageTagId;

    @JoinColumn(name = "tag_id")
    @ManyToOne(fetch = FetchType.EAGER)
    private Tag tag;

    @JoinColumn(name = "image_id")
    @ManyToOne(fetch = FetchType.EAGER)
    private Image image;

    public Integer getImageTagId() {
        return imageTagId;
    }

    public void setImageTagId(Integer imageTagId) {
        this.imageTagId = imageTagId;
    }

    public Tag getTag() {
        return tag;
    }

    public void setTag(Tag tag) {
        this.tag = tag;
    }

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }
}
