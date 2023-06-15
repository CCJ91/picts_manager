package com.epitech.pictsmanager.tests;

import com.epitech.pictsmanager.model.User;
import com.epitech.pictsmanager.repository.UserRepository;
import com.epitech.pictsmanager.service.impl.UserServiceImpl;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

@ActiveProfiles("test")
class UserServiceTest {

    private final UserRepository userRepository = Mockito.mock(UserRepository.class);

    private UserServiceImpl userService;

    @BeforeEach
    void initUserService() {
        userService = new UserServiceImpl(userRepository);
    }

    @Test
    void saveTest() {
        User userToReturn = new User();
        User userToSave = new User();
        Mockito.when(userRepository.save(any(User.class))).thenReturn(userToReturn);
        User user = userService.save(userToSave);
        Assertions.assertEquals(userToReturn, user);
    }

    @Test
    void findAllTest() {
        List<User> usersToReturn = new ArrayList<>();
        Mockito.when(userRepository.findAll()).thenReturn(usersToReturn);
        List<User> userList = userService.findAll();
        Assertions.assertEquals(usersToReturn, userList);
    }

    @Test
    void finbByIdTest() {
        User userToReturn = new User();
        Mockito.when(userRepository.findById(1)).thenReturn(Optional.of(userToReturn));
        User user = userService.findById(1);
        Assertions.assertEquals(userToReturn, user);
    }

    @Test
    void finbByIdExceptionTest() {
        ResponseStatusException e = Assertions.assertThrows(ResponseStatusException.class, () -> {
            User userToReturn = new User();
            Mockito.when(userRepository.findById(1)).thenReturn(Optional.of(userToReturn));
            User user = userService.findById(2);
        });
        Assertions.assertEquals("User inexistant", e.getReason());
        Assertions.assertEquals(BAD_REQUEST, e.getStatusCode());
    }

    @Test
    void findByEmailTest() {
        Optional<User> userToReturn = Optional.of(new User());
        Mockito.when(userRepository.findByEmail("name")).thenReturn(userToReturn);
        Optional<User> user = userService.findByEmail("name");
        Assertions.assertEquals(userToReturn, user);
    }

    @Test
    void findByEmailFailedTest() {
        Optional<User> userToReturn = Optional.of(new User());
        Mockito.when(userRepository.findByEmail("name")).thenReturn(userToReturn);
        Optional<User> user = userService.findByEmail("titi");
        Assertions.assertNotEquals(userToReturn, user);
    }
}