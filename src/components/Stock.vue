<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>库存信息管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:搜索部分 -->
    <el-form v-model="getStockQueryInfo">
      <el-row :gutter="20">
        <el-col :span="10">
          <el-form-item label="商品名称：">
            <el-input placeholder="请输入商品名称" style="width: 400px" v-model="getStockQueryInfo.query"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item style="margin-left: 100px">
            <el-button type="primary" icon="el-icon-search" @click="getStockByLike">查询</el-button>
            <el-button type="primary" icon="el-icon-refresh" @click="getStockNoLike">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:列表部分 -->
    <el-button type="primary" icon="el-icon-plus" style="margin-bottom: 15px" @click="addStockDialogVisible = true">进货</el-button>
    <el-table
      :data="stockList"
      border
      style="width: 100%">
      <el-table-column
        prop="stockno"
        label="编号"
        align="center">
      </el-table-column>
      <el-table-column
        prop="gname"
        label="商品名称"
        align="center"
        width="300px">
      </el-table-column>
      <el-table-column
        prop="category"
        label="商品种类"
        align="center">
      </el-table-column>
      <el-table-column
        prop="ammount"
        label="库存数量"
        align="center">
      </el-table-column>
      <el-table-column
        prop="batch"
        label="批次"
        align="center">
      </el-table-column>
      <el-table-column
        label="操作"
        width="265px"
        align="center">
        <template slot-scope="stockList">
          <el-button type="primary" icon="el-icon-view" size="mini" @click="getStockById(stockList.row.stockno)">修改</el-button>
          <el-button type="danger" icon="el-icon-delete" size="mini" @click="deleteStockById(stockList.row.stockno)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页区域 -->
    <div class="block">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pageNum"
        :page-sizes="[1, 2, 4, 5]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total">
      </el-pagination>
    </div>
    <!-- 进货对话框 -->
    <el-dialog
      title="进货"
      :visible.sync="addStockDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>库存信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>进货登记</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 货物信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 5%">
          <el-form :model="addStockForm">
            <el-form-item label="商品名称：" required="true">
              <el-input style="width: 600px" v-model="addStockForm.gname"></el-input>
            </el-form-item>
            <el-form-item label="商品种类：" required="true">
              <el-input style="width: 600px" v-model="addStockForm.category"></el-input>
            </el-form-item>
            <el-form-item label="库存数量：" required="true">
              <el-input style="width: 600px" v-model="addStockForm.ammount"></el-input>
            </el-form-item>
            <el-form-item label="批次编号：" required="true">
              <el-input style="width: 600px" v-model="addStockForm.batch"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addStockDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addStock()">提 交</el-button>
      </span>
    </el-dialog>
    <!-- 修改库存信息对话框 -->
    <el-dialog
      title="修改库存信息"
      :visible.sync="updateStockDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>库存信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>修改库存信息</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 货物信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form>
            <!-- <el-form-item label="编号：">
              <el-input style="width: 800px" v-model="StockById.stockno" disabled></el-input>
            </el-form-item> -->
            <el-form-item label="商品名称：">
              <el-input style="width: 800px" v-model="StockById.gname" disabled></el-input>
            </el-form-item>
            <el-form-item label="商品种类：">
              <el-input style="width: 800px" v-model="StockById.category"></el-input>
            </el-form-item>
            <el-form-item label="库存数量：">
              <el-input style="width: 800px" v-model="StockById.ammount"></el-input>
            </el-form-item>
