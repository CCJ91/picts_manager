package com.epitech.pictsmanager.service;

import com.epitech.pictsmanager.model.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    User save(User user);

    List<User> findAll();

    User findById(int id);

    Optional<User> findByEmail(String email);
}
