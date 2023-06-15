package com.epitech.pictsmanager.service.impl;

import com.epitech.pictsmanager.model.Image;
import com.epitech.pictsmanager.model.ImageTag;
import com.epitech.pictsmanager.model.Tag;
import com.epitech.pictsmanager.repository.ImageTagRepository;
import com.epitech.pictsmanager.repository.TagRepository;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.TagService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class TagServiceImpl implements TagService {

    private final TagRepository tagRepository;

    private final ImageTagRepository imageTagRepository;

    private final ImageService imageService;

    public TagServiceImpl(TagRepository tagRepository, ImageTagRepository imageTagRepository, ImageService imageService) {
        this.tagRepository = tagRepository;
        this.imageTagRepository = imageTagRepository;
        this.imageService = imageService;
    }

    /**
     * @param tagId tagId
     * @return Tag choisi par tagId
     */
    @Override
    public Optional<Tag> getById(Integer tagId) {
        return this.tagRepository.findById(tagId);
    }

    /**
     * @param tagId   TagId
     * @param imageId ImageId
     * @return Une imageTag choisie par tagId et imageId
     */
    @Override
    public Optional<ImageTag> getImageTagByIds(Integer tagId, Integer imageId) {
        return imageTagRepository.findByImage_ImageIdAndTag_TagId(imageId, tagId);
    }

    /**
     * @param name tagName
     * @return Tag choisi par tagName
     */
    @Override
    public Tag getByName(String name) {
        return this.tagRepository.findByTagName(name);
    }

    /**
     * @param imageId imageId
     * @return Tous les tags associés à l'image choisie par imageId
     */
    @Override
    public List<Tag> getTagsForImage(Integer imageId) {
        List<ImageTag> imageTagList = imageTagRepository.findByImageImageId(imageId);
        List<Tag> tagList = new ArrayList<>();
        for (ImageTag imageTagtag : imageTagList) {
            tagList.add(imageTagtag.getTag());
        }
        return tagList;
    }

    /**
     * @return Tous les tags existants
     */
    @Override
    public List<Tag> getAll() {
        return this.tagRepository.findAll();
    }

    /**
     * @return Toutes les imageTags existantes
     */
    @Override
    public List<ImageTag> getAllImagesTags() {
        return this.imageTagRepository.findAll();
    }

    /**
     * @param tag tagToSave
     * @return Tag sauvegardé
     */
    @Override
    public Tag save(Tag tag) {
        Tag tagFind = tagRepository.findByTagName(tag.getTagName());
        if (tagFind != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tag déjà créé");
        }
        return this.tagRepository.save(tag);
    }

    /**
     * @param imageId imageId
     * @param tag     Tag
     * @return ImageTage sauvegardé
     */
    @Override
    public ImageTag addTagToImage(Integer imageId, Tag tag) {
        Image image = imageService.getImageById(imageId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Image inexistante"));
        Tag tagFind = tagRepository.findByTagName(tag.getTagName());
        if (tagFind == null) {
            tagFind = tagRepository.save(tag);
        }
        ImageTag imageTag = new ImageTag();
        imageTag.setImage(image);
        imageTag.setTag(tagFind);
        return imageTagRepository.save(imageTag);
    }

    /**
     * @param tagId TagId
     */
    @Override
    public void deleteTag(Integer tagId) {
        Tag tagFind = tagRepository.findById(tagId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tag inexistant"));
        tagRepository.delete(tagFind);
    }

    /**
     * @param imageId imageId
     * @param tagId   tagId
     */
    @Override
    public void deleteImageTag(Integer imageId, Integer tagId) {
        ImageTag imageTagFind = imageTagRepository.findByImage_ImageIdAndTag_TagId(imageId, tagId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Image tag inexistante"));
        imageTagRepository.delete(imageTagFind);
    }
}
