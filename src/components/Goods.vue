<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>商品信息管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:搜索部分 -->
    <el-form v-model="getGoodsQueryInfo">
      <el-row :gutter="20">
        <el-col :span="10">
          <el-form-item label="商品名称：">
            <el-input placeholder="请输入商品名称" style="width: 400px" v-model="getGoodsQueryInfo.query"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item style="margin-left: 100px">
            <el-button type="primary" icon="el-icon-search" @click="getGoodsByLike">查询</el-button>
            <el-button type="primary" icon="el-icon-refresh" @click="getGoodsNoLike">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:列表部分 -->
    <el-button type="primary" icon="el-icon-plus" style="margin-bottom: 15px" @click="addGoodsDialogVisible = true">新增商品信息</el-button>
    <el-table
      :data="goodsList"
      border
      style="width: 100%">
      <el-table-column
        prop="gno"
        label="商品编号"
        align="center"
        width="150px">
      </el-table-column>
      <el-table-column
        prop="gname"
        label="商品名称"
        align="center">
      </el-table-column>
      <el-table-column
        prop="gprice"
        label="价格"
        align="center">
      </el-table-column>
      <el-table-column
        prop="gdate"
        label="保质期"
        align="center">
      </el-table-column>
      <el-table-column
        label="操作"
        width="265px"
        align="center">
        <template slot-scope="goodsList">
          <el-button type="primary" icon="el-icon-view" size="mini" @click="getGoodsById(goodsList.row.gno)">编辑</el-button>
          <el-button type="danger" icon="el-icon-delete" size="mini" @click="deleteGoodsById(goodsList.row.gno)">删除</el-button>
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
    <!-- 添加新闻对话框 -->
    <el-dialog
      title="新增商品信息"
      :visible.sync="addGoodsDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>商品信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>新增商品</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 商品信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form :model="addGoodsForm">
            <el-form-item label="商品名称：" required="true">
              <el-input style="width: 800px" v-model="addGoodsForm.gname"></el-input>
            </el-form-item>
            <el-form-item label="价格：" required="true">
              <el-input style="width: 800px" v-model="addGoodsForm.gprice"></el-input>
            </el-form-item>
            <el-form-item label="保质期：" required="true">
              <el-input style="width: 800px" v-model="addGoodsForm.gdate"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addGoodsDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addGoods()">提 交</el-button>
      </span>
    </el-dialog>
    <!-- 编辑新闻对话框 -->
    <el-dialog
      title="编辑商品信息"
      :visible.sync="updateGoodsDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>商品信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>编辑商品信息</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 商品信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form>
            <el-form-item label="商品名称：">
              <el-input style="width: 800px" v-model="GoodsById.gname" disabled></el-input>
            </el-form-item>
            <el-form-item label="价格：">
              <el-input style="width: 800px" v-model="GoodsById.gprice"></el-input>
            </el-form-item>
            <el-form-item label="保质期：">
               <el-input style="width: 800px" v-model="GoodsById.gdate"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateGoodsDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateGoods()">提 交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Goods',
  data () {
    return {
      addGoodsForm: {
        gname: '',
        gprice: '',
        gdate: ''
      },
      getGoodsQueryInfo: {
        query: '',
        pageSize: 5,
        pageNum: 1
      },
      getGoodsByIdInfo: {
        gno: ''
      },
      updateGoodsInfo: {
        gno: '',
        gprice: '',
        gdate: ''
      },
      deleteGoodsByIdInfo: {
        gno: ''
      },
      GoodsById: {},
      total: 0,
      goodsList: [],
      // 控制添加对话框显示与隐藏
      addGoodsDialogVisible: false,
      // 控制编辑对话框显示与隐藏
      updateGoodsDialogVisible: false
    }
  },
  created () {
    this.getGoodsList()
  },
  methods: {
    addGoods () {
      if (this.addGoodsForm.gname !== '' && this.addGoodsForm.gprice !== '' && this.addGoodsForm.gdate !== '') {
        // 发送请求重新修改密码
        this.$http.post('addGoods', this.$qs.stringify(this.addGoodsForm))
          .then(response => {
            // 获取响应数据
            let result = response.data
            if (result.code !== '1') {
              return this.$message.error(result.msg)
            } else {
              this.$router.push({
                path: '/goods'
              })
              this.addGoodsDialogVisible = false
              this.getGoodsList()
              return this.$message.success(result.msg)
            }
          })
      } else {
        alert('输入有误，请重新输入！')
      }
    },
    getGoodsList () {
      // 发送请求
      this.$http.post('goods', this.$qs.stringify(this.getGoodsQueryInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result === null) {
            return this.$message.error('获取学生列表失败!')
          } else {
            // 获取新闻列表成功
            this.pageNum = result.pageNum
            this.pageSize = result.pageSize
            this.goodsList = result.list
            this.total = result.totalCount
            if (result.totalCount === 0) {
              return this.$message.warning('数据不存在，请更换查询条件！')
            }
          }
        })
    },
    getGoodsById (gno) {
      this.getGoodsByIdInfo.gno = gno
      // 发送请求
      this.$http.post('getGoodsById', this.$qs.stringify(this.getGoodsByIdInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          console.log(result)
          if (result === null) {
            return this.$message.error('根据商品编号获取商品信息失败!')
          } else {
            this.updateGoodsDialogVisible = true
            this.GoodsById = result
          }
        })
    },
    deleteGoodsById (gno) {
      this.deleteGoodsByIdInfo.gno = gno
      if (confirm('确定要删除吗?')) {
        // 发送请求
        this.$http.post('deleteGoodsById', this.$qs.stringify(this.deleteGoodsByIdInfo))
          .then(response => {
            // 获取响应数据
            let result = response.data
            console.log(result)
            if (result === null) {
              return this.$message.error('删除商品信息失败!')
            } else {
              this.getGoodsByIdInfo.pageNum = 1
              this.getGoodsList()
              this.$message.success('删除商品信息成功!')
            }
          })
        return true
      } else {
        return false
      }
    },
    updateGoods () {
      this.updateGoodsInfo.gno = this.getGoodsByIdInfo.gno
      this.updateGoodsInfo.gprice = this.GoodsById.gprice
      this.updateGoodsInfo.gdate = this.GoodsById.gdate
      // 发送请求
      this.$http.post('updateGoods', this.$qs.stringify(this.updateGoodsInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result.code !== '1') {
            return this.$message.error(result.msg)
          } else {
            this.updateGoodsDialogVisible = false
            this.getGoodsList()
            return this.$message.success(result.msg)
          }
        })
    },
    handleSizeChange (newSize) {
      this.getGoodsQueryInfo.pageSize = newSize
      this.getGoodsList()
    },
    handleCurrentChange (newSize) {
      this.getGoodsQueryInfo.pageNum = newSize
      this.getGoodsList()
    },
    getGoodsByLike (newQuery) {
      this.query = newQuery
      this.getGoodsList()
    },
    getGoodsNoLike () {
      this.getGoodsQueryInfo.query = ''
      this.getGoodsList()
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
