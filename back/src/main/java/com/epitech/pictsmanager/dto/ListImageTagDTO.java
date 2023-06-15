package com.epitech.pictsmanager.dto;

import com.epitech.pictsmanager.model.Image;
import com.epitech.pictsmanager.model.Tag;
import java.util.List;

public class ListImageTagDTO {

    private Image image;

    private List<Tag> tagList;

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }

    public List<Tag> getTagList() {
        return tagList;
    }

    public void setTagList(List<Tag> tagList) {
        this.tagList = tagList;
    }
}
