<template>
  <main class="container mx-auto px-4 py-8">
    <div class="bg-white rounded-lg shadow-lg p-6 mb-8">
      <h2 class="text-2xl font-bold mb-6 text-center">产品搜索</h2>
      <div class="max-w-2xl mx-auto">
        <form @submit.prevent="handleSearch" class="flex flex-col md:flex-row">
          <div class="flex-grow relative mb-4 md:mb-0">
            <input 
              v-model="searchTerm" 
              type="text" 
              class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent" 
              placeholder="输入产品型号、名称或关键词..."
            >
            <i class="fas fa-search absolute left-3 top-4 text-gray-400"></i>
          </div>
          <button type="submit" class="btn-primary px-6 py-3 rounded-r-md font-medium">
            <i class="fas fa-search mr-2"></i>搜索
          </button>
        </form>
        <div class="mt-4 text-sm text-gray-500">
          <p>您可以搜索产品型号（如：HG20）、产品名称（如：直线导轨）或关键词（如：重负荷）</p>
        </div>
      </div>
    </div>
    
    <div class="flex justify-center items-center mb-6">
      <span class="text-gray-700"><strong>搜索结果：</strong>找到 <span class="text-primary font-bold">{{ filteredProducts.length }}</span> 个相关产品</span>
    </div>
    
    <div class="flex flex-wrap justify-center gap-2 mb-6">
      <button 
        v-for="category in categories" 
        :key="category"
        @click="filterByCategory(category)"
        :class="['filter-tag px-4 py-2 rounded-full text-sm font-medium', currentFilter === category ? 'active bg-primary text-white' : 'bg-gray-200 text-gray-700']"
      >
        {{ category }}
      </button>
    </div>
    
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="loader"></div>
    </div>
    
    <div v-else-if="filteredProducts.length === 0" class="flex flex-col items-center justify-center py-12">
      <i class="fas fa-search text-4xl text-gray-400 mb-4"></i>
      <h3 class="text-xl font-bold text-gray-700 mb-2">未找到相关产品</h3>
      <p class="text-gray-500 text-center">
        请尝试其他关键词或筛选条件<br>
        例如：HG20、EG15、KK60、R20-5K4等
      </p>
    </div>
    
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="product in paginatedProducts" :key="product.id" class="search-result-card bg-white rounded-lg shadow-md overflow-hidden">
        <div class="h-48 bg-gray-100 flex items-center justify-center">
          <img :src="product.image" :alt="product.name" class="max-h-full max-w-full p-4">
        </div>
        <div class="p-4">
          <div class="flex justify-between items-start mb-2">
            <h3 class="text-lg font-bold" v-html="highlightText(product.name)"></h3>
            <span :class="getCategoryColor(product.category)" class="text-xs px-2 py-1 rounded">{{ product.category }}</span>
          </div>
          <p class="text-gray-600 text-sm mb-4" v-html="highlightText(product.description)"></p>
          <div class="flex justify-between items-center">
            <span class="text-sm text-gray-500">型号：<span v-html="highlightText(product.model)"></span></span>
            <router-link to="/#products" class="text-primary hover:underline">查看详情</router-link>
          </div>
        </div>
      </div>
    </div>
    
    <div v-if="filteredProducts.length > itemsPerPage" class="flex justify-center mt-8">
      <nav class="inline-flex rounded-md shadow">
        <button 
          @click="prevPage" 
          :disabled="currentPage === 1"
          :class="['py-2 px-4 border', currentPage === 1 ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white border-gray-300 hover:bg-gray-50 rounded-l-md']"
        >
          上一页
        </button>
        <button 
          v-for="page in totalPages" 
          :key="page"
          @click="goToPage(page)"
          :class="['py-2 px-4 border', currentPage === page ? 'bg-primary text-white border-primary' : 'bg-white border-gray-300 hover:bg-gray-50']"
        >
          {{ page }}
        </button>
        <button 
          @click="nextPage" 
          :disabled="currentPage === totalPages"
          :class="['py-2 px-4 border', currentPage === totalPages ? 'bg-gray-100 text-gray-400 cursor-not-allowed' : 'bg-white border-gray-300 hover:bg-gray-50 rounded-r-md']"
        >
          下一页
        </button>
      </nav>
    </div>
    
    <div 
      id="back-to-top" 
      :class="['visible', { 'visible': showBackToTop }]"
      @click="scrollToTop"
    >
      <i class="fas fa-arrow-up"></i>
    </div>
  </main>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

const searchTerm = ref('')
const currentFilter = ref('全部')
const currentPage = ref(1)
const loading = ref(false)
const showBackToTop = ref(false)
const itemsPerPage = 6

const categories = ['全部', '直线导轨', '滚珠丝杆', '线性模组', '配件']

