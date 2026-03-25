package com.blog.repository;

import com.blog.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByArticleIdOrderByCreatedAtDesc(Long articleId);
    List<Comment> findByArticleIdAndVisibleTrueOrderByCreatedAtDesc(Long articleId);

    @Query("SELECT c FROM Comment c JOIN FETCH c.article ORDER BY c.createdAt DESC")
    List<Comment> findAllWithArticle();
}
