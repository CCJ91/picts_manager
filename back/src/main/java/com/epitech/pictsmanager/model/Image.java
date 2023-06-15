package com.epitech.pictsmanager.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.util.Set;

@Entity
@Table(name = "images")
public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer imageId;

    @Column(name = "name", nullable = false, length = 20)
    @NotBlank(message = "imageName is mandatory")
    private String imageName;

    @Column(name="link", columnDefinition = "TEXT")
    @NotBlank(message = "imageLink is mandatory")
    private String imageLink;

    @Column(name = "link_thumbnail", columnDefinition = "TEXT")
    private String imageLinkThumbnail;

    @Column(name = "is_public")
    private Integer imageIsPublic;

    @JoinColumn(name = "album_id")
    @ManyToOne(fetch = FetchType.LAZY)
    @JsonBackReference(value = "imageSet")
    private Album album;

    @OneToMany(mappedBy = "image", cascade = CascadeType.ALL)
    private Set<ImageTag> imageTagSet;

    public Integer getImageId() {
        return imageId;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public String getImageLink() {
        return imageLink;
    }

    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    public void setImageId(Integer imageId) {
        this.imageId = imageId;
    }

    public Integer getImageIsPublic() {
        return imageIsPublic;
    }

    public void setImageIsPublic(Integer imageIsPublic) {
        this.imageIsPublic = imageIsPublic;
    }

    public Album getAlbum() {
        return album;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }

    public String getImageLinkThumbnail() {
        return imageLinkThumbnail;
    }

    public void setImageLinkThumbnail(String imageLinkThumbnail) {
        this.imageLinkThumbnail = imageLinkThumbnail;
    }

}
