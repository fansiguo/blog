package com.blog.android.ui.screen.admin

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Image
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.model.ArticleStatus
import com.blog.android.ui.components.LoadingView
import com.blog.android.ui.components.MarkdownText
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.AdminArticleEditViewModel

@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun AdminArticleEditScreen(
    viewModel: AdminArticleEditViewModel = hiltViewModel(),
    onBack: () -> Unit
) {
    val title by viewModel.title.collectAsState()
    val content by viewModel.content.collectAsState()
    val summary by viewModel.summary.collectAsState()
    val status by viewModel.status.collectAsState()
    val selectedCategoryId by viewModel.selectedCategoryId.collectAsState()
    val selectedTagIds by viewModel.selectedTagIds.collectAsState()
    val categories by viewModel.categories.collectAsState()
    val tags by viewModel.tags.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val isSaving by viewModel.isSaving.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()
    val isPreviewMode by viewModel.isPreviewMode.collectAsState()

    val context = LocalContext.current
    val imagePicker = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        uri?.let {
            val inputStream = context.contentResolver.openInputStream(it)
            val bytes = inputStream?.readBytes() ?: return@let
            inputStream.close()
            val mimeType = context.contentResolver.getType(it) ?: "image/jpeg"
            viewModel.uploadImage(bytes, "photo.jpg", mimeType)
        }
    }

    LaunchedEffect(Unit) { viewModel.loadData() }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(if (viewModel.articleId != null) "编辑文章" else "新建文章", fontSize = 16.sp) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "返回")
                    }
                },
                actions = {
                    TextButton(
                        onClick = { viewModel.save { onBack() } },
                        enabled = title.isNotEmpty() && !isSaving
                    ) {
                        if (isSaving) {
                            CircularProgressIndicator(modifier = Modifier.size(16.dp), strokeWidth = 2.dp)
                        } else {
                            Text("保存", fontWeight = FontWeight.SemiBold, color = BlogPrimary)
                        }
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = BlogSurface)
            )
        }
    ) { padding ->
        if (isLoading) {
            LoadingView(modifier = Modifier.padding(padding))
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .background(BlogBackground),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // Title
                item {
                    OutlinedTextField(
                        value = title,
                        onValueChange = { viewModel.title.value = it },
                        placeholder = { Text("文章标题") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                }

                // Summary
                item {
                    OutlinedTextField(
                        value = summary,
                        onValueChange = { viewModel.summary.value = it },
                        placeholder = { Text("文章摘要") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                }

                // Editor tabs
                item {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(8.dp))
                            .background(BlogSurface)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(BlogBorderLight)
                                .padding(4.dp),
                            horizontalArrangement = Arrangement.spacedBy(4.dp)
                        ) {
                            TextButton(onClick = { viewModel.isPreviewMode.value = false }) {
                                Text(
                                    "编写",
                                    color = if (!isPreviewMode) BlogPrimary else BlogTextSecondary,
                                    fontWeight = if (!isPreviewMode) FontWeight.SemiBold else FontWeight.Normal
                                )
                            }
                            TextButton(onClick = { viewModel.isPreviewMode.value = true }) {
                                Text(
                                    "预览",
                                    color = if (isPreviewMode) BlogPrimary else BlogTextSecondary,
                                    fontWeight = if (isPreviewMode) FontWeight.SemiBold else FontWeight.Normal
                                )
                            }
                            Spacer(Modifier.weight(1f))
                            IconButton(onClick = { imagePicker.launch("image/*") }) {
                                Icon(Icons.Default.Image, contentDescription = "上传图片", tint = BlogTextSecondary)
                            }
                        }
                        HorizontalDivider(color = BlogBorder)

                        if (isPreviewMode) {
                            MarkdownText(
                                markdown = content,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .heightIn(min = 300.dp)
                                    .padding(12.dp)
                            )
                        } else {
                            OutlinedTextField(
                                value = content,
                                onValueChange = { viewModel.content.value = it },
                                placeholder = { Text("使用 Markdown 编写文章内容...") },
                                minLines = 15,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(4.dp),
                                colors = OutlinedTextFieldDefaults.colors(
                                    unfocusedBorderColor = BlogBorder.copy(alpha = 0f),
                                    focusedBorderColor = BlogBorder.copy(alpha = 0f)
                                )
                            )
                        }
                    }
                }

                // Settings
                item {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(8.dp))
                            .background(BlogSurface)
                            .padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        Text("发布设置", fontSize = 15.sp, fontWeight = FontWeight.SemiBold)

                        // Status
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            FilterChip(
                                selected = status == ArticleStatus.DRAFT,
                                onClick = { viewModel.status.value = ArticleStatus.DRAFT },
                                label = { Text("草稿") }
                            )
                            FilterChip(
                                selected = status == ArticleStatus.PUBLISHED,
                                onClick = { viewModel.status.value = ArticleStatus.PUBLISHED },
                                label = { Text("发布") }
                            )
                        }

                        // Category
                        var categoryExpanded by remember { mutableStateOf(false) }
                        ExposedDropdownMenuBox(
                            expanded = categoryExpanded,
                            onExpandedChange = { categoryExpanded = it }
                        ) {
                            OutlinedTextField(
                                value = categories.find { it.id == selectedCategoryId }?.name ?: "无分类",
                                onValueChange = {},
                                readOnly = true,
                                label = { Text("分类") },
                                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = categoryExpanded) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .menuAnchor()
                            )
                            ExposedDropdownMenu(
                                expanded = categoryExpanded,
                                onDismissRequest = { categoryExpanded = false }
                            ) {
                                DropdownMenuItem(
                                    text = { Text("无分类") },
                                    onClick = {
                                        viewModel.selectedCategoryId.value = null
                                        categoryExpanded = false
                                    }
                                )
                                categories.forEach { cat ->
                                    DropdownMenuItem(
                                        text = { Text(cat.name) },
                                        onClick = {
                                            viewModel.selectedCategoryId.value = cat.id
                                            categoryExpanded = false
                                        }
                                    )
                                }
                            }
                        }

                        // Tags
                        Text("标签", fontSize = 14.sp, fontWeight = FontWeight.Medium, color = BlogTextSecondary)
                        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            tags.forEach { tag ->
                                FilterChip(
                                    selected = selectedTagIds.contains(tag.id),
                                    onClick = { viewModel.toggleTag(tag.id) },
                                    label = { Text(tag.name) }
                                )
                            }
                        }
                    }
                }

                errorMessage?.let {
                    item { Text(it, fontSize = 12.sp, color = BlogDanger) }
                }
            }
        }
    }
}
