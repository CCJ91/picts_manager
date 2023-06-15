package com.epitech.pictsmanager.service.impl;

import com.epitech.pictsmanager.dto.ImageDTO;
import com.epitech.pictsmanager.model.*;
import com.epitech.pictsmanager.dto.ListImageTagDTO;
import com.epitech.pictsmanager.repository.ImageRepository;
import com.epitech.pictsmanager.repository.ImageTagRepository;
import com.epitech.pictsmanager.repository.TagRepository;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.TagService;
import net.coobird.thumbnailator.Thumbnails;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.server.ResponseStatusException;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class ImageServiceImpl implements ImageService {

    private final ImageRepository imageRepository;

    private final ImageTagRepository imageTagRepository;

    private final TagRepository tagRepository;

    @Value("${base_url_image}")
    private String baseUrlImage;

    public ImageServiceImpl(ImageRepository imageRepository, ImageTagRepository imageTagRepository, TagRepository tagRepository) {
        this.imageRepository = imageRepository;
        this.imageTagRepository = imageTagRepository;
        this.tagRepository = tagRepository;
    }

    /**
     * @param imageId imageId
     * @return Image choisis par imageId
     */
    @Override
    public Optional<Image> getImageById(Integer imageId) {
        return this.imageRepository.findById(imageId);
    }

    /**
     * @return Tous les images existantes
     */
    @Override
    public List<Image> getAllImages() {
        return this.imageRepository.findAll();
    }

    /**
     * @param albumId albumId
     * @return Toutes les images pour l'album choisi par albumId
     */
    @Override
    public List<Image> getImagesForAlbum(Integer albumId) {
        return imageRepository.findByAlbum_AlbumId(albumId);
    }

    /**
     * @param tagId tagId
     * @return Tous les images publiques portant le tag choisi par tagId
     */
    @Override
    public List<Image> getImagesPublicByTag(Integer tagId) {
        List<ImageTag> imageTagList = imageTagRepository.findByTagTagId(tagId);
        List<Image> imagesReturn = new ArrayList<>();
        if (imageTagList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Aucune image associée à ce tag");
        }
        for (ImageTag imgTag : imageTagList) {
            if (imgTag.getImage().getImageIsPublic() == 1) {
                imagesReturn.add(imgTag.getImage());
            }
        }
        return imagesReturn;
    }

    @Override
    public Image findFirstByAlbumAlbumId(Integer imageId) {
        return imageRepository.findFirstByAlbumAlbumId(imageId);
    }

    @Override
    public List<Image> findByAlbumId(Integer albumId) {
        return imageRepository.findByAlbum_AlbumId(albumId);
    }

    /**
     * @param imageId imageId, isThumbnail
     * @return Image récupérée depuis le serveur au format thumbnail selon isThumbnail
     * @throws IOException Bad request
     */
    @Override
    public byte[] downloadImage(Integer imageId, boolean isThumbnail) throws IOException {
        Image image = imageRepository.findById(imageId).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST, "Image not found " + imageId));
        byte[] imageToReturn = null;
        Path filePath = Paths.get(isThumbnail ? image.getImageLinkThumbnail() : image.getImageLink());
        if (Files.exists(filePath) && !Files.isDirectory(filePath)) {
            InputStream in = Files.newInputStream(filePath, StandardOpenOption.READ);
            ByteArrayInputStream bis = new ByteArrayInputStream(in.readAllBytes());
            BufferedImage bufferedImage = ImageIO.read(bis);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ImageIO.write(bufferedImage, "png", bos);
            imageToReturn = bos.toByteArray();
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_PNG);
        return imageToReturn;
    }

    /**
     * @param image imageToSave
     * @return Image sauvegardée
     */
    @Override
    public Image saveImage(Image image) {
        return this.imageRepository.save(image);
    }

    /**
     * @param listImageTag list ImageTag
     * @return l'image sauvegardé
     */
    @Override
    public Image saveImageAndTag(ListImageTagDTO listImageTag) {
        Image imageSave = this.saveImage(listImageTag.getImage());
        for (Tag tag : listImageTag.getTagList()) {
            Tag tagFind = this.tagRepository.findByTagName(tag.getTagName());
            if (tagFind == null) {
                tagFind = this.tagRepository
                        .save(tag);
            }
            ImageTag imageTag = new ImageTag();
            imageTag.setImage(imageSave);
            imageTag.setTag(tagFind);
            this.imageTagRepository.save(imageTag);
        }
        return imageSave;
    }

    /**
     * @param imageDTO imageDTO
     * @return Image déposée sur le serveur
     * @throws IOException Bad request, image déjà présente sur le serveur
     */
    @Override
    public Image uploadFileToServer(ImageDTO imageDTO) throws IOException {
        Image imageSave = new Image();
        String pathFinal;
        String urlStockage = this.baseUrlImage + File.separator + "PictsManager" + File.separator + "Images";
        File convFile = new File(Objects.requireNonNull(imageDTO.getMultipartFile().getOriginalFilename()));
        Path path = Paths.get(urlStockage);
        Files.createDirectories(path);
        pathFinal = urlStockage + File.separator + convFile;
        File fichierStocke = new File(pathFinal);
        boolean createdFile = fichierStocke.createNewFile();
        if (!createdFile) {
            throw new IOException("L'image n'a pas pu être déposée sur le serveur");
        }
        try (FileOutputStream fos = new FileOutputStream(convFile)) {
            fos.write(imageDTO.getMultipartFile().getBytes());
        }
        String thumbNail = createThumbnail(imageDTO.getMultipartFile().getBytes(), convFile.getName());
        FileCopyUtils.copy(convFile, fichierStocke);
        FileUtils.forceDelete(convFile);
        imageSave.setImageLink(pathFinal);
        imageSave.setImageLinkThumbnail(thumbNail);
        return imageSave;
    }

    /**
     * @param imageId imageToDelete
     */
    @Override
    public void deleteImage(Integer imageId) {
        Image imageFind = this.imageRepository.findById(imageId).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST, "Image inexistante"));
        this.imageRepository.deleteById(imageId);
        try {
            Files.delete(Paths.get(imageFind.getImageLink()));
            Files.delete(Paths.get(imageFind.getImageLinkThumbnail()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * @param fileData FileData
     * @param filename FileName
     * @return le lien du thumbnail créé
     * @throws IOException ioException
     */
    private String createThumbnail(byte[] fileData, String filename) throws IOException {
        String uploadDir = this.baseUrlImage + File.separator + "PictsManager" + File.separator + "Images";
        int dotIndex = filename.trim().lastIndexOf('.');
        String filenameWithoutExtension = dotIndex == -1 ? filename : filename.substring(0, dotIndex);
        String thumbnailFilename = filenameWithoutExtension + "_thumbnail.png";
        String thumbnailCompletePath = uploadDir.trim() + File.separator + thumbnailFilename;
        BufferedImage originalImage = ImageIO.read(new ByteArrayInputStream(fileData));
        Thumbnails.of(originalImage)
                .size(160, 160)
                .toFile(thumbnailCompletePath);
        return thumbnailCompletePath;
    }
}
