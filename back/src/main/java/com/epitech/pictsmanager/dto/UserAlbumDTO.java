package com.epitech.pictsmanager.dto;

import java.util.List;

public class UserAlbumDTO {

    private List<String> userMailList;

    private Integer albumId;

    public List<String> getUserMailList() {
        return userMailList;
    }

    public void setUserMailList(List<String> userMailList) {
        this.userMailList = userMailList;
    }

    public Integer getAlbumId() {
        return albumId;
    }

    public void setAlbumId(Integer albumId) {
        this.albumId = albumId;
    }
}
