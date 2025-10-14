<template>
  <div class="max-w-sm mx-auto py-8">
    <h2 class="text-2xl font-bold mb-4 text-center">Iniciar Sesión</h2>

    <form @submit.prevent="login" class="space-y-4">
      <input v-model="email" type="email" placeholder="Email" class="w-full border rounded px-3 py-2" required />
      <input v-model="password" type="password" placeholder="Contraseña" class="w-full border rounded px-3 py-2" required />

      <button class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700" :disabled="loading">
        {{ loading ? 'Ingresando...' : 'Entrar' }}
      </button>
    </form>

    <p class="mt-4 text-center">
      ¿No tienes cuenta?
      <a href="#" @click.prevent="$emit('changeView', 'register')" class="text-blue-600 hover:underline">Regístrate</a>
    </p>

    <p v-if="error" class="text-red-600 mt-4 text-center">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

const API_HEADERS = () => ({
  'Content-Type': 'application/json',
  'Accept': 'application/json'
})

const login = async () => {
  loading.value = true
  error.value = ''
  try {
    const res = await fetch('/api/login', {
      method: 'POST',
      headers: API_HEADERS(),
      body: JSON.stringify({ email: email.value, password: password.value })
    })
    if (!res.ok) {
      const err = await res.json().catch(() => ({}))
      throw new Error(err.message || 'Credenciales inválidas')
    }
    const data = await res.json()
    localStorage.setItem('token', data.token)
    window.location.reload()
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}
</script>
