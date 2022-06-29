<template>
  <div>
    <!-- 面包屑导航区域 -->
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>新闻信息管理</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:搜索部分 -->
    <el-form v-model="getNewsQueryInfo">
      <el-row :gutter="20">
        <el-col :span="10">
          <el-form-item label="新闻标题：">
            <el-input placeholder="请输入新闻标题" style="width: 400px" v-model="getNewsQueryInfo.query"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item style="margin-left: 100px">
            <el-button type="primary" icon="el-icon-search" @click="getNewsByLike">查询</el-button>
            <el-button type="primary" icon="el-icon-refresh" @click="getNewsNoLike">重置</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 卡片视图区域:列表部分 -->
    <el-button type="primary" icon="el-icon-plus" style="margin-bottom: 15px" @click="addNewsDialogVisible = true">新增</el-button>
    <el-table
      :data="newsList"
      border
      style="width: 100%">
      <el-table-column
        prop="id"
        label="编号"
        align="center"
        width="150px">
      </el-table-column>
      <el-table-column
        prop="title"
        label="标题"
        align="center">
      </el-table-column>
      <el-table-column
        prop="releasDate"
        label="日期"
        align="center">
      </el-table-column>
      <el-table-column
        prop="newsAbstract"
        label="摘要"
        align="center">
      </el-table-column>
      <el-table-column
        label="操作"
        width="265px"
        align="center">
        <template slot-scope="newsList">
          <el-button type="primary" icon="el-icon-view" size="mini" @click="getNewsById(newsList.row.id)">编辑</el-button>
          <el-button type="danger" icon="el-icon-delete" size="mini" @click="deleteNewsById(newsList.row.id)">删除</el-button>
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
      title="新增新闻"
      :visible.sync="addNewsDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>新闻信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>新增新闻</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 新闻信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form :model="addNewsForm">
            <el-form-item label="标题：" required="true">
              <el-input style="width: 800px" v-model="addNewsForm.title"></el-input>
            </el-form-item>
            <el-form-item label="摘要：" required="true">
              <el-input style="width: 800px" v-model="addNewsForm.newsAbstract"></el-input>
            </el-form-item>
            <el-form-item label="正文：" required="true">
              <quill-editor ref="text" v-model="addNewsForm.text" class="myQuillEditor" :options="editorOption" style="width: 800px;" />
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addNewsDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addNews()">提 交</el-button>
      </span>
    </el-dialog>
    <!-- 编辑新闻对话框 -->
    <el-dialog
      title="编辑新闻"
      :visible.sync="updateNewsDialogVisible"
      width="65%">
      <!-- 内容的主体区域 -->
      <!-- 面包屑导航区域 -->
      <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item :to="{ path: '/home' }">
          <i class="el-icon-s-home"></i>首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>新闻信息管理</el-breadcrumb-item>
        <el-breadcrumb-item><b>编辑新闻</b></el-breadcrumb-item>
      </el-breadcrumb>
      <!-- 设置分割线 -->
      <el-divider></el-divider>
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <i class="el-icon-document"></i>
          <span> 新闻信息</span>
        </div>
        <!-- 表单信息 -->
        <div style="margin-left: 3%">
          <el-form>
            <el-form-item label="标题：">
              <el-input style="width: 800px" v-model="NewsById.title" disabled></el-input>
            </el-form-item>
            <el-form-item label="摘要：">
              <el-input style="width: 800px" v-model="NewsById.newsAbstract"></el-input>
            </el-form-item>
            <el-form-item label="正文：">
              <quill-editor ref="text" v-model="NewsById.text" class="myQuillEditor" :options="editorOption" style="width: 800px" />
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <!-- 内容的底部区域 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateNewsDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateNews()">提 交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'News',
  data () {
    return {
      addNewsForm: {
        title: '',
        newsAbstract: '',
        text: ''
      },
      getNewsQueryInfo: {
        query: '',
        pageSize: 5,
        pageNum: 1
      },
      getNewsByIdInfo: {
        id: ''
      },
      updateNewsInfo: {
        id: '',
        newsAbstract: '',
        text: ''
      },
      deleteNewsByIdInfo: {
        id: ''
      },
      NewsById: {},
      total: 0,
      newsList: [],
      // 控制添加对话框显示与隐藏
      addNewsDialogVisible: false,
      // 控制编辑对话框显示与隐藏
      updateNewsDialogVisible: false
    }
  },
  created () {
    this.getNewsList()
  },
  methods: {
    addNews () {
      if (this.addNewsForm.title !== '' && this.addNewsForm.newsAbstract !== '' && this.addNewsForm.text !== '') {
        // 发送请求重新修改密码
        this.$http.post('addNews', this.$qs.stringify(this.addNewsForm))
          .then(response => {
            // 获取响应数据
            let result = response.data
            if (result.code !== '1') {
              return this.$message.error(result.msg)
            } else {
              this.$router.push({
                path: '/news'
              })
              this.addNewsDialogVisible = false
              this.getNewsList()
              return this.$message.success(result.msg)
            }
          })
      } else {
        alert('输入有误，请重新输入！')
      }
    },
    getNewsList () {
      // 发送请求
      this.$http.post('news', this.$qs.stringify(this.getNewsQueryInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result === null) {
            return this.$message.error('获取新闻列表失败!')
          } else {
            // 获取新闻列表成功
            this.pageNum = result.pageNum
            this.pageSize = result.pageSize
            this.newsList = result.list
            this.total = result.totalCount
            if (result.totalCount === 0) {
              return this.$message.warning('数据不存在，请更换查询条件！')
            }
          }
        })
    },
    getNewsById (id) {
      this.getNewsByIdInfo.id = id
      // 发送请求
      this.$http.post('getNewsById', this.$qs.stringify(this.getNewsByIdInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          console.log(result)
          if (result === null) {
            return this.$message.error('根据ID获取新闻信息失败!')
          } else {
            this.updateNewsDialogVisible = true
            this.NewsById = result
          }
        })
    },
    deleteNewsById (id) {
      this.deleteNewsByIdInfo.id = id
      if (confirm('确定要删除吗?')) {
        // 发送请求
        this.$http.post('deleteNewsById', this.$qs.stringify(this.deleteNewsByIdInfo))
          .then(response => {
            // 获取响应数据
            let result = response.data
            console.log(result)
            if (result === null) {
              return this.$message.error('删除新闻信息失败!')
            } else {
              this.getNewsQueryInfo.pageNum = 1
              this.getNewsList()
              this.$message.success('删除新闻信息成功!')
            }
          })
        return true
      } else {
        return false
      }
    },
    updateNews () {
      this.updateNewsInfo.id = this.getNewsByIdInfo.id
      this.updateNewsInfo.newsAbstract = this.NewsById.newsAbstract
      this.updateNewsInfo.text = this.NewsById.text
      // 发送请求
      this.$http.post('updateNews', this.$qs.stringify(this.updateNewsInfo))
        .then(response => {
          // 获取响应数据
          let result = response.data
          if (result.code !== '1') {
            return this.$message.error(result.msg)
          } else {
            this.updateNewsDialogVisible = false
            this.getNewsList()
            return this.$message.success(result.msg)
          }
        })
    },
    handleSizeChange (newSize) {
      this.getNewsQueryInfo.pageSize = newSize
      this.getNewsList()
    },
    handleCurrentChange (newSize) {
      this.getNewsQueryInfo.pageNum = newSize
      this.getNewsList()
    },
    getNewsByLike (newQuery) {
      this.query = newQuery
      this.getNewsList()
    },
    getNewsNoLike () {
      this.getNewsQueryInfo.query = ''
      this.getNewsList()
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
