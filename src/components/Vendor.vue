<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>供应商信息管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:搜索部分 -->
    <el-form v-model="getVendorQueryInfo">
      <el-row :gutter="20">
        <el-col :span="10">
          <el-form-item label="供应商名称：">
            <el-input placeholder="请输入供应商名称" style="width: 400px" v-model="getVendorQueryInfo.query"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item style="margin-left: 100px">
            <el-button type="primary" icon="el-icon-search" @click="getVendorByLike">查询</el-button>
            <el-button type="primary" icon="el-icon-refresh" @click="getVendorNoLike">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:列表部分 -->
    <el-button type="primary" icon="el-icon-plus" style="margin-bottom: 15px" @click="addVendorDialogVisible = true">新增供应商信息</el-button>
    <el-table
      :data="vendorList"
      border
      style="width: 100%">
      <el-table-column
        prop="vno"
        label="供应商编号"
        align="center"
        width="150px">
      </el-table-column>
      <el-table-column
        prop="vname"
        label="供应商名称"
        align="center">
      </el-table-column>
      <el-table-column
        prop="vtyp"
        label="供应商类别"
        align="center">
      </el-table-column>
      <el-table-column
        prop="vtele"
        label="供应商电话"
        align="center">
      </el-table-column>
      <el-table-column
        label="操作"
        width="265px"
        align="center">
        <template slot-scope="vendorList">
          <el-button type="primary" icon="el-icon-view" size="mini" @click="getVendorById(vendorList.row.vno)">编辑</el-button>
          <el-button type="danger" icon="el-icon-delete" size="mini" @click="deleteVendorById(vendorList.row.vno)">删除</el-button>
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
      :visible.sync="addVendorDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>供应商信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>添加供应商</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 供应商信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form :model="addVendorForm">
            <el-form-item label="供应商名称：" required="true">
              <el-input style="width: 800px" v-model="addVendorForm.vname"></el-input>
            </el-form-item>
            <el-form-item label="供应商类型：" required="true">
              <el-input style="width: 800px" v-model="addVendorForm.vtyp"></el-input>
            </el-form-item>
            <el-form-item label="供应商电话：" required="true">
              <el-input style="width: 800px" v-model="addVendorForm.vtele"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addVendorDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addVendor()">提 交</el-button>
      </span>
    </el-dialog>
    <!-- 编辑新闻对话框 -->
    <el-dialog
      title="编辑供应商信息"
      :visible.sync="updateVendorDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>供应商信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>编辑供应商信息</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 供应商信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form>
            <el-form-item label="供应商名称：">
              <el-input style="width: 800px" v-model="VendorById.vname" disabled></el-input>
            </el-form-item>
            <el-form-item label="供应商类型：">
              <el-input style="width: 800px" v-model="VendorById.vtyp"></el-input>
            </el-form-item>
            <el-form-item label="供应商电话：">
               <el-input style="width: 800px" v-model="VendorById.vtele"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateVendorDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateVendor()">提 交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Vendor',
  data () {
    return {
      addVendorForm: {
        vname: '',
        vtyp: '',
        vtele: ''
      },
      getVendorQueryInfo: {
        query: '',
        pageSize: 5,
        pageNum: 1
      },
      getVendorByIdInfo: {
        vno: ''
      },
      updateVendorInfo: {
        vno: '',
        vtyp: '',
        vtele: ''
      },
      deleteVendorByIdInfo: {
        vno: ''
      },
      VendorById: {},
      total: 0,
      vendorList: [],
      // 控制添加对话框显示与隐藏
      addVendorDialogVisible: false,
      // 控制编辑对话框显示与隐藏
      updateVendorDialogVisible: false
    }
  },
  created () {
    this.getVendorList()
  },
  methods: {
    addVendor () {
      if (this.addVendorForm.vname !== '' && this.addVendorForm.vtyp !== '' && this.addVendorForm.vtele !== '') {
        // 发送请求重新修改密码
        this.$http.post('addVendor', this.$qs.stringify(this.addVendorForm))
          .then(response => {
            // 获取响应数据
            let result = response.data
            if (result.code !== '1') {
              return this.$message.error(result.msg)
            } else {
              this.$router.push({
                path: '/vendor'
              })
              this.addVendorDialogVisible = false
              this.getVendorList()
              return this.$message.success(result.msg)
            }
          })
      } else {
        alert('输入有误，请重新输入！')
      }
    },
    getVendorList () {
      // 发送请求
      this.$http.post('vendor', this.$qs.stringify(this.getVendorQueryInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result === null) {
            return this.$message.error('获取供应商列表失败!')
          } else {
            // 获取新闻列表成功
            this.pageNum = result.pageNum
            this.pageSize = result.pageSize
            this.vendorList = result.list
            this.total = result.totalCount
            if (result.totalCount === 0) {
              return this.$message.warning('数据不存在，请更换查询条件！')
            }
          }
        })
    },
    getVendorById (vno) {
      this.getVendorByIdInfo.vno = vno
      // 发送请求
      this.$http.post('getVendorById', this.$qs.stringify(this.getVendorByIdInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          console.log(result)
          if (result === null) {
            return this.$message.error('根据商供应商编号获取供应商信息失败!')
          } else {
            this.updateVendorDialogVisible = true
            this.VendorById = result
          }
        })
    },
    deleteVendorById (vno) {
      this.deleteVendorByIdInfo.vno = vno
      if (confirm('确定要删除吗?')) {
        // 发送请求
        this.$http.post('deleteVendorById', this.$qs.stringify(this.deleteVendorByIdInfo))
          .then(response => {
            // 获取响应数据
            let result = response.data
            console.log(result)
            if (result === null) {
              return this.$message.error('删除供应商信息失败!')
            } else {
              this.getVendorByIdInfo.pageNum = 1
              this.getVendorList()
              this.$message.success('删除供应商信息成功!')
            }
          })
        return true
      } else {
        return false
      }
    },
    updateVendor () {
      this.updateVendorInfo.vno = this.getVendorByIdInfo.vno
      this.updateVendorInfo.vtyp = this.VendorById.vtyp
      this.updateVendorInfo.vtele = this.VendorById.vtele
      // 发送请求
      this.$http.post('updateVendor', this.$qs.stringify(this.updateVendorInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result.code !== '1') {
            return this.$message.error(result.msg)
          } else {
            this.updateVendorDialogVisible = false
            this.getVendorList()
            return this.$message.success(result.msg)
          }
        })
    },
    handleSizeChange (newSize) {
      this.getVendorQueryInfo.pageSize = newSize
      this.getVendorList()
    },
    handleCurrentChange (newSize) {
      this.getVendorQueryInfo.pageNum = newSize
      this.getVendorList()
    },
    getVendorByLike (newQuery) {
      this.query = newQuery
      this.getVendorList()
    },
    getVendorNoLike () {
      this.getVendorQueryInfo.query = ''
      this.getVendorList()
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
