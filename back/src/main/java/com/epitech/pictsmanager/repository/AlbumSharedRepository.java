package com.epitech.pictsmanager.repository;

import com.epitech.pictsmanager.model.AlbumShared;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AlbumSharedRepository extends JpaRepository<AlbumShared, Integer> {

    List<AlbumShared> findByUserUserId(Integer userId);

    AlbumShared findByUserUserIdAndAlbumUserAlbumId(Integer userId, Integer albumId);

}