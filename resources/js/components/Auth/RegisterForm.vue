<template>
  <div class="max-w-sm mx-auto py-8">
    <h2 class="text-2xl font-bold mb-4 text-center">Registro</h2>

    <form @submit.prevent="register" class="space-y-4">
      <input v-model="name" type="text" placeholder="Nombre" class="w-full border rounded px-3 py-2" required />
      <input v-model="email" type="email" placeholder="Email" class="w-full border rounded px-3 py-2" required />
      <input v-model="password" type="password" placeholder="Contraseña" class="w-full border rounded px-3 py-2" required />

      <button class="w-full bg-green-600 text-white py-2 rounded hover:bg-green-700" :disabled="loading">
        {{ loading ? 'Creando...' : 'Registrarme' }}
      </button>
    </form>

    <p class="mt-4 text-center">
      ¿Ya tienes cuenta?
      <a href="#" @click.prevent="$emit('changeView', 'login')" class="text-blue-600 hover:underline">Inicia sesión</a>
    </p>

    <p v-if="error" class="text-red-600 mt-4 text-center">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const name = ref('')
const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

// Encabezados estándar para peticiones JSON
const API_HEADERS = () => ({
  'Content-Type': 'application/json',
  'Accept': 'application/json'
})

const register = async () => {
  loading.value = true
  error.value = ''
  try {
    const res = await fetch('/api/register', {
      method: 'POST',
      headers: API_HEADERS(),
      body: JSON.stringify({
        name: name.value,
        email: email.value,
        password: password.value
      })
    })

    if (!res.ok) {
      const err = await res.json().catch(() => ({}))
      throw new Error(err.message || 'Error al registrar usuario')
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
