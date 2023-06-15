package com.epitech.pictsmanager.controller;

import com.epitech.pictsmanager.dto.AlbumFirstImageDTO;
import com.epitech.pictsmanager.dto.UserAlbumDTO;
import com.epitech.pictsmanager.model.Album;
import com.epitech.pictsmanager.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/pictsmanager")
public class AlbumController {

    @Autowired
    private AlbumService albumService;

    private static final String ALBUM_NOT_FOUND = "Album not found ";

    /**
     * @param id albumId
     * @return Album choisi
     */
    @GetMapping(value = "/album/{id}")
    public ResponseEntity<Album> getById(@PathVariable(value = "id") String id) {
        Integer albumId = Integer.valueOf(id);
        Album albumFind = albumService.getById(albumId).orElseThrow(()
                -> new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND + albumId));
        return ResponseEntity.ok().body(albumFind);
    }

    /**
     * @return Tous les albums existants
     */
    @GetMapping(value = "/albums")
    public ResponseEntity<List<Album>> getAll() {
        List<Album> albumList = albumService.getAll();
        if (albumList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND);
        } else {
            return ResponseEntity.ok().body(albumList);
        }
    }

    /**
     * @return Tous les albums publics
     */
    @GetMapping(value = "/albums/public")
    public ResponseEntity<List<Album>> getAlbumsPublic() {
        List<Album> albumList = albumService.getAlbumsPublic();
        if (albumList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND);
        } else {
            return ResponseEntity.ok().body(albumList);
        }
    }

    /**
     * @param id userId
     * @return Tous les albums de l'utilisateur choisi
     */
    @GetMapping(value = "/albums/user/{id}")
    public ResponseEntity<List<AlbumFirstImageDTO>> getAlbumsForUser(@PathVariable(name = "id") String id) {
        Integer userId = Integer.valueOf(id);
        List<AlbumFirstImageDTO> albumList = albumService.getAlbumsForUser(userId);
        if (albumList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND);
        }
        return ResponseEntity.ok().body(albumList);
    }

    /**
     * @param id userId
     * @return Tous les albums partagés avec l'utilisateur choisi
     */
    @GetMapping(value = "/albums/user/shared/{id}")
    public ResponseEntity<List<Album>> getAlbumsShared(@PathVariable(name = "id") String id) {
        Integer userId = Integer.valueOf(id);
        List<Album> albumList = albumService.getAlbumsShared(userId);
        if (albumList.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ALBUM_NOT_FOUND);
        }
        return ResponseEntity.ok().body(albumList);
    }

    /**
     * @param userAlbumDTO albumId et userId
     * @return Permet de partager un album avec l'utilisateur choisi
     */
    @PostMapping(value = "/album/shared")
    public ResponseEntity<String> sharedAlbumWithUser(@RequestBody UserAlbumDTO userAlbumDTO) {
        albumService.sharedAlbumWithUser(userAlbumDTO);
        return ResponseEntity.ok().body("Album partagé");
    }

    /**
     * @param album Album
     * @return Album sauvegardé
     */
    @PostMapping(value = "/album")
    public ResponseEntity<Album> saveAlbum(@RequestBody Album album) {
        Album albumSave = albumService.save(album);
        return ResponseEntity.ok().body(albumSave);
    }

    /**
     * @param id albumId
     * @return Permet de rendre un album public ainsi que ses images
     */
    @PostMapping(value = "/album/public/{id}")
    public ResponseEntity<String> makeAlbumPublic(@PathVariable(name = "id") String id) {
        Integer albumId = Integer.valueOf(id);
        albumService.makeAlbumPublic(albumId);
        return ResponseEntity.ok().body("Album rendu public");
    }

    @PostMapping(value = "/album/private/{id}")
    public ResponseEntity<String> makeAlbumPrivate(@PathVariable(name = "id") String id) {
        Integer albumId = Integer.valueOf(id);
        albumService.makeAlbumPrivate(albumId);
        return ResponseEntity.ok().body("Album rendu privé");
    }

    /**
     * @param album Album
     * @return Album modifié
     */
    @PutMapping(value = "/album")
    public ResponseEntity<Album> updateAlbum(@RequestBody Album album) {
        Album albumUpdate = albumService.save(album);
        return ResponseEntity.ok().body(albumUpdate);
    }

    /**
     * @param id albumId
     * @return Permet de supprimer l'album
     */
    @DeleteMapping(value = "/album/{id}")
    public ResponseEntity<String> deleteAlbum(@PathVariable(value = "id") String id) {
        Integer albumId = Integer.valueOf(id);
        albumService.deleteAlbum(albumId);
        return ResponseEntity.ok().body("Album supprimé");
    }

}
