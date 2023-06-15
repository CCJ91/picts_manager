package com.epitech.pictsmanager.controller;

import com.epitech.pictsmanager.model.Album;
import com.epitech.pictsmanager.model.User;
import com.epitech.pictsmanager.service.AlbumService;
import com.epitech.pictsmanager.service.UserService;
import com.epitech.pictsmanager.utils.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/pictsmanager")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private AlbumService albumService;

    /**
     * @return Tous les utilisateurs
     */
    @GetMapping(value = "/users")
    public List<User> getUsers() {
        List<User> users = this.userService.findAll();
        for (User user : users) {
            user.setPassword(null);
        }
        return users;
    }

    /**
     * @param id userId
     * @return Utilisateur choisi
     * @throws ResponseStatusException
     */
    @GetMapping(value = "/user/{id}")
    public ResponseEntity<User> getUserById(@PathVariable(value = "id") String id) throws ResponseStatusException {
        Integer userId = Integer.valueOf(id);
        User user = this.userService.findById(userId);
        user.setPassword(null);
        return ResponseEntity.ok().body(user);
    }

    /**
     * @param user User
     * @return Utilisateur sauvegardé ainsi que la création de son album par défaut
     */
    @PostMapping(value = "/user/create")
    public ResponseEntity<User> insertUser(@RequestBody User user) {
        if (this.userService.findByEmail(user.getEmail()).isPresent()) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT, "User already exist");
        }
        if (!this.emailService.isValidEmail(user.getEmail())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email don't match with regex"
            );
        }
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        user.setPassword(encoder.encode(user.getPassword()));
        User newUser = this.userService.save(user);
        Album album = new Album();
        album.setAlbumIdOwner(newUser.getUserId());
        album.setAlbumName("Mon album");
        album.setAlbumIsDefault(1);
        album.setAlbumIsPublic(0);
        albumService.save(album);
        return ResponseEntity.ok().body(newUser);
    }

    /**
     * @param updatedInfo userUpdate
     * @return Utilisateur modifié
     */
    @PostMapping(value = "/user/update")
    public ResponseEntity<Object> updateUser(@RequestBody User updatedInfo) {
        User user = this.userService.findById(updatedInfo.getUserId());
        this.userService.save(updatedInfo);
        return ResponseEntity.ok().body(user);
    }

    /**
     * @param login user
     * @return Utilisateur connecté
     */
    @PostMapping(value = "/user/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody User login) {
        // Check if email exist in database
        User tryUser = this.userService.findByEmail(String.valueOf(login.getEmail()))
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST, "Email or password incorrect"));
        // Verify if password is correct
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        if (!encoder.matches(String.valueOf(login.getPassword()), tryUser.getPassword())) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email or password incorrect");
        }
        Map<String, Object> response = new HashMap<>();
        response.put("user", tryUser);
        response.put("token", "123");
        return ResponseEntity.ok().body(response);
    }
}
