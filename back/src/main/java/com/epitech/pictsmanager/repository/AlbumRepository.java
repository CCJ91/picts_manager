package com.epitech.pictsmanager.repository;

import com.epitech.pictsmanager.model.Album;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AlbumRepository extends JpaRepository<Album, Integer> {

    List<Album> findByAlbumName(String albumName);

    List<Album> findByAlbumIsPublic(Integer isPublic);

    List<Album> findByAlbumIdOwner(Integer userId);
}
