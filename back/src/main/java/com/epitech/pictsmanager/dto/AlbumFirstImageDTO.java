package com.epitech.pictsmanager.dto;

import com.epitech.pictsmanager.model.Album;
import com.epitech.pictsmanager.model.Image;

public class AlbumFirstImageDTO {

    private Image image;

    private Album album;

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }

    public Album getAlbum() {
        return album;
    }

    public void setAlbum(Album album) {
        this.album = album;
    }
}
