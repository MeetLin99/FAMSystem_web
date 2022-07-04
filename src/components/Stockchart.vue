<template>
  <div>
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>库存统计图</el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <!-- 卡片视图区域:搜索部分 -->
      <div id="myChart" :style="{width: '700px', height: '700px'}"></div>
    </div>
</template>

<script>
  export default {
      name: 'Home',
      data(){
        return{
          data: [
            { value: 40, name: 'rose 1' },
            { value: 38, name: 'rose 2' },
            { value: 32, name: 'rose 3' },
            { value: 30, name: 'rose 4' },
            { value: 28, name: 'rose 5' },
            { value: 26, name: 'rose 6' },
            { value: 22, name: 'rose 7' },
            { value: 18, name: 'rose 8' }
          ]
        }
      },
      mounted() {
        this.$http.get('/stockchart').then((res) => {
            // 读取接口请求成功回传回来的数据
            var stock = res.data.stockchart
            // 定义数组，存放一会覆盖echarts图形的数据
            var data = []
            // 循环遍历数组，取出数据，转成和data一样的格式
            for(var i = 0; i < stock.length; i++) {
                var d = {name: '', value: 0}
                d.name = stock[i].gname
                d.value = stock[i].ammount
                // 往data数组中添加数据
                data.push(d)
            }
            // 排序，b - a降序——a - b升序
            data.sort((a , b) => b.value - a.value)
            // 覆盖data(){}中全局变量的数据
            this.data = data
            // 画出图形
            this.Draw()
        }).catch((err) => {
            console.log(err)
            alert('请求失败！请检查后端接口！！！！')
         })
      },
      methods: {
          Draw() {
              // 基于准备好的dom，初始化echarts实例
              let myChart = this.$echarts.init(document.getElementById('myChart'))
              // 绘制图表
              myChart.setOption({
                  // options配置项
                    legend: {
                      top: 'bottom'
                    },
                    toolbox: {
                      show: true,
                      feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        restore: { show: true },
                        saveAsImage: { show: true }
                      }
                    },
                    series: [
                      {
                        name: 'Nightingale Chart',
                        type: 'pie',
                        radius: [50, 250],
                        center: ['50%', '50%'],
                        roseType: 'area',
                        itemStyle: {
                          borderRadius: 8
                        },
                        data: this.data
                      }
                    ]
              })
          }
      }
  }
</script>

<style>
</style>
