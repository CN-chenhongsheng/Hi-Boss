<template>
  <div class="login">
    <LoginHeader />
    <LoginLayout />
    <div class="form animate-up">
      <LoginForm />
    </div>
  </div>
</template>

<script setup lang="ts">
import LoginHeader from './components/LoginHeader.vue'
import LoginLayout from './components/LoginLayout.vue'
import LoginForm from './components/LoginForm.vue'
</script>

<style lang="scss" scoped>
@use './index';
@use '@styles/variables.scss' as *;

@keyframes slideInUp {
  from {
    transform: translate(-50%, 20%);
    opacity: 0;
  }
  to {
    transform: translate(-50%, -50%);
    opacity: 1;
  }
}

.form {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 440px;
  height: 610px;
  padding: 0 25px;
  margin: auto;
  overflow: hidden;
  background-size: cover;
  background-color: #ffffffe0;
  filter: drop-shadow(0 0 10px rgba(0, 0, 0, 0.1));
  backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.1);
  z-index: 1;
  opacity: 0;

  &.animate-up {
    animation: slideInUp 0.8s ease-out 0.6s forwards;
  }
}

@media only screen and (max-width: $device-phone) {
  .form {
    width: calc(90% - 50px);
    height: auto;
    min-height: 70vh;
  }
}
</style>
