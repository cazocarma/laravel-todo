<template>
  <div class="max-w-xl mx-auto py-8">
    <h1 class="text-2xl font-bold mb-6 text-center">Lista de Tareas</h1>

    <!-- Mensajes -->
    <div v-if="message" class="mb-4 text-center">
      <span
        :class="{
          'text-green-600': messageType === 'success',
          'text-red-600': messageType === 'error'
        }"
      >
        {{ message }}
      </span>
    </div>

    <!-- Loader -->
    <div v-if="loading" class="flex justify-center items-center py-8">
      <div class="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
    </div>

    <!-- Contenido principal -->
    <div v-else>
      <!-- Formulario para agregar -->
      <form @submit.prevent="addTask" class="flex gap-2 mb-6">
        <input
          v-model="newTask"
          type="text"
          placeholder="Nueva tarea"
          class="flex-1 border rounded px-3 py-2"
          :disabled="loading"
        />
        <button
          type="submit"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:bg-blue-400"
          :disabled="loading"
        >
          Agregar
        </button>
      </form>

      <!-- Lista -->
      <ul>
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex justify-between items-center border-b py-2"
        >
          <div class="flex items-center gap-2 w-full">
            <input
              type="checkbox"
              v-model="task.completed"
              @change="toggleComplete(task)"
              :disabled="loading"
            />

            <!-- Si está en modo edición -->
            <template v-if="editingTask === task.id">
              <input
                v-model="editTitle"
                class="flex-1 border rounded px-2 py-1"
                @keyup.enter="updateTask(task)"
                @blur="cancelEdit"
                :disabled="loading"
                autofocus
              />
            </template>

            <!-- Modo visual -->
            <template v-else>
              <span
                class="flex-1 cursor-pointer"
                :class="{ 'line-through text-gray-500': task.completed }"
                @dblclick="startEdit(task)"
              >
                {{ task.title }}
              </span>
            </template>
          </div>

          <button
            @click="deleteTask(task.id)"
            class="text-red-500 hover:text-red-700 disabled:text-gray-400"
            :disabled="loading"
          >
            Eliminar
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const tasks = ref([])
const newTask = ref('')
const editingTask = ref(null)
const editTitle = ref('')
const loading = ref(false)
const message = ref('')
const messageType = ref('success')

const showMessage = (text, type = 'success') => {
  message.value = text
  messageType.value = type
  setTimeout(() => (message.value = ''), 2500)
}

// Cabeceras con token
const API_HEADERS = () => ({
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': `Bearer ${localStorage.getItem('token')}`
})

// Manejo de errores de autenticación
const handleAuthError = (res) => {
  if (res.status === 401) {
    localStorage.removeItem('token')
    window.location.reload()
  }
}

const fetchTasks = async () => {
  loading.value = true
  try {
    const res = await fetch('/api/tasks', { headers: API_HEADERS() })
    if (res.status === 401) return handleAuthError(res)
    if (!res.ok) throw new Error()
    tasks.value = await res.json()
  } catch {
    showMessage('Error al cargar tareas', 'error')
  } finally {
    loading.value = false
  }
}

const addTask = async () => {
  if (!newTask.value.trim()) return
  loading.value = true
  try {
    const res = await fetch('/api/tasks', {
      method: 'POST',
      headers: API_HEADERS(),
      body: JSON.stringify({ title: newTask.value })
    })
    if (res.status === 401) return handleAuthError(res)
    if (!res.ok) throw new Error()
    newTask.value = ''
    showMessage('Tarea agregada')
    fetchTasks()
  } catch {
    showMessage('Error al agregar tarea', 'error')
  } finally {
    loading.value = false
  }
}

const toggleComplete = async (task) => {
  loading.value = true
  try {
    const res = await fetch(`/api/tasks/${task.id}`, {
      method: 'PUT',
      headers: API_HEADERS(),
      body: JSON.stringify({ completed: task.completed })
    })
    if (res.status === 401) return handleAuthError(res)
    if (!res.ok) throw new Error()
    showMessage('Tarea actualizada')
  } catch {
    showMessage('Error al actualizar', 'error')
  } finally {
    loading.value = false
  }
}

const startEdit = (task) => {
  editingTask.value = task.id
  editTitle.value = task.title
}

const cancelEdit = () => {
  editingTask.value = null
  editTitle.value = ''
}

const updateTask = async (task) => {
  loading.value = true
  try {
    const res = await fetch(`/api/tasks/${task.id}`, {
      method: 'PUT',
      headers: API_HEADERS(),
      body: JSON.stringify({ title: editTitle.value })
    })
    if (res.status === 401) return handleAuthError(res)
    if (!res.ok) throw new Error()
    showMessage('Tarea editada')
    cancelEdit()
    fetchTasks()
  } catch {
    showMessage('Error al editar', 'error')
  } finally {
    loading.value = false
  }
}

const deleteTask = async (id) => {
  loading.value = true
  try {
    const res = await fetch(`/api/tasks/${id}`, {
      method: 'DELETE',
      headers: API_HEADERS()
    })
    if (res.status === 401) return handleAuthError(res)
    if (!res.ok) throw new Error()
    showMessage('Tarea eliminada')
    fetchTasks()
  } catch {
    showMessage('Error al eliminar', 'error')
  } finally {
    loading.value = false
  }
}

onMounted(fetchTasks)
</script>

<style>
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
.animate-spin {
  animation: spin 1s linear infinite;
}
</style>
