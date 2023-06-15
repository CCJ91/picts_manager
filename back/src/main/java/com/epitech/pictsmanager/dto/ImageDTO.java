package com.epitech.pictsmanager.dto;

import com.epitech.pictsmanager.model.Image;
import org.springframework.web.multipart.MultipartFile;

public class ImageDTO extends Image {

    private MultipartFile multipartFile;

    public MultipartFile getMultipartFile() {
        return multipartFile;
    }

    public void setMultipartFile(MultipartFile multipartFile) {
        this.multipartFile = multipartFile;
    }
}
