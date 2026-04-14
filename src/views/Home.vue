<template>
  <div class="bg-white">
    <section id="home" class="carousel h-[500px] md:h-[600px]">
      <div class="carousel-inner h-full" :style="{ transform: `translateX(-${currentIndex * 100}%)` }">
        <div v-for="(slide, index) in slides" :key="index" class="carousel-item h-full">
          <div class="relative h-full" :style="{ background: slide.gradient }">
            <div class="absolute inset-0 opacity-30">
              <img :src="slide.image" :alt="slide.title" class="w-full h-full object-cover">
            </div>
            <div class="container mx-auto px-4 h-full flex items-center">
              <div class="max-w-lg text-white">
                <h2 class="text-4xl md:text-5xl font-bold mb-4">{{ slide.title }}</h2>
                <p class="text-xl mb-8">{{ slide.description }}</p>
                <div class="flex space-x-4">
                  <a href="#products" class="btn-primary px-6 py-3 rounded-full font-medium" @click.prevent="scrollToSection('products')">了解产品</a>
                  <a href="#contact" class="bg-white text-primary px-6 py-3 rounded-full font-medium hover:bg-gray-100 transition duration-300" @click.prevent="scrollToSection('contact')">联系我们</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="carousel-indicators">
        <div 
          v-for="(slide, index) in slides" 
          :key="index"
          :class="['carousel-indicator', { active: currentIndex === index }]"
          @click="goToSlide(index)"
        ></div>
      </div>
      
      <div class="carousel-control carousel-control-prev" @click="prevSlide">
        <i class="fas fa-chevron-left"></i>
      </div>
      <div class="carousel-control carousel-control-next" @click="nextSlide">
        <i class="fas fa-chevron-right"></i>
      </div>
    </section>

    <div class="marquee-container py-3">
      <div class="marquee-content">
        <div v-for="(item, index) in marqueeItems" :key="index" class="marquee-item flex items-center">
          <i class="fas fa-check-circle mr-2"></i>
          <span>{{ item }}</span>
        </div>
        <div v-for="(item, index) in marqueeItems" :key="'dup-' + index" class="marquee-item flex items-center">
          <i class="fas fa-check-circle mr-2"></i>
          <span>{{ item }}</span>
        </div>
      </div>
    </div>

    <section id="about" class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">关于我们</h2>
          <p class="text-gray-600 max-w-2xl mx-auto">深圳市银盛威机电有限公司是HIWIN直线传动产品的直属经销商，专业提供直线导轨、滚珠丝杆、线性模组等精密传动产品。</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center p-6">
            <div class="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-award text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">台湾原装</h3>
            <p class="text-gray-600">HIWIN台湾原厂正品，品质保证</p>
          </div>
          <div class="text-center p-6">
            <div class="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-box text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">现货库存</h3>
            <p class="text-gray-600">常用规格现货供应，快速发货</p>
          </div>
          <div class="text-center p-6">
            <div class="w-16 h-16 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-headset text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">专业服务</h3>
            <p class="text-gray-600">专业技术支持，全程服务保障</p>
          </div>
        </div>
      </div>
    </section>

    <section id="products" class="py-16 bg-light-gray">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">产品中心</h2>
          <p class="text-gray-600">为您提供全面的直线传动解决方案</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="product in featuredProducts" :key="product.id" class="product-card bg-white rounded-lg shadow-md overflow-hidden">
            <div class="h-48 bg-gray-100 flex items-center justify-center">
              <img :src="product.image" :alt="product.name" class="max-h-full max-w-full p-4">
            </div>
            <div class="p-4">
              <h3 class="text-lg font-bold mb-2">{{ product.name }}</h3>
              <p class="text-gray-600 text-sm mb-4">{{ product.description }}</p>
              <router-link to="/search" class="text-primary hover:underline">查看详情</router-link>
            </div>
          </div>
        </div>
        <div class="text-center mt-8">
          <router-link to="/search" class="btn-primary px-8 py-3 rounded-full font-medium inline-block">
            查看更多产品
          </router-link>
        </div>
      </div>
    </section>

    <section id="tech" class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">技术资料</h2>
          <p class="text-gray-600">丰富的技术文档和资料下载</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div v-for="doc in techDocs" :key="doc.id" class="tech-card bg-white rounded-lg shadow-md p-6 border border-gray-200">
            <div class="flex items-center mb-4">
              <div class="w-12 h-12 bg-primary rounded-lg flex items-center justify-center mr-4">
                <i :class="doc.icon" class="text-white text-xl"></i>
              </div>
              <div>
                <h3 class="font-bold text-lg">{{ doc.title }}</h3>
                <p class="text-sm text-gray-500">{{ doc.type }}</p>
              </div>
            </div>
            <p class="text-gray-600 text-sm mb-4">{{ doc.description }}</p>
            <button class="download-btn btn-primary px-4 py-2 rounded text-sm w-full">
              <i class="fas fa-download mr-2"></i>下载资料
            </button>
          </div>
        </div>
      </div>
    </section>

    <section id="industry" class="py-16 bg-light-gray">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">应用行业</h2>
          <p class="text-gray-600">广泛应用于各行各业</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="industry in industries" :key="industry.id" class="industry-card relative rounded-lg overflow-hidden h-64">
            <img :src="industry.image" :alt="industry.name" class="w-full h-full object-cover">
            <div class="industry-overlay absolute inset-0 flex items-center justify-center">
              <div class="text-center text-white">
                <i :class="industry.icon" class="text-4xl mb-2"></i>
                <h3 class="text-xl font-bold">{{ industry.name }}</h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section id="contact" class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-gray-800 mb-4">联系我们</h2>
          <p class="text-gray-600">期待与您的合作</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
          <div>
            <h3 class="text-xl font-bold mb-6">联系方式</h3>
            <div class="space-y-4">
              <div class="flex items-center">
                <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center mr-4">
                  <i class="fas fa-phone-alt text-white"></i>
                </div>
                <div>
                  <p class="text-gray-600 text-sm">电话</p>
                  <p class="font-medium">400-888-8888</p>
                </div>
              </div>
              <div class="flex items-center">
                <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center mr-4">
                  <i class="fas fa-envelope text-white"></i>
                </div>
                <div>
                  <p class="text-gray-600 text-sm">邮箱</p>
                  <p class="font-medium">info@hiwin.com</p>
                </div>
              </div>
              <div class="flex items-center">
                <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center mr-4">
                  <i class="fas fa-map-marker-alt text-white"></i>
                </div>
                <div>
                  <p class="text-gray-600 text-sm">地址</p>
                  <p class="font-medium">深圳市宝安区西乡街道</p>
                </div>
              </div>
            </div>
          </div>
          <div>
            <h3 class="text-xl font-bold mb-6">在线留言</h3>
            <form @submit.prevent="submitForm" class="space-y-4">
              <div>
                <input type="text" placeholder="您的姓名" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
              </div>
              <div>
                <input type="email" placeholder="您的邮箱" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
              </div>
              <div>
                <input type="tel" placeholder="联系电话" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
              </div>
              <div>
                <textarea placeholder="留言内容" rows="4" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary"></textarea>
              </div>
              <button type="submit" class="btn-primary px-8 py-3 rounded-md font-medium w-full">
                提交留言
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const currentIndex = ref(0)
const autoPlayInterval = ref(null)

