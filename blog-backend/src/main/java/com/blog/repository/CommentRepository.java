package com.blog.repository;

import com.blog.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByArticleIdOrderByCreatedAtDesc(Long articleId);
    @Query("SELECT c FROM Comment c WHERE c.articleId = :articleId AND (c.visible = true OR c.visible IS NULL) ORDER BY c.createdAt DESC")
    List<Comment> findVisibleByArticleId(Long articleId);

    @Query("SELECT c FROM Comment c WHERE c.articleId = :articleId AND (c.visible = true OR c.visible IS NULL)")
    Page<Comment> findVisibleByArticleId(Long articleId, Pageable pageable);

    @Query("SELECT c FROM Comment c LEFT JOIN FETCH c.article ORDER BY c.createdAt DESC")
    List<Comment> findAllWithArticle();

    Page<Comment> findAll(Pageable pageable);
}
