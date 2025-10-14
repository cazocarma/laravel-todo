<template>
  <div class="max-w-xl mx-auto py-8">
    <h1 class="text-2xl font-bold mb-6 text-center">Lista de Tareas</h1>

    <!-- Formulario -->
    <form @submit.prevent="addTask" class="flex gap-2 mb-6">
      <input
        v-model="newTask"
        type="text"
        placeholder="Nueva tarea"
        class="flex-1 border rounded px-3 py-2"
      />
      <button
        type="submit"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
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
        <label class="flex items-center gap-2">
          <input type="checkbox" v-model="task.completed" @change="toggleComplete(task)" />
          <span :class="{ 'line-through text-gray-500': task.completed }">
            {{ task.title }}
          </span>
        </label>
        <button
          @click="deleteTask(task.id)"
          class="text-red-500 hover:text-red-700"
        >
          Eliminar
        </button>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const tasks = ref([])
const newTask = ref('')

const fetchTasks = async () => {
  const res = await fetch('/api/tasks')
  tasks.value = await res.json()
}

const addTask = async () => {
  if (!newTask.value.trim()) return
  await fetch('/api/tasks', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title: newTask.value })
  })
  newTask.value = ''
  fetchTasks()
}

const toggleComplete = async (task) => {
  await fetch(`/api/tasks/${task.id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ completed: task.completed })
  })
}

const deleteTask = async (id) => {
  await fetch(`/api/tasks/${id}`, { method: 'DELETE' })
  fetchTasks()
}

onMounted(fetchTasks)
</script>
