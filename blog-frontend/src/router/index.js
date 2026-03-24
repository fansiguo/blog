import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: () => import('../views/Home.vue') },
  { path: '/article/:id', component: () => import('../views/ArticleDetail.vue') },
  { path: '/login', component: () => import('../views/Login.vue') },
  {
    path: '/admin',
    component: () => import('../views/admin/Dashboard.vue'),
    meta: { requiresAuth: true },
    children: [
      { path: '', redirect: '/admin/articles' },
      { path: 'articles', component: () => import('../views/admin/ArticleList.vue') },
      { path: 'articles/new', component: () => import('../views/admin/ArticleEdit.vue') },
      { path: 'articles/:id/edit', component: () => import('../views/admin/ArticleEdit.vue') },
      { path: 'categories', component: () => import('../views/admin/CategoryList.vue') },
      { path: 'tags', component: () => import('../views/admin/TagList.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    const token = localStorage.getItem('token')
    if (!token) {
      next('/login')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