const products = [
  {
    id: 1,
    name: 'HGH20HA 直线导轨',
    category: '直线导轨',
    description: '重负荷系列直线导轨，四方向等负载设计，高刚性、高精度，适用于数控机床、自动化设备等。',
    model: 'HGH20HA',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 2,
    name: 'HGW20CC 直线导轨',
    category: '直线导轨',
    description: '重负荷系列直线导轨，高刚性设计，精度等级C级，适用于各类精密机械和自动化设备。',
    model: 'HGW20CC',
    image: 'https://p3-doubao-search-sign.byteimg.com/isp-i18n-media/img/c08b197f827076d179beca1be6bcaf9f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=QYBjspyovd6eQUAZ75ZUQEf%2FVbQ%3D'
  },
  {
    id: 3,
    name: 'HGR20 导轨',
    category: '直线导轨',
    description: '20mm宽标准导轨，节距60mm，最大长度4000mm，适用于HG20系列滑块配套使用。',
    model: 'HGR20-R1000Z0',
    image: 'https://p11-doubao-search-sign.byteimg.com/isp-i18n-media/img/bea3c95045f5fa05c892aed5463bdd7c~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=PrZuirR8pyC9Na608juyEFrlmmk%3D'
  },
  {
    id: 4,
    name: 'HGH25CA 直线导轨',
    category: '直线导轨',
    description: '重负荷系列直线导轨，25mm宽，高刚性设计，适用于各类精密机械和自动化设备。',
    model: 'HGH25CA',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/image/40048db889e7a1522bd7d70d84bb8dfd~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=KWbnmFVETq4LoK%2BHe7arQCEx37k%3D'
  },
  {
    id: 5,
    name: 'HGW30HA 直线导轨',
    category: '直线导轨',
    description: '重负荷系列直线导轨，30mm宽，四方向等负载设计，适用于重型机械设备。',
    model: 'HGW30HA',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 6,
    name: 'HGR35 导轨',
    category: '直线导轨',
    description: '35mm宽标准导轨，节距80mm，最大长度4000mm，适用于HG35系列滑块配套使用。',
    model: 'HGR35-R1500Z0',
    image: 'https://p11-doubao-search-sign.byteimg.com/isp-i18n-media/img/bea3c95045f5fa05c892aed5463bdd7c~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=PrZuirR8pyC9Na608juyEFrlmmk%3D'
  },
  {
    id: 7,
    name: 'EGH15CA 直线导轨',
    category: '直线导轨',
    description: '精密系列直线导轨，15mm宽，低噪音设计，适用于精密机械设备。',
    model: 'EGH15CA',
    image: 'https://p3-doubao-search-sign.byteimg.com/isp-i18n-media/img/c08b197f827076d179beca1be6bcaf9f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=QYBjspyovd6eQUAZ75ZUQEf%2FVbQ%3D'
  },
  {
    id: 8,
    name: 'EGW20CB 直线导轨',
    category: '直线导轨',
    description: '精密系列直线导轨，20mm宽，高刚性设计，精度等级B级。',
    model: 'EGW20CB',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 9,
    name: 'EGR15 导轨',
    category: '直线导轨',
    description: '15mm宽精密导轨，节距45mm，最大长度3000mm，适用于EG15系列滑块。',
    model: 'EGR15-R800Z0',
    image: 'https://p11-doubao-search-sign.byteimg.com/isp-i18n-media/img/bea3c95045f5fa05c892aed5463bdd7c~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=PrZuirR8pyC9Na608juyEFrlmmk%3D'
  },
  {
    id: 10,
    name: 'RGH20CA 直线导轨',
    category: '直线导轨',
    description: '滚柱型直线导轨，20mm宽，超高刚性设计，适用于重载精密设备。',
    model: 'RGH20CA',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/511ef541ae2c95e4e16085c0634a3d0d~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=qn90mwgysVSmK0%2BSxY94fN6gCl0%3D'
  },
  {
    id: 11,
    name: 'RGW25HA 直线导轨',
    category: '直线导轨',
    description: '滚柱型直线导轨，25mm宽，四方向等负载设计，适用于重型切削机床。',
    model: 'RGW25HA',
    image: 'https://p3-doubao-search-sign.byteimg.com/isp-i18n-media/img/c08b197f827076d179beca1be6bcaf9f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=QYBjspyovd6eQUAZ75ZUQEf%2FVbQ%3D'
  },
  {
    id: 12,
    name: 'MGN7C 直线导轨',
    category: '直线导轨',
    description: '微型直线导轨，7mm宽，适用于小型精密设备和医疗器械。',
    model: 'MGN7C',
    image: 'https://p11-doubao-search-sign.byteimg.com/isp-i18n-media/img/bea3c95045f5fa05c892aed5463bdd7c~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=PrZuirR8pyC9Na608juyEFrlmmk%3D'
  },
  {
    id: 13,
    name: 'MGW12C 直线导轨',
    category: '直线导轨',
    description: '微型直线导轨，12mm宽，高刚性设计，适用于精密仪器设备。',
    model: 'MGW12C',
    image: 'https://p3-doubao-search-sign.byteimg.com/isp-i18n-media/img/c08b197f827076d179beca1be6bcaf9f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=QYBjspyovd6eQUAZ75ZUQEf%2FVbQ%3D'
  },
  {
    id: 14,
    name: 'FSV2005 滚珠丝杆',
    category: '滚珠丝杆',
    description: '外循环滚珠丝杆，外径20mm，导程5mm，适用于各类数控机床和自动化设备。',
    model: 'FSV2005-3-C3',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 15,
    name: 'FSI2005 滚珠丝杆',
    category: '滚珠丝杆',
    description: '内循环滚珠丝杆，外径20mm，导程5mm，高精度、低噪音，适用于精密机械设备。',
    model: 'FSI2005-3-C3',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 16,
    name: 'FSC2005 静音丝杆',
    category: '滚珠丝杆',
    description: '研磨静音滚珠丝杆，外径20mm，导程5mm，低噪音设计，适用于精密机械。',
    model: 'FSC2005-3-C3',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 17,
    name: 'R20-5K4 滚珠丝杆',
    category: '滚珠丝杆',
    description: '精密研磨滚珠丝杆，外径20mm，导程5mm，K4预压，适用于高精度CNC机床。',
    model: 'R20-5K4-FSW',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 18,
    name: 'R25-10K3 滚珠丝杆',
    category: '滚珠丝杆',
    description: '精密研磨滚珠丝杆，外径25mm，导程10mm，K3预压，适用于高速CNC机床。',
    model: 'R25-10K3-FSW',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 19,
    name: 'FSV3210 滚珠丝杆',
    category: '滚珠丝杆',
    description: '外循环滚珠丝杆，外径32mm，导程10mm，适用于大型数控机床和自动化设备。',
    model: 'FSV3210-3-C3',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 20,
    name: 'R32-10K4 滚珠丝杆',
    category: '滚珠丝杆',
    description: '精密研磨滚珠丝杆，外径32mm，导程10mm，K4预压，适用于重型切削机床。',
    model: 'R32-10K4-FSW',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 21,
    name: 'FSI4016 滚珠丝杆',
    category: '滚珠丝杆',
    description: '内循环滚珠丝杆，外径40mm，导程16mm，高精度、高速度，适用于精密CNC机床。',
    model: 'FSI4016-3-C3',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 22,
    name: 'KK6005 线性模组',
    category: '线性模组',
    description: '精密线性模组，KK系列，导程5mm，高刚性设计，适用于精密定位和自动化设备。',
    model: 'KK6005P-150A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=z8035sVG1gJFTYXEgVjqONUoRGY%3D'
  },
  {
    id: 23,
    name: 'KK6010 线性模组',
    category: '线性模组',
    description: '精密线性模组，KK系列，导程10mm，高速度、高精度，适用于各类自动化设备。',
    model: 'KK6010P-300A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/ecom-shop-material/jpeg_m_ca45b9508e2b7b5cba0994ac57b3f920_sx_86707_www1000-1000~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=IeVFbutmGbYrHMtHFPXO90kiDGQ%3D'
  },
  {
    id: 24,
    name: 'KK86D10 线性模组',
    category: '线性模组',
    description: 'KK86D系列线性模组，轴径增大2mm，更经久耐用，不易断轴，适用于重载应用。',
    model: 'KK86D10P-400A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/ecom-shop-material/jpeg_m_5b8e8a8c5d639b5e8ae3791fda80c8ae_sx_54160_www800-800~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=dJ9ct27DX8YQ0BwG7yXvL6bzC7o%3D'
  },
  {
    id: 25,
    name: 'KK8620 线性模组',
    category: '线性模组',
    description: '精密线性模组，KK系列，导程20mm，高速度设计，适用于高速自动化设备。',
    model: 'KK8620P-500A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=z8035sVG1gJFTYXEgVjqONUoRGY%3D'
  },
  {
    id: 26,
    name: 'KK10010 线性模组',
    category: '线性模组',
    description: '大型线性模组，KK系列，导程10mm，高刚性设计，适用于重型自动化设备。',
    model: 'KK10010P-600A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/ecom-shop-material/jpeg_m_ca45b9508e2b7b5cba0994ac57b3f920_sx_86707_www1000-1000~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=IeVFbutmGbYrHMtHFPXO90kiDGQ%3D'
  },
  {
    id: 27,
    name: 'SK2005 线性模组',
    category: '线性模组',
    description: '静音线性模组，SK系列，导程5mm，低噪音设计，适用于精密静音设备。',
    model: 'SK2005P-100A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/ecom-shop-material/jpeg_m_5b8e8a8c5d639b5e8ae3791fda80c8ae_sx_54160_www800-800~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=dJ9ct27DX8YQ0BwG7yXvL6bzC7o%3D'
  },
  {
    id: 28,
    name: 'SK3010 线性模组',
    category: '线性模组',
    description: '静音线性模组，SK系列，导程10mm，高刚性设计，适用于精密自动化设备。',
    model: 'SK3010P-200A1-F0',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/d8c5f7d01c4b35f49d474d1f60045c24~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=z8035sVG1gJFTYXEgVjqONUoRGY%3D'
  },
  {
    id: 29,
    name: 'EK12 支撑座',
    category: '配件',
    description: '滚珠丝杆支撑座，EK系列，适用于20mm以下丝杆，固定端支撑。',
    model: 'EK12',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 30,
    name: 'BK15 支撑座',
    category: '配件',
    description: '滚珠丝杆支撑座，BK系列，适用于20mm以下丝杆，固定端支撑。',
    model: 'BK15',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 31,
    name: 'BF12 支撑座',
    category: '配件',
    description: '滚珠丝杆支撑座，BF系列，适用于20mm以下丝杆，固定端支撑。',
    model: 'BF12',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 32,
    name: 'BKBF20 支撑座组',
    category: '配件',
    description: '滚珠丝杆支撑座组，适用于20mm丝杆，包含BK20和BF20各一个。',
    model: 'BKBF20',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 33,
    name: 'CPC6 联轴器',
    category: '配件',
    description: '弹性联轴器，CPC系列，适用于6mm轴径，高刚性设计。',
    model: 'CPC6-6-6',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  },
  {
    id: 34,
    name: 'CPC8 联轴器',
    category: '配件',
    description: '弹性联轴器，CPC系列，适用于8mm轴径，高刚性设计。',
    model: 'CPC8-8-8',
    image: 'https://p26-doubao-search-sign.byteimg.com/labis/15aa418bdde40795952c62e9ec6c4d8a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=rEyrjviQo%2BFBJLMwvMLMB9X2wiI%3D'
  },
  {
    id: 35,
    name: 'MCS12 锁紧螺母',
    category: '配件',
    description: '滚珠丝杆专用锁紧螺母，MCS系列，适用于12mm丝杆。',
    model: 'MCS12',
    image: 'https://p3-doubao-search-sign.byteimg.com/labis/f5371cee94f3a9ea7f00a2f594dffd9a~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=62Eb72spQX2kfUDP0UVzdIcg7co%3D'
  },
  {
    id: 36,
    name: 'MCS16 锁紧螺母',
    category: '配件',
    description: '滚珠丝杆专用锁紧螺母，MCS系列，适用于16mm丝杆。',
    model: 'MCS16',
    image: 'https://p11-doubao-search-sign.byteimg.com/labis/50d2e9ea7b88a46cbdb7b5539d06d63f~tplv-be4g95zd3a-image.jpeg?lk3s=feb11e32&x-expires=1791601770&x-signature=%2FTdh1rAXwvxa1ABqyIJJcfZogbA%3D'
  }
]