const slides = [
  {
    title: 'HIWIN 直线导轨',
    description: '高精度、高刚性、长寿命的直线运动解决方案',
    gradient: 'linear-gradient(to right, #1e3a8a, #1d4ed8)',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5690bae796c7745373f0768db38394e~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791597357&x-signature=%2F%2FRi8TApyLVxzcIgs6KXGYU60rg%3D'
  },
  {
    title: 'HIWIN 滚珠丝杆',
    description: '高精度传动，高效率转换，为精密机械提供动力',
    gradient: 'linear-gradient(to right, #1f2937, #374151)',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791597357&x-signature=h%2FLiZYOixsne%2BXh1SXKLP7FKPIM%3D'
  },
  {
    title: 'HIWIN 线性模组',
    description: '一体化设计，高精度定位，为自动化设备提供完美解决方案',
    gradient: 'linear-gradient(to right, #1e3a8a, #1f2937)',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791597357&x-signature=nh5AIk2SoIVysos2X9rhTbBkw7E%3D'
  }
]

const marqueeItems = ['台湾原装', '现货库存', '专业选型', '技术支持', '品质保证', '快速交付']

const featuredProducts = [
  {
    id: 1,
    name: '直线导轨',
    description: '高精度直线导轨，适用于各类精密机械设备',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 2,
    name: '滚珠丝杆',
    description: '高精度滚珠丝杆，高效率传动解决方案',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 3,
    name: '线性模组',
    description: '一体化线性模组，高精度定位系统',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=z8035sVG1gJFTYXEgVjqONUoRGY%3D'
  },
  {
    id: 4,
    name: '支撑单元',
    description: '滚珠丝杆支撑座，提供稳定支撑',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  }
]

