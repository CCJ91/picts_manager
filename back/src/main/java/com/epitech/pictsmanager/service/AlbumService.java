package com.epitech.pictsmanager.service;

import com.epitech.pictsmanager.dto.AlbumFirstImageDTO;
import com.epitech.pictsmanager.dto.UserAlbumDTO;
import com.epitech.pictsmanager.model.Album;

import java.util.List;
import java.util.Optional;

public interface AlbumService {

    Optional<Album> getById(Integer albumId);

    List<Album> getAll();

    List<Album> getByName(String albumName);

    List<Album> getAlbumsPublic();

    List<AlbumFirstImageDTO> getAlbumsForUser(Integer userI);

    List<Album> getAlbumsShared(Integer userId);

    Album save(Album album);

    void makeAlbumPublic(Integer albumId);

    void makeAlbumPrivate(Integer albumId);

    void sharedAlbumWithUser(UserAlbumDTO userAlbumDTO);

    void deleteAlbum(Integer albumId);
}
