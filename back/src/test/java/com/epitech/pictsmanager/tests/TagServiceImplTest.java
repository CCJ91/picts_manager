package com.epitech.pictsmanager.tests;

import com.epitech.pictsmanager.model.Image;
import com.epitech.pictsmanager.model.ImageTag;
import com.epitech.pictsmanager.model.Tag;
import com.epitech.pictsmanager.repository.ImageTagRepository;
import com.epitech.pictsmanager.repository.TagRepository;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.impl.TagServiceImpl;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

@ActiveProfiles("test")
class TagServiceImplTest {

    private final TagRepository tagRepository = Mockito.mock(TagRepository.class);

    private final ImageTagRepository imageTagRepository = Mockito.mock(ImageTagRepository.class);

    private final ImageService imageService = Mockito.mock(ImageService.class);

    private TagServiceImpl tagServiceImpl;

    private Tag tagToReturn = new Tag();

    private ImageTag imageTagToReturn = new ImageTag();

    private final List<Tag> tagListToReturn = new ArrayList<>();

    private final List<ImageTag> imageTagListToReturn = new ArrayList<>();

    @BeforeEach
    void initTagService() {
        tagServiceImpl = new TagServiceImpl(tagRepository, imageTagRepository, imageService);
    }

    @Test
    void getByIdTest() {
        Optional<Tag> tagTest = Optional.of(new Tag());
        Mockito.when(tagRepository.findById(1)).thenReturn(tagTest);
        Optional<Tag> tag = tagServiceImpl.getById(1);
        Assertions.assertEquals(tagTest, tag);
    }

    @Test
    void getImageTagByIdsTest() {
        Optional<ImageTag> imageTagOptional = Optional.of(new ImageTag());
        Mockito.when(tagServiceImpl.getImageTagByIds(1, 1)).thenReturn(imageTagOptional);
        Optional<ImageTag> imageTag = imageTagRepository.findByImage_ImageIdAndTag_TagId(1, 1);
        Assertions.assertEquals(imageTagOptional, imageTag);
    }

    @Test
    void getByNameTest() {
        Tag tag1 = new Tag();
        tag1.setTagName("name");
        Mockito.when(tagRepository.findByTagName("name")).thenReturn(tag1);
        Tag tag = tagServiceImpl.getByName("name");
        Assertions.assertEquals(tag1, tag);
    }

    @Test
    void getByNameFailedTest() {
        Tag tag1 = new Tag();
        tag1.setTagName("name");
        Mockito.when(tagRepository.findByTagName("name")).thenReturn(tag1);
        Tag tag = tagServiceImpl.getByName("name2");
        Assertions.assertNotEquals(tag1, tag);
    }

    @Test
    void getAllTagsTest() {
        Mockito.when(tagServiceImpl.getAll()).thenReturn(tagListToReturn);
        List<Tag> tags = tagRepository.findAll();
        Assertions.assertEquals(tagListToReturn, tags);
    }

    @Test
    void getAllImageTagsTest() {
        Mockito.when(tagServiceImpl.getAllImagesTags()).thenReturn(imageTagListToReturn);
        List<ImageTag> imageTags = imageTagRepository.findAll();
        Assertions.assertEquals(imageTagListToReturn, imageTags);
    }

    @Test
    void getTagsForImage() {
        Mockito.when(tagServiceImpl.getTagsForImage(1)).thenReturn(tagListToReturn);
        List<Tag> tags = tagServiceImpl.getTagsForImage(1);
        Assertions.assertEquals(tagListToReturn, tags);
    }

    @Test
    void saveTagTest() {
        Tag tag = new Tag();
        Mockito.when(tagRepository.save(any(Tag.class))).thenReturn(tagToReturn);
        Tag tagSave = tagServiceImpl.save(tag);
        Assertions.assertEquals(tagToReturn, tagSave);
    }

    @Test
    void addTagToImageExceptionTest() {
        ResponseStatusException e = Assertions.assertThrows(ResponseStatusException.class, () -> {
            ImageTag imageTag = new ImageTag();
            Tag tag = new Tag();
            Mockito.when(imageTagRepository.save(imageTag)).thenReturn(imageTagToReturn);
            ImageTag imageTag1 = tagServiceImpl.addTagToImage(1, tag);
        });
        Assertions.assertEquals("Image inexistante", e.getReason());
        Assertions.assertEquals(BAD_REQUEST, e.getStatusCode());
    }

    @Test
    void addTagToImageTest() {
        Tag tag1 = new Tag();
        tag1.setTagName("name");
        tag1.setTagId(1);
        Image image1 = new Image();
        image1.setImageId(1);
        imageTagToReturn.setImage(image1);
        imageTagToReturn.setTag(tag1);
        imageTagToReturn.setImageTagId(1);
        Mockito.when(imageService.getImageById(1)).thenReturn(Optional.of(image1));
        Mockito.when(tagRepository.findByTagName("name")).thenReturn(tag1);
        Mockito.when(imageTagRepository.save(any(ImageTag.class))).thenReturn(imageTagToReturn);
        ImageTag imageTagSave = tagServiceImpl.addTagToImage(1, tag1);
        Assertions.assertEquals(imageTagToReturn, imageTagSave);
    }

}
