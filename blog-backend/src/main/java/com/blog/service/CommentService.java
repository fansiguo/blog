package com.blog.service;

import com.blog.dto.CommentDTO;
import com.blog.entity.Article;
import com.blog.entity.Comment;
import com.blog.repository.CommentRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CommentService {
    private final CommentRepository commentRepository;
    private final ArticleService articleService;

    public CommentService(CommentRepository commentRepository, ArticleService articleService) {
        this.commentRepository = commentRepository;
        this.articleService = articleService;
    }

    public List<Comment> findByArticleId(Long articleId) {
        return commentRepository.findVisibleByArticleId(articleId);
    }

    public Page<Comment> findByArticleId(Long articleId, Pageable pageable) {
        return commentRepository.findVisibleByArticleId(articleId, pageable);
    }

    @Transactional(readOnly = true)
    public List<Comment> findAll() {
        List<Comment> comments = commentRepository.findAllWithArticle();
        for (Comment c : comments) {
            if (c.getArticle() != null) {
                c.setArticleTitle(c.getArticle().getTitle());
            }
        }
        return comments;
    }

    @Transactional(readOnly = true)
    public Page<Comment> findAll(Pageable pageable) {
        Page<Comment> page = commentRepository.findAllWithArticle(pageable);
        for (Comment c : page.getContent()) {
            if (c.getArticle() != null) {
                c.setArticleTitle(c.getArticle().getTitle());
            }
        }
        return page;
    }

    @Transactional
    public Comment toggleVisible(Long id) {
        Comment comment = commentRepository.findById(id).orElseThrow();
        comment.setVisible(!comment.getVisible());
        return commentRepository.save(comment);
    }

    @Transactional
    public Comment create(Long articleId, CommentDTO dto) {
        Article article = articleService.findById(articleId);
        if (article == null) {
            throw new IllegalArgumentException("文章不存在");
        }
        Comment comment = new Comment();
        comment.setNickname(dto.getNickname().trim());
        comment.setEmail(dto.getEmail());
        comment.setContent(dto.getContent().trim());
        comment.setArticle(article);
        return commentRepository.save(comment);
    }

    public void deleteById(Long id) {
        commentRepository.deleteById(id);
    }
}
