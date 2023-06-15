package com.epitech.pictsmanager.repository;

import com.epitech.pictsmanager.model.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ImageRepository extends JpaRepository<Image, Integer> {

    List<Image> findByAlbum_AlbumId(Integer albumId);

    Image findFirstByAlbumAlbumId(Integer imageId);
}
