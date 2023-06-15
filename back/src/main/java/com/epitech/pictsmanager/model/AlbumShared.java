package com.epitech.pictsmanager.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
@Table(name = "albums_shared")
public class AlbumShared {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer albumSharedId;

    @JoinColumn(name = "user_id")
    @ManyToOne(fetch = FetchType.LAZY)
    @JsonBackReference(value = "albumSharedSet")
    private User user;

    @JoinColumn(name = "album_id")
    @ManyToOne(fetch = FetchType.EAGER)
    @JsonBackReference(value = "albumSharedUserSet")
    private Album albumUser;

    public Integer getAlbumSharedId() {
        return albumSharedId;
    }

    public void setAlbumSharedId(Integer albumSharedId) {
        this.albumSharedId = albumSharedId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Album getAlbumUser() {
        return albumUser;
    }

    public void setAlbumUser(Album albumUser) {
        this.albumUser = albumUser;
    }
}
