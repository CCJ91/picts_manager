package com.epitech.pictsmanager.service;

import com.epitech.pictsmanager.model.ImageTag;
import com.epitech.pictsmanager.model.Tag;

import java.util.List;
import java.util.Optional;

public interface TagService {

    Optional<Tag> getById(Integer tagId);

    Optional<ImageTag> getImageTagByIds(Integer tagId, Integer imageId);

    Tag getByName(String name);

    List<Tag> getTagsForImage(Integer imageId);

    List<Tag> getAll();

    List<ImageTag> getAllImagesTags();

    Tag save(Tag tag);

    ImageTag addTagToImage(Integer imageId, Tag tag);

    void deleteTag(Integer tagId);

    void deleteImageTag(Integer imageId, Integer tagId);
}
