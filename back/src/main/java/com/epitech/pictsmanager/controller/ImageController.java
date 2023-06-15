package com.epitech.pictsmanager.controller;

import com.epitech.pictsmanager.dto.ImageDTO;
import com.epitech.pictsmanager.model.Album;
import com.epitech.pictsmanager.model.Image;
import com.epitech.pictsmanager.dto.ListImageTagDTO;
import com.epitech.pictsmanager.repository.AlbumRepository;
import com.epitech.pictsmanager.service.AlbumService;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.TagService;
import com.epitech.pictsmanager.service.impl.ImageServiceImpl;
import com.epitech.pictsmanager.service.impl.TagServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/pictsmanager")
public class ImageController {

    @Autowired
    ImageService imageService;

    @Autowired
    AlbumService albumService;

    private static final String IMAGE_NOT_FOUND = "Image not found ";

    /**
     * @param id imageId, thumbnail thumbnail
     * @return Image choisie sous forme de byte pour l'upload
     * @throws IOException Bad request
     */
    @GetMapping(value = "/image/{id}/{thumbnail}")
    public ResponseEntity<byte[]> getImageById(@PathVariable(value = "id") String id, @PathVariable(value = "thumbnail") String thumbnail) {
        try {
            Integer imageId = Integer.valueOf(id);
            Integer thumbnailInt = Integer.valueOf(thumbnail);
            boolean isThumbnail = thumbnailInt == 1;
            byte[] bytes = imageService.downloadImage(imageId, isThumbnail);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * @return Toutes les images existantes
     * @throws ResponseStatusException responseStatus 400
     */
    @GetMapping(value = "/images")
    public ResponseEntity<List<Image>> getAllImages() throws ResponseStatusException {
        List<Image> imageList = this.imageService.getAllImages();
        if (imageList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, IMAGE_NOT_FOUND);
        } else {
            return ResponseEntity.ok().body(imageList);
        }
    }

    /**
     * @param id albumId
     * @return Toutes les imgaes de l'album choisi
     */
    @GetMapping(value = "/image/album/{id}")
    public ResponseEntity<List<Image>> getImagesForAlbum(@PathVariable(name = "id") String id) {
        Integer albumId = Integer.valueOf(id);
        List<Image> imageList = this.imageService.getImagesForAlbum(albumId);
        if (imageList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, IMAGE_NOT_FOUND);
        } else {
            return ResponseEntity.ok().body(imageList);
        }
    }

    /**
     * @param id tagId
     * @return Images publics associées au tag choisi
     */
    @GetMapping(value = "/image/album/public/{id}")
    public ResponseEntity<List<Image>> getImagesPublicTag(@PathVariable(name = "id") String id) {
        Integer tagId = Integer.valueOf(id);
        List<Image> imageList = imageService.getImagesPublicByTag(tagId);
        return ResponseEntity.ok().body(imageList);
    }

    /**
     * @param id    albumId
     * @param body  ListImageTagDTP
     * @param image ImageToDownload
     * @return Image sauvegardé avec son chemin vers le serveur
     * @throws IOException Bad Request
     */
    @PostMapping(value = "/image/save/{id}")
    public ResponseEntity<Image> saveImage(@PathVariable(name = "id") String id, @RequestParam String body,
                                           @RequestParam MultipartFile image) throws IOException {
        Image imageSave;
        Image imageUpload;
        Integer albumId = Integer.valueOf(id);
        ListImageTagDTO listImageTagDTO = new ListImageTagDTO();
        ObjectMapper objectMapper = new ObjectMapper();
        listImageTagDTO = objectMapper.readValue(body, listImageTagDTO.getClass());
        Album album = albumService.getById(albumId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Album not found"));
        listImageTagDTO.getImage().setAlbum(album);
        try {
            imageUpload = this.uploadImage(image, listImageTagDTO.getImage().getImageName());
            listImageTagDTO.getImage().setImageLink(imageUpload.getImageLink());
            listImageTagDTO.getImage().setImageLinkThumbnail(imageUpload.getImageLinkThumbnail());
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Image can't be download --------- " + e.getMessage());
        }
        if (!listImageTagDTO.getTagList().isEmpty()) {
            imageSave = this.imageService.saveImageAndTag(listImageTagDTO);
        } else {
            imageSave = this.imageService.saveImage(listImageTagDTO.getImage());
        }
        return ResponseEntity.ok().body(imageSave);
    }

    /**
     * @param image Image
     * @return Image modifiée
     */
    @PutMapping(value = "/image")
    public ResponseEntity<Image> updateImage(@RequestBody Image image) {
        Image imageUpdate = this.imageService.saveImage(image);
        return ResponseEntity.ok().body(imageUpdate);
    }

    /**
     * @param id imageId
     * @return Image supprimée
     */
    @DeleteMapping(value = "/image/{id}")
    public ResponseEntity<String> deleteImage(@PathVariable(value = "id") String id) {
        Integer imageId = Integer.valueOf(id);
        imageService.deleteImage(imageId);
        return ResponseEntity.ok().body("Image delete");
    }

    /**
     * @param image     Image to Upload
     * @param imageName Nom de l'image
     * @return Image trouvée sur le serveur
     * @throws IOException ioException
     */
    private Image uploadImage(MultipartFile image, String imageName) throws IOException {
        ImageDTO imageDTO = new ImageDTO();
        imageDTO.setImageLink(imageName);
        imageDTO.setMultipartFile(image);
        return this.imageService.uploadFileToServer(imageDTO);
    }

}