<!--            <el-form-item label="批次编号：">
              <el-input style="width: 800px" v-model="StockById.batch"></el-input>
            </el-form-item> -->
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateStockDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateStock()">提 交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Stock',
  data () {
    return {
      addStockForm: {
        gname: '',
        category: '',
        ammount: '',
        batch: ''
      },
      getStockQueryInfo: {
        query: '',
        pageSize: 5,
        pageNum: 1
      },
      getStockByIdInfo: {
        stockno: ''
      },
      updateStockInfo: {
        stockno: '',
        // gname: '',
        category: '',
        ammount: ''
      },
      deleteStockByIdInfo: {
        stockno: ''
      },
      StockById: {},
      total: 0,
      stockList: [],
      // 控制添加对话框显示与隐藏
      addStockDialogVisible: false,
      // 控制编辑对话框显示与隐藏
      updateStockDialogVisible: false
    }
  },
  created () {
    this.getstockList()
  },
  methods: {
    addStock () {
      if (this.addStockForm.gname !== '' && this.addStockForm.category !== '' && this.addStockForm.ammount !== '' && this.addStockForm.batch !== '') {
        // 发送请求重新修改密码
        this.$http.post('addStock', this.$qs.stringify(this.addStockForm))
          .then(response => {
            // 获取响应数据
            let result = response.data
            if (result.code !== '1') {
              return this.$message.error(result.msg)
            } else {
              this.$router.push({
                path: '/stock'
              })
              this.addStockDialogVisible = false
              this.getstockList()
              return this.$message.success(result.msg)
            }
          })
      } else {
        alert('输入有误，请重新输入！')
      }
    },
    getstockList () {
      // 发送请求
      this.$http.post('Stock', this.$qs.stringify(this.getStockQueryInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result === null) {
            return this.$message.error('获取库存列表失败!')
          } else {
            // 获取新闻列表成功
            this.pageNum = result.pageNum
            this.pageSize = result.pageSize
            this.stockList = result.list
            this.total = result.totalCount
            if (result.totalCount === 0) {
              return this.$message.warning('数据不存在，请更换查询条件！')
            }
          }
        })
    },
    getStockById (stockno) {
      this.getStockByIdInfo.stockno = stockno
      // 发送请求
      this.$http.post('getStockById', this.$qs.stringify(this.getStockByIdInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          console.log(result)
          if (result === null) {
            return this.$message.error('根据ID获取库存信息失败!')
          } else {
            this.updateStockDialogVisible = true
            this.StockById = result
          }
        })
    },
    deleteStockById (stockno) {
      this.deleteStockByIdInfo.stockno = stockno
      if (confirm('确定要删除吗?')) {
        // 发送请求
        this.$http.post('deleteStockById', this.$qs.stringify(this.deleteStockByIdInfo))
          .then(response => {
            // 获取响应数据
            let result = response.data
            console.log(result)
            if (result === null) {
              return this.$message.error('删除记录失败!')
            } else {
              this.getStockQueryInfo.pageNum = 1
              this.getstockList()
              this.$message.success('删除记录成功!')
            }
          })
        return true
      } else {
        return false
      }
    },
    updateStock () {
      this.updateStockInfo.stockno = this.getStockByIdInfo.stockno
      // this.updateStockInfo.gname = this.StockById.gname
      this.updateStockInfo.category = this.StockById.category
      this.updateStockInfo.ammount = this.StockById.ammount
      // 发送请求
      this.$http.post('updateStock', this.$qs.stringify(this.updateStockInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result.code !== '1') {
            return this.$message.error(result.msg)
          } else {
            this.updateStockDialogVisible = false
            this.getstockList()
            return this.$message.success(result.msg)
          }
        })
    },
    handleSizeChange (Newsize) {
      this.getStockQueryInfo.pageSize = Newsize
      this.getstockList()
    },
    handleCurrentChange (Newsize) {
      this.getStockQueryInfo.pageNum = Newsize
      this.getstockList()
    },
    getStockByLike (newQuery) {
      this.query = newQuery
      this.getstockList()
    },
    getStockNoLike () {
      this.getStockQueryInfo.query = ''
      this.getstockList()
    }
  }
}
</script>

<style lang="less" scoped>
  /deep/.el-form-item__content {
    float: left;
  }
  .el-pagination{
    margin-top: 15px;
  }
  ul li{
    list-style: none;
    width: 400px;
    height: 40px;
    line-height: 40px;
  }
</style>
