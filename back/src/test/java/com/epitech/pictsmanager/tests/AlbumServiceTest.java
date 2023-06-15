package com.epitech.pictsmanager.tests;

import com.epitech.pictsmanager.model.Album;
import com.epitech.pictsmanager.repository.AlbumRepository;
import com.epitech.pictsmanager.repository.AlbumSharedRepository;
import com.epitech.pictsmanager.service.ImageService;
import com.epitech.pictsmanager.service.UserService;
import com.epitech.pictsmanager.service.impl.AlbumServiceImpl;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;

@ActiveProfiles("test")
class AlbumServiceTest {

    private final AlbumRepository albumRepository = Mockito.mock(AlbumRepository.class);

    private final AlbumSharedRepository albumSharedRepository = Mockito.mock(AlbumSharedRepository.class);

    private final ImageService imageService = Mockito.mock(ImageService.class);

    private final UserService userService = Mockito.mock(UserService.class);

    private AlbumServiceImpl albumServiceImpl;

    @BeforeEach
    void initAlbumService() {
        albumServiceImpl = new AlbumServiceImpl(albumRepository, albumSharedRepository, imageService, userService);
    }

    @Test
    void getByIdTest() {
        Optional<Album> albumToReturn = Optional.of(new Album());
        Mockito.when(albumRepository.findById(1)).thenReturn(albumToReturn);
        Optional<Album> albumSave = albumServiceImpl.getById(1);
        Assertions.assertEquals(albumToReturn, albumSave);
    }

    @Test
    void getByIdFailedTest() {
        Optional<Album> albumToReturn = Optional.of(new Album());
        Mockito.when(albumRepository.findById(1)).thenReturn(albumToReturn);
        Optional<Album> albumSave = albumServiceImpl.getById(2);
        Assertions.assertNotEquals(albumToReturn, albumSave);
    }

    @Test
    void getAllTest() {
        List<Album> albumListToReturn = new ArrayList<>();
        Mockito.when(albumRepository.findAll()).thenReturn(albumListToReturn);
        List<Album> albumList = albumServiceImpl.getAll();
        Assertions.assertEquals(albumListToReturn, albumList);
    }

    @Test
    void getByNameTest() {
        List<Album> albumToReturn = new ArrayList<>();
        Mockito.when(albumRepository.findByAlbumName("name")).thenReturn(albumToReturn);
        List<Album> albumList = albumServiceImpl.getByName("name");
        Assertions.assertEquals(albumToReturn, albumList);
    }

    @Test
    void getAlbumsPublicTest() {
        List<Album> albumToReturn = new ArrayList<>();
        Mockito.when(albumRepository.findByAlbumIsPublic(1)).thenReturn(albumToReturn);
        List<Album> albumList = albumServiceImpl.getAlbumsPublic();
        Assertions.assertEquals(albumToReturn, albumList);
    }

    @Test
    void getAlbumsPublicFailedTest() {
        Mockito.when(albumRepository.findByAlbumIsPublic(0)).thenReturn(null);
        List<Album> albumList = albumServiceImpl.getAlbumsPublic();
        Assertions.assertNotEquals(null, albumList);
    }

    @Test
    void saveTest() {
        Album albumToReturn = new Album();
        Album albumToSave = new Album();
        Mockito.when(albumRepository.save(any(Album.class))).thenReturn(albumToReturn);
        Album album = albumServiceImpl.save(albumToSave);
        Assertions.assertEquals(albumToReturn, album);
    }

}
