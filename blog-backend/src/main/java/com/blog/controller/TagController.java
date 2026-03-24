package com.blog.controller;

import com.blog.entity.Tag;
import com.blog.service.TagService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class TagController {
    private final TagService tagService;

    public TagController(TagService tagService) {
        this.tagService = tagService;
    }

    @GetMapping("/tags")
    public List<Tag> list() {
        return tagService.findAll();
    }

    @PostMapping("/admin/tags")
    public Tag create(@RequestBody Tag tag) {
        return tagService.save(tag);
    }

    @PutMapping("/admin/tags/{id}")
    public Tag update(@PathVariable Long id, @RequestBody Tag tag) {
        tag.setId(id);
        return tagService.save(tag);
    }

    @DeleteMapping("/admin/tags/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tagService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
