package com.blog.controller;

import com.blog.dto.CommentDTO;
import com.blog.entity.Comment;
import com.blog.service.CommentService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CommentController {
    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @GetMapping("/api/articles/{articleId}/comments")
    public Page<Comment> list(@PathVariable Long articleId,
                              @RequestParam(defaultValue = "0") int page,
                              @RequestParam(defaultValue = "10") int size) {
        return commentService.findByArticleId(articleId,
                PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
    }

    @PostMapping("/api/articles/{articleId}/comments")
    public ResponseEntity<Comment> create(@PathVariable Long articleId,
                                          @Valid @RequestBody CommentDTO dto) {
        Comment comment = commentService.create(articleId, dto);
        return ResponseEntity.ok(comment);
    }

    @GetMapping("/api/admin/comments")
    public Page<Comment> listAll(@RequestParam(defaultValue = "0") int page,
                                 @RequestParam(defaultValue = "10") int size) {
        return commentService.findAll(PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
    }

    @PutMapping("/api/admin/comments/{id}/toggle-visible")
    public ResponseEntity<Comment> toggleVisible(@PathVariable Long id) {
        return ResponseEntity.ok(commentService.toggleVisible(id));
    }

    @DeleteMapping("/api/admin/comments/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        commentService.deleteById(id);
        return ResponseEntity.ok().build();
    }
}
