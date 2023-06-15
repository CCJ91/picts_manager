package com.epitech.pictsmanager.repository;

import com.epitech.pictsmanager.model.ImageTag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ImageTagRepository extends JpaRepository<ImageTag, Integer> {

    List<ImageTag> findByTagTagId(Integer tagId);

    List<ImageTag> findByImageImageId(Integer imageId);

    Optional<ImageTag> findByImage_ImageIdAndTag_TagId(Integer imageId, Integer tagId);
}
