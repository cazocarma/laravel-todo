<template>
  <div>
    <LoginForm v-if="view === 'login'" @changeView="view = $event" />
    <RegisterForm v-else @changeView="view = $event" />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import LoginForm from './LoginForm.vue'
import RegisterForm from './RegisterForm.vue'

const view = ref('login')
</script>