const techDocs = [
  {
    id: 1,
    title: '产品选型手册',
    type: 'PDF',
    description: '包含所有产品的详细参数和选型指南',
    icon: 'fas fa-book'
  },
  {
    id: 2,
    title: '安装维护指南',
    type: 'PDF',
    description: '详细的安装步骤和维护保养说明',
    icon: 'fas fa-tools'
  },
  {
    id: 3,
    title: '技术规格书',
    type: 'PDF',
    description: '各系列产品的技术规格和性能参数',
    icon: 'fas fa-file-alt'
  }
]

const industries = [
  {
    id: 1,
    name: '数控机床',
    icon: 'fas fa-cogs',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 2,
    name: '自动化设备',
    icon: 'fas fa-robot',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=z8035sVG1gJFTYXEgVjqONUoRGY%3D'
  },
  {
    id: 3,
    name: '精密仪器',
    icon: 'fas fa-microscope',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 4,
    name: '电子设备',
    icon: 'fas fa-microchip',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 5,
    name: '医疗器械',
    icon: 'fas fa-heartbeat',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 6,
    name: '半导体设备',
    icon: 'fas fa-memory',
    image: 'https://p3-doubao-search-sign.byteimg.com/isp-i18n-media/img/c08b197f827076d179beca1be6bcaf9f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=QYBjspyovd6eQUAZ75ZUQEf%2FVbQ%3D'
  }
]

const nextSlide = () => {
  currentIndex.value = (currentIndex.value + 1) % slides.length
}

const prevSlide = () => {
  currentIndex.value = (currentIndex.value - 1 + slides.length) % slides.length
}

const goToSlide = (index) => {
  currentIndex.value = index
}

const startAutoPlay = () => {
  autoPlayInterval.value = setInterval(nextSlide, 5000)
}

const stopAutoPlay = () => {
  if (autoPlayInterval.value) {
    clearInterval(autoPlayInterval.value)
  }
}

const scrollToSection = (sectionId) => {
  const element = document.getElementById(sectionId)
  if (element) {
    const headerOffset = 80
    const elementPosition = element.getBoundingClientRect().top
    const offsetPosition = elementPosition + window.pageYOffset - headerOffset

    window.scrollTo({
      top: offsetPosition,
      behavior: 'smooth'
    })
  }
}

const submitForm = (e) => {
  e.preventDefault()
  alert('感谢您的留言！我们会尽快与您联系。')
}

onMounted(() => {
  startAutoPlay()
})

onUnmounted(() => {
  stopAutoPlay()
})
</script>

<style scoped>
</style>
