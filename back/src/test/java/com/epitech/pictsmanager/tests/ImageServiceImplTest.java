package com.epitech.pictsmanager.tests;

import com.epitech.pictsmanager.model.Image;
import com.epitech.pictsmanager.repository.ImageRepository;
import com.epitech.pictsmanager.repository.ImageTagRepository;
import com.epitech.pictsmanager.repository.TagRepository;
import com.epitech.pictsmanager.service.TagService;
import com.epitech.pictsmanager.service.impl.ImageServiceImpl;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;

@ActiveProfiles("test")
class ImageServiceImplTest {

    private final ImageRepository imageRepository = Mockito.mock(ImageRepository.class);

    private final ImageTagRepository imageTagRepository = Mockito.mock(ImageTagRepository.class);

    private final TagRepository tagRepository = Mockito.mock(TagRepository.class);

    private ImageServiceImpl imageServiceImpl;

    @BeforeEach
    void initImageService() {
        this.imageServiceImpl = new ImageServiceImpl(imageRepository, imageTagRepository, tagRepository);
    }

    @Test
    void getByIdTest() {
        Optional<Image> imageToReturn = Optional.of(new Image());
        Mockito.when(imageRepository.findById(1)).thenReturn(imageToReturn);
        Optional<Image> image = imageServiceImpl.getImageById(1);
        Assertions.assertEquals(imageToReturn, image);
    }

    @Test
    void getByIdFailedTest() {
        Optional<Image> imageToReturn = Optional.of(new Image());
        Mockito.when(imageRepository.findById(1)).thenReturn(imageToReturn);
        Optional<Image> image = imageServiceImpl.getImageById(2);
        Assertions.assertNotEquals(imageToReturn, image);
    }

    @Test
    void getAllTest() {
        List<Image> imageListToReturn = new ArrayList<>();
        Mockito.when(imageRepository.findAll()).thenReturn(imageListToReturn);
        List<Image> imageList = imageServiceImpl.getAllImages();
        Assertions.assertEquals(imageListToReturn, imageList);
    }

    @Test
    void getImagesForAlbumTest() {
        List<Image> imageListToReturn = new ArrayList<>();
        Mockito.when(imageRepository.findByAlbum_AlbumId(1)).thenReturn(imageListToReturn);
        List<Image> imageList = imageServiceImpl.getImagesForAlbum(1);
        Assertions.assertEquals(imageListToReturn, imageList);
    }

    @Test
    void saveImageTest() {
        Image imageToReturn = new Image();
        Image imageToSave = new Image();
        Mockito.when(imageRepository.save(any(Image.class))).thenReturn(imageToReturn);
        Image image = imageServiceImpl.saveImage(imageToSave);
        Assertions.assertEquals(imageToReturn, image);
    }

}
