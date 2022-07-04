<template>
    <div>
      <span class="welcome">欢迎来到我们的超市，请放心选购！</span>
      <!-- <el-calendar v-model="value">
        <template
          slot="dateCell"
          slot-scope="{date, data}">
          <p :class="data.isSelected ? 'is-selected' : ''">
            {{ data.day.split('-').slice(2).join(' ') }} {{ data.isSelected ? '✔️' : ''}}
          </p>
        </template>
      </el-calendar> -->
      <img src="../assets/info.png" height="100%" width="100%" />
    </div>
</template>

<script>
export default {
  name: 'Welcome',
  data () {
    return {
      value: new Date()
    }
  }
}
</script>

<style lang="less" scoped>
  .welcome{
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
    font-size: 18px;
  }
  /*修改日历组件的高度*/
  /deep/.el-calendar-table .el-calendar-day {
    height: 75px;
  }
  .is-selected {
    color: #1989FA;
  }
</style>
