package com.epitech.pictsmanager.dto;

public class UserAlbumSharedDTO {

    private String userEmail;

    private Integer albumId;

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public Integer getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Integer albumId) {
        this.albumId = albumId;
    }
}
