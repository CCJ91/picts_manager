package com.epitech.pictsmanager.service;

import com.epitech.pictsmanager.dto.ImageDTO;
import com.epitech.pictsmanager.dto.ListImageTagDTO;
import com.epitech.pictsmanager.model.Image;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

public interface ImageService {

    Optional<Image> getImageById(Integer imageId);

    List<Image> getAllImages();

    List<Image> getImagesForAlbum(Integer albumId);

    List<Image> getImagesPublicByTag(Integer tagId);

    Image findFirstByAlbumAlbumId(Integer imageId);

    List<Image> findByAlbumId(Integer albumId);

    byte[] downloadImage(Integer imageId, boolean isThumbnail) throws IOException;

    Image saveImage(Image image);

    Image saveImageAndTag(ListImageTagDTO listImageTagDTO);

    Image uploadFileToServer(ImageDTO imageDTO) throws IOException;

    void deleteImage(Integer imageId);
}