const filteredProducts = computed(() => {
  return products.filter(product => {
    const matchesSearch = !searchTerm.value || 
      product.name.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      product.model.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      product.description.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      product.category.toLowerCase().includes(searchTerm.value.toLowerCase())
    
    const matchesFilter = currentFilter.value === '全部' || product.category === currentFilter.value
    
    return matchesSearch && matchesFilter
  })
})

const totalPages = computed(() => {
  return Math.ceil(filteredProducts.value.length / itemsPerPage)
})

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredProducts.value.slice(start, end)
})

const handleSearch = () => {
  loading.value = true
  currentPage.value = 1
  setTimeout(() => {
    loading.value = false
  }, 600)
}

const filterByCategory = (category) => {
  loading.value = true
  currentFilter.value = category
  currentPage.value = 1
  setTimeout(() => {
    loading.value = false
  }, 600)
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
  }
}

const goToPage = (page) => {
  currentPage.value = page
}

const highlightText = (text) => {
  if (!searchTerm.value) return text
  const regex = new RegExp(`(${searchTerm.value})`, 'gi')
  return text.replace(regex, '<span class="highlight">$1</span>')
}

const getCategoryColor = (category) => {
  const colors = {
    '直线导轨': 'bg-blue-100 text-primary',
    '滚珠丝杆': 'bg-green-100 text-green-700',
    '线性模组': 'bg-purple-100 text-purple-700',
    '配件': 'bg-orange-100 text-orange-700'
  }
  return colors[category] || 'bg-gray-100 text-gray-700'
}

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

const handleScroll = () => {
  showBackToTop.value = window.scrollY > 100
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
</style>
