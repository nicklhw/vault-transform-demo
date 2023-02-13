package com.hashicorp.transformdemo.repository;

import org.springframework.data.jpa.repository.Query;
import com.hashicorp.transformdemo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserJpaRepository extends JpaRepository<User, String> {
    @Query("SELECT u FROM User u where u.flag = :flag")
    List<User> findUsersByFlag(String flag);

    @Query("SELECT u FROM User u where u.username = :username")
    User findUserByUsername(String username);
}