package com.epitech.pictsmanager.service.impl;

import java.util.List;
import java.util.Optional;

import com.epitech.pictsmanager.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import com.epitech.pictsmanager.model.User;
import com.epitech.pictsmanager.repository.UserRepository;
import org.springframework.web.server.ResponseStatusException;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * @param user userToSave
     * @return Utilisateur sauvegardé
     */
    @Override
    public User save(User user) {
        try {
            return this.userRepository.save(user);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "L'user rentre en conflit");
        }
    }

    /**
     * @return Tous les utilisateurs existants
     */
    @Override
    public List<User> findAll() {
        return this.userRepository.findAll();
    }

    /**
     * @param id userId
     * @return Utilisateur choisi par userId
     */
    @Override
    public User findById(int id) {
        return this.userRepository.findById(id).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST, "User inexistant"));
    }

    /**
     * @param email email
     * @return Utilisateur choisi par userEmail
     */
    @Override
    public Optional<User> findByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }
}
