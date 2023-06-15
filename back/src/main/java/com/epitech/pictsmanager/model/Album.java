package com.epitech.pictsmanager.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name="albums")
public class Album {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer albumId;

    @Column(name = "name", nullable = false, length = 120)
    private String albumName;

    @Column(name = "is_public", nullable = false)
    private int albumIsPublic;

    @Column(name = "is_default", nullable = false)
    private int albumIsDefault;

    @Column(name = "id_owner", nullable = false)
    private int albumIdOwner;

    @OneToMany(mappedBy = "album", cascade = CascadeType.ALL)
    private Set<Image> imageSet;

    @OneToMany(mappedBy = "albumUser", cascade = CascadeType.ALL)
    private Set<AlbumShared> albumSharedUserSet;

    public Integer getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Integer albumId) {
        this.albumId = albumId;
    }

    public String getAlbumName() {
        return albumName;
    }

    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }

    public int getAlbumIsPublic() {
        return albumIsPublic;
    }

    public void setAlbumIsPublic(int albumIsPublic) {
        this.albumIsPublic = albumIsPublic;
    }

    public int getAlbumIdOwner() {
        return albumIdOwner;
    }

    public void setAlbumIdOwner(int albumIdOwner) {
        this.albumIdOwner = albumIdOwner;
    }

    public int getAlbumIsDefault() {
        return albumIsDefault;
    }

    public void setAlbumIsDefault(int albumIsDefault) {
        this.albumIsDefault = albumIsDefault;
    }

}
