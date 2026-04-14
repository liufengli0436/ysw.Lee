<template>
  <header class="bg-white shadow-md">
    <div class="container mx-auto px-4">
      <div class="flex justify-between items-center py-4">
        <div class="flex items-center">
          <router-link to="/">
            <img src="https://p3-doubao-search-sign.byteimg.com/labis/f5690bae796c7745373f0768db38394e~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791597357&x-signature=%2F%2FRi8TApyLVxzcIgs6KXGYU60rg%3D" alt="HIWIN Logo" class="h-12 mr-3">
          </router-link>
          <div>
            <h1 class="text-xl font-bold text-primary">HIWIN 直线传动</h1>
            <p class="text-sm text-gray-600">深圳市银盛威机电有限公司 | HIWIN 直属经销</p>
          </div>
        </div>
        
        <div class="hidden md:flex items-center mr-4">
          <router-link to="/search" class="text-gray-600 hover:text-primary transition duration-300" title="搜索产品">
            <i class="fas fa-search text-xl"></i>
          </router-link>
        </div>
        
        <div class="hidden md:flex items-center mr-4">
          <i class="fas fa-phone-alt text-primary mr-2"></i>
          <span class="text-gray-800 font-medium">400-888-8888</span>
        </div>
        
        <div class="md:hidden flex items-center">
          <button @click="toggleMobileMenu" class="text-gray-800 focus:outline-none">
            <i class="fas fa-bars text-2xl"></i>
          </button>
        </div>
      </div>
      
      <div :class="['mobile-menu pb-4', { 'active': mobileMenuOpen }]">
        <nav class="flex flex-col md:flex-row md:space-x-6 md:items-center">
          <router-link to="/" class="text-gray-800 hover:text-primary py-2 border-b border-gray-200 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">首页</router-link>
          <a href="#about" class="text-gray-800 hover:text-primary py-2 border-b border-gray-200 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">关于我们</a>
          <a href="#products" class="text-gray-800 hover:text-primary py-2 border-b border-gray-200 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">产品中心</a>
          <a href="#tech" class="text-gray-800 hover:text-primary py-2 border-b border-gray-200 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">技术资料</a>
          <a href="#industry" class="text-gray-800 hover:text-primary py-2 border-b border-gray-200 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">应用行业</a>
          <a href="#contact" class="text-gray-800 hover:text-primary py-2 md:border-b-0 md:border-b-2 md:border-transparent md:hover:border-primary md:hover:text-primary">联系我们</a>
          <router-link to="/search" class="text-gray-800 hover:text-primary py-2 md:hidden flex items-center" title="搜索产品">
            <i class="fas fa-search mr-2"></i>搜索
          </router-link>
        </nav>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'

const mobileMenuOpen = ref(false)

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}
</script>

<style scoped>
</style>
