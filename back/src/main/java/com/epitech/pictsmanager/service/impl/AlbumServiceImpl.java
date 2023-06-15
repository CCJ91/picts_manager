package com.epitech.pictsmanager.service.impl;

import com.epitech.pictsmanager.dto.AlbumFirstImageDTO;
import com.epitech.pictsmanager.dto.UserAlbumDTO;
import com.epitech.pictsmanager.model.*;
import com.epitech.pictsmanager.repository.AlbumRepository;
import com.epitech.pictsmanager.repository.AlbumSharedRepository;
import com.epitech.pictsmanager.service.AlbumService;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class AlbumServiceImpl implements AlbumService {

    private final AlbumRepository albumRepository;

    private final AlbumSharedRepository albumSharedRepository;

    private final ImageService imageService;

    private final UserService userService;

    private static final String ALBUM_NOT_FOUND = "Album not found";

    public AlbumServiceImpl(AlbumRepository albumRepository, AlbumSharedRepository albumSharedRepository,
                            ImageService imageService, UserService userService) {
        this.albumRepository = albumRepository;
        this.albumSharedRepository = albumSharedRepository;
        this.imageService = imageService;
        this.userService = userService;
    }

    /**
     * @param albumId albumId
     * @return Album choisi par son id
     */
    @Override
    public Optional<Album> getById(Integer albumId) {
        return albumRepository.findById(albumId);
    }

    /**
     * @return Tous les albums existants
     */
    @Override
    public List<Album> getAll() {
        return albumRepository.findAll();
    }

    /**
     * @param albumName albumName
     * @return Album choisi par son nom
     */
    @Override
    public List<Album> getByName(String albumName) {
        return albumRepository.findByAlbumName(albumName);
    }

    /**
     * @return Tous les albums publics
     */
    @Override
    public List<Album> getAlbumsPublic() {
        return albumRepository.findByAlbumIsPublic(1);
    }

    /**
     * @param userId UserId
     * @return Albums choisis par le userId
     */
    @Override
    public List<AlbumFirstImageDTO> getAlbumsForUser(Integer userId) {
        User user = this.userService.findById(userId);
        List<AlbumFirstImageDTO> albumFirstImageDTOList = new ArrayList<>();
        List<Album> albumList = albumRepository.findByAlbumIdOwner(user.getUserId());
        for (Album alb : albumList) {
            Image imageFirst = imageService.findFirstByAlbumAlbumId(alb.getAlbumId());
            AlbumFirstImageDTO albumFirstImageDTO = new AlbumFirstImageDTO();
            albumFirstImageDTO.setImage(imageFirst);
            albumFirstImageDTO.setAlbum(alb);
            albumFirstImageDTOList.add(albumFirstImageDTO);
        }
        return albumFirstImageDTOList;
    }

    /**
     * @param userId userId
     * @return Albums partagés avec l'utilisateur choisi par le userId
     */
    @Override
    public List<Album> getAlbumsShared(Integer userId) {
        List<AlbumShared> albumSharedList = albumSharedRepository.findByUserUserId(userId);
        List<Album> albumList = new ArrayList<>();
        for (AlbumShared albSh : albumSharedList) {
            Album albTmp = getById(albSh.getAlbumUser().getAlbumId()).orElseThrow(()
                    -> new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND));
            if (albTmp != null) {
                albumList.add(albTmp);
            }
        }
        return albumList;
    }

    /**
     * @param album albumToSave
     * @return Album sauvegardé
     */
    @Override
    public Album save(Album album) {
        this.userService.findById(album.getAlbumIdOwner());
        List<Album> albumList = getByName(album.getAlbumName());
        //for (Album alb : albumList) {
        //  if (alb.getAlbumIdOwner() == album.getAlbumIdOwner()) {
        //    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ce nom album existe déjà pour l'utilisateur");
        //  }
        //}
        return albumRepository.save(album);
    }

    /**
     * @param albumId albumId
     *                Permet de rendre public l'album choisi par albumId
     */
    @Override
    public void makeAlbumPublic(Integer albumId) {
        Album album = albumRepository.findById(albumId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND));
        if (album.getAlbumIsPublic() != 1) {
            album.setAlbumIsPublic(1);
            albumRepository.save(album);
            List<Image> imageList = imageService.findByAlbumId(albumId);
            for (Image img : imageList) {
                img.setImageIsPublic(1);
                imageService.saveImage(img);
            }
        } else {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cet album est déjà public");
        }
    }

    /**
     * @param albumId Albumid
     *                Permet de rendre un album privé
     */
    @Override
    public void makeAlbumPrivate(Integer albumId) {
        Album album = albumRepository.findById(albumId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND));
        if (album.getAlbumIsPublic() != 0) {
            album.setAlbumIsPublic(0);
            albumRepository.save(album);
            List<Image> imageList = imageService.findByAlbumId(albumId);
            for (Image img : imageList) {
                img.setImageIsPublic(0);
                imageService.saveImage(img);
            }
        } else {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cet album est déjà privé");
        }
    }

    /**
     * @param userAlbumDTO album to share with album
     *                     Permet de partager un album avec un ou plusieurs utilisateur(s) choisi
     */
    @Override
    public void sharedAlbumWithUser(UserAlbumDTO userAlbumDTO) {
        Album album = albumRepository.findById(userAlbumDTO.getAlbumId()).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND));
        for (String email : userAlbumDTO.getUserMailList()) {
            AlbumShared albumShared = new AlbumShared();
            User user = userService.findByEmail(email).orElse(null);
            albumShared.setAlbumUser(album);
            albumShared.setUser(user);
            albumSharedRepository.save(albumShared);
        }
    }

    /**
     * @param albumId albumToDelete
     *                Permet de supprimer l'album choisi par albumId
     */
    @Override
    public void deleteAlbum(Integer albumId) {
        Album album = albumRepository.findById(albumId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Album inexistant"));
        if (album.getAlbumIsDefault() == 1) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Album par défaut impossible à supprimer");
        }
        albumRepository.delete(album);
    }

}
