package com.blog.android.ui.screen.admin

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.blog.android.ui.components.LoadingView
import com.blog.android.ui.theme.*
import com.blog.android.viewmodel.AdminTagViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdminTagScreen(viewModel: AdminTagViewModel = hiltViewModel()) {
    val tags by viewModel.tags.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()

    var newName by remember { mutableStateOf("") }
    var editingId by remember { mutableStateOf<Long?>(null) }
    var editingName by remember { mutableStateOf("") }
    var deleteTarget by remember { mutableStateOf<Long?>(null) }

    LaunchedEffect(Unit) {
        if (tags.isEmpty()) viewModel.loadTags()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("标签管理") },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = BlogSurface)
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(BlogBackground)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BlogSurface)
                    .padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = newName,
                    onValueChange = { newName = it },
                    placeholder = { Text("新建标签名称") },
                    singleLine = true,
                    modifier = Modifier.weight(1f)
                )
                Button(
                    onClick = { viewModel.createTag(newName) { newName = "" } },
                    enabled = newName.isNotEmpty(),
                    colors = ButtonDefaults.buttonColors(containerColor = BlogPrimary)
                ) { Text("添加") }
            }

            HorizontalDivider(color = BlogBorder)

            if (isLoading && tags.isEmpty()) {
                LoadingView()
            } else {
                LazyColumn(modifier = Modifier.fillMaxSize()) {
                    items(tags, key = { it.id }) { tag ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(BlogSurface)
                                .padding(horizontal = 16.dp, vertical = 12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            if (editingId == tag.id) {
                                OutlinedTextField(
                                    value = editingName,
                                    onValueChange = { editingName = it },
                                    singleLine = true,
                                    modifier = Modifier.weight(1f)
                                )
                                TextButton(onClick = {
                                    viewModel.updateTag(tag.id, editingName) { editingId = null }
                                }) { Text("保存") }
                                TextButton(onClick = { editingId = null }) { Text("取消") }
                            } else {
                                Text(tag.name, fontSize = 15.sp, modifier = Modifier.weight(1f))
                                tag.createdAt?.let {
                                    Text(it.take(10), fontSize = 12.sp, color = BlogTextMuted)
                                }
                                IconButton(onClick = {
                                    editingId = tag.id
                                    editingName = tag.name
                                }) {
                                    Icon(Icons.Default.Edit, contentDescription = "编辑", tint = BlogPrimary)
                                }
                                IconButton(onClick = { deleteTarget = tag.id }) {
                                    Icon(Icons.Default.Delete, contentDescription = "删除", tint = BlogDanger)
                                }
                            }
                        }
                        HorizontalDivider(color = BlogBorderLight)
                    }
                }
            }
        }
    }

    deleteTarget?.let { id ->
        AlertDialog(
            onDismissRequest = { deleteTarget = null },
            title = { Text("确认删除") },
            text = { Text("确定要删除此标签吗？") },
            confirmButton = {
                TextButton(onClick = {
                    viewModel.deleteTag(id)
                    deleteTarget = null
                }) { Text("删除", color = BlogDanger) }
            },
            dismissButton = {
                TextButton(onClick = { deleteTarget = null }) { Text("取消") }
            }
        )
    }
}
