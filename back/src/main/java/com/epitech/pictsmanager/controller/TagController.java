package com.epitech.pictsmanager.controller;

import com.epitech.pictsmanager.model.ImageTag;
import com.epitech.pictsmanager.model.Tag;
import com.epitech.pictsmanager.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/pictsmanager")
public class TagController {

    @Autowired
    TagService tagService;

    /**
     * @return Tous les tags existants
     */
    @GetMapping(value = "/tags")
    public ResponseEntity<List<Tag>> getAllTags() {
        List<Tag> tagList = tagService.getAll();
        return ResponseEntity.ok().body(tagList);
    }

    /**
     * @param id imageId
     * @return Tous les tags associés à l'image choisie par imageId
     */
    @GetMapping(value = "/tags/image/{id}")
    public ResponseEntity<List<Tag>> getTagsForImage(@PathVariable(name = "id") String id) {
        Integer imageId = Integer.valueOf(id);
        List<Tag> tagList = tagService.getTagsForImage(imageId);
        return ResponseEntity.ok().body(tagList);
    }

    /**
     * @return Toutes les imagesTags existantes
     */
    @GetMapping(value = "/tags/all")
    public ResponseEntity<List<ImageTag>> getAllImagesTags() {
        List<ImageTag> imageTagList = tagService.getAllImagesTags();
        return ResponseEntity.ok().body(imageTagList);
    }

    /**
     * @param tag Tag
     * @return Tag sauvegardé
     */
    @PostMapping(value = "/tag")
    public ResponseEntity<Tag> createTag(@RequestBody Tag tag) {
        Tag tagSave = tagService.save(tag);
        return ResponseEntity.ok().body(tagSave);
    }

    /**
     * @param id  imageId
     * @param tag Tag
     * @return Imagetag ajoutée
     */
    @PostMapping(value = "/tag/image/{id}")
    public ResponseEntity<ImageTag> addTagToImage(@PathVariable(name = "id") String id, @RequestBody Tag tag) {
        Integer imageId = Integer.valueOf(id);
        ImageTag imageTag = tagService.addTagToImage(imageId, tag);
        return ResponseEntity.ok().body(imageTag);
    }

    /**
     * @param id tagId
     * @return Tag supprimé
     */
    @DeleteMapping(value = "/tag/{id}")
    public ResponseEntity<String> deleteTag(@PathVariable(name = "id") String id) {
        Integer tagId = Integer.valueOf(id);
        tagService.deleteTag(tagId);
        return ResponseEntity.ok().body("Tag supprimé");
    }

    /**
     * @param idTag   tagId
     * @param idImage imageId
     * @return ImageTag supprimé
     */
    @DeleteMapping(value = "/tag/image/{idTag}/{idImage}")
    public ResponseEntity<String> deleteImageTag(@PathVariable(name = "idTag") String idTag, @PathVariable(name = "idImage") String idImage) {
        Integer tagId = Integer.valueOf(idTag);
        Integer imageId = Integer.valueOf(idImage);
        tagService.deleteImageTag(imageId, tagId);
        return ResponseEntity.ok().body("Image tag supprimée");
    }
}
