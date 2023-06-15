package com.epitech.pictsmanager.dto;

import com.epitech.pictsmanager.model.Image;
import org.springframework.http.ResponseEntity;

public class ImageDownloadDTO {

    private ResponseEntity<byte[]> imageByte;

    private Image image;

    public ResponseEntity<byte[]> getImageByte() {
        return imageByte;
    }

    public void setImageByte(ResponseEntity<byte[]> imageByte) {
        this.imageByte = imageByte;
    }

    public Image getImage() {
        return image;
    }

    public void setImage(Image image) {
        this.image = image;
    }
}
