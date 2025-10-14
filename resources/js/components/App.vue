<template>
  <div>
    <button
      v-if="isAuthenticated"
      @click="logout"
      class="absolute top-4 right-4 text-sm text-red-600 hover:underline"
    >
      Cerrar sesión
    </button>

    <TodoApp v-if="isAuthenticated" />
    <AuthWrapper v-else />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TodoApp from './TodoApp.vue'
import AuthWrapper from './Auth/AuthWrapper.vue'

const isAuthenticated = ref(!!localStorage.getItem('token'))

const logout = async () => {
  const token = localStorage.getItem('token')
  if (!token) return
  await fetch('/api/logout', {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}` },
  })
  localStorage.removeItem('token')
  window.location.reload()
}
</script>
