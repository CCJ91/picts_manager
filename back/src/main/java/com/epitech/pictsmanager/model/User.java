package com.epitech.pictsmanager.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.util.Set;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    @Column(name = "username", nullable = false, length = 25)
    @NotBlank(message = "username is mandatory")
    private String username;

    @Column(name = "email", unique = true, nullable = false, length = 50)
    @NotBlank(message = "email is mandatory")
    private String email;

    @Column(name = "password", nullable = false, length = 255)
//    @NotBlank(message = "password is mandatory")
    // @Digits(integer = Integer.MAX_VALUE, fraction = 0, message = "must be an
    // integer")
    private String password;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<AlbumShared> albumSharedSet;

    public int getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void updateUser(String email, String username) {
        this.email = email;
        this.username = username;
    }
}
