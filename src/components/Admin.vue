<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>用户信息管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:搜索部分 -->
    <el-form v-model="getAdminQueryInfo">
      <el-row :gutter="20">
        <el-col :span="10">
          <el-form-item label="用户名称：">
            <el-input placeholder="请输入用户名称" style="width: 400px" v-model="getAdminQueryInfo.query"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item style="margin-left: 100px">
            <el-button type="primary" icon="el-icon-search" @click="getAdminByLike">查询</el-button>
            <el-button type="primary" icon="el-icon-refresh" @click="getAdminNoLike">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:列表部分 -->
    <el-button type="primary" icon="el-icon-plus" style="margin-bottom: 15px" @click="addAdminDialogVisible = true">新增用户信息</el-button>
    <el-table
      :data="adminList"
      border
      style="width: 100%">
      <el-table-column
        prop="id"
        label="用户编号"
        align="center"
        width="150px">
      </el-table-column>
      <el-table-column
        prop="adminName"
        label="用户名称"
        align="center">
      </el-table-column>
      <el-table-column
        prop="adminPassword"
        label="用户密码"
        align="center">
      </el-table-column>
      <el-table-column
        prop="adminStatus"
        label="用户密码状态"
        align="center">
      </el-table-column>
      <el-table-column
        label="操作"
        width="265px"
        align="center">
        <template slot-scope="adminList">
          <el-button type="primary" icon="el-icon-view" size="mini" @click="getAdminById(adminList.row.id)">编辑</el-button>
          <el-button type="danger" icon="el-icon-delete" size="mini" @click="deleteAdminById(adminList.row.id)">删除</el-button>
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
      title="新增用户信息"
      :visible.sync="addAdminDialogVisible"
      width="31%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>用户信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>新增用户</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 用户信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form :model="addAdminForm">
            <el-form-item label="用户名称：" required="true">
              <el-input style="width: 400px" v-model="addAdminForm.adminname"></el-input>
            </el-form-item>
            <el-form-item label="用户密码：" required="true">
              <el-input style="width: 400px" v-model="addAdminForm.adminpassword"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addAdminDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addAdmin()">提 交</el-button>
      </span>
    </el-dialog>
    <!-- 编辑新闻对话框 -->
    <el-dialog
      title="编辑用户信息"
      :visible.sync="updateAdminDialogVisible"
      width="31%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>用户信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>编辑用户信息</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 用户信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form>
            <el-form-item label="用户名称：">
              <el-input style="width: 400px" v-model="AdminById.adminName" disabled></el-input>
            </el-form-item>
            <el-form-item label="用户密码：">
              <el-input style="width: 400px" v-model="AdminById.adminpassword"></el-input>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateAdminDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateAdmin()">提 交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'Admin',
  data () {
    return {
      addAdminForm: {
        adminname: '',
        adminpassword: ''
      },
      getAdminQueryInfo: {
        query: '',
        pageSize: 5,
        pageNum: 1
      },
      getAdminByIdInfo: {
        id: ''
      },
      updateAdminInfo: {
        id: '',
        adminname: '',
        adminpassword: ''
      },
      deleteAdminByIdInfo: {
        id: ''
      },
      AdminById: {},
      total: 0,
      adminList: [],
      // 控制添加对话框显示与隐藏
      addAdminDialogVisible: false,
      // 控制编辑对话框显示与隐藏
      updateAdminDialogVisible: false
    }
  },
  created () {
    this.getAdminList()
  },
  methods: {
    addAdmin () {
      if (this.addAdminForm.adminname !== '' && this.addAdminForm.adminpassword !== '') {
        // 发送请求重新修改密码
        this.$http.post('addAdmin', this.$qs.stringify(this.addAdminForm))
          .then(response => {
            // 获取响应数据
            let result = response.data
            if (result.code !== '1') {
              return this.$message.error(result.msg)
            } else {
              this.$router.push({
                path: '/admin'
              })
              this.addAdminDialogVisible = false
              this.getAdminList()
              return this.$message.success(result.msg)
            }
          })
      } else {
        alert('输入有误，请重新输入！')
      }
    },
    getAdminList () {
      // 发送请求
      this.$http.post('admin', this.$qs.stringify(this.getAdminQueryInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result === null) {
            return this.$message.error('获取用户列表失败!')
          } else {
            // 获取新闻列表成功
            this.pageNum = result.pageNum
            this.pageSize = result.pageSize
            this.adminList = result.list
            this.total = result.totalCount
            if (result.totalCount === 0) {
              return this.$message.warning('数据不存在，请更换查询条件！')
            }
          }
        })
    },
    getAdminById (id) {
      this.getAdminByIdInfo.id = id
      // 发送请求
      this.$http.post('getAdminById', this.$qs.stringify(this.getAdminByIdInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          console.log(result)
          if (result === null) {
            return this.$message.error('根据用户编号获取用户信息失败!')
          } else {
            this.updateAdminDialogVisible = true
            this.AdminById = result
          }
        })
    },
    deleteAdminById (id) {
      this.deleteAdminByIdInfo.id = id
      if (confirm('确定要删除吗?')) {
        // 发送请求
        this.$http.post('deleteAdminById', this.$qs.stringify(this.deleteAdminByIdInfo))
          .then(response => {
            // 获取响应数据
            let result = response.data
            console.log(result)
            if (result === null) {
              return this.$message.error('删除用户信息失败!')
            } else {
              this.getAdminQueryInfo.pageNum = 1
              this.getAdminList()
              this.$message.success('删除用户信息成功!')
            }
          })
        return true
      } else {
        return false
      }
    },
    updateAdmin () {
      this.updateAdminInfo.id = this.getAdminByIdInfo.id
      this.updateAdminInfo.adminname = this.AdminById.adminname
      this.updateAdminInfo.adminpassword = this.AdminById.adminpassword
      // 发送请求
      this.$http.post('updateaAdmin', this.$qs.stringify(this.updateAdminInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result.code !== '1') {
            return this.$message.error(result.msg)
          } else {
            this.updateAdminDialogVisible = false
            this.getAdminList()
            return this.$message.success(result.msg)
          }
        })
    },
    handleSizeChange (newSize) {
      this.getAdminQueryInfo.pageSize = newSize
      this.getAdminList()
    },
    handleCurrentChange (newSize) {
      this.getAdminQueryInfo.pageNum = newSize
      this.getAdminList()
    },
    getAdminByLike (newQuery) {
      this.query = newQuery
      this.getAdminList()
    },
    getAdminNoLike () {
      this.getAdminQueryInfo.query = ''
      this.getAdminList()
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
