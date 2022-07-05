<template>
  <div class="can">
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">
        <i class="el-icon-s-home"></i>首页
      </el-breadcrumb-item>
      <el-breadcrumb-item>贪吃蛇小游戏</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- 设置分割线 -->
    <el-divider></el-divider>
    <!-- 游戏界面 -->
    <div class="content" v-if="show">
      <div class="snake-grassland">
        <div
          class="snake"
          v-for="(item, index) in snake"
          :key="`snake${index}`"
          :style="location(item.x, item.y)"
        ></div>
        <div
          class="food"
          v-for="(item, index) in foods"
          :key="`food${index}`"
          :style="location(item.x, item.y)"
        ></div>
      </div>
      <div class="right">
        <div class="content-title">
          <div class="username">用户名：{{ form.name }}</div>
          <div class="score">得分：{{ score }}</div>
        </div>
        <div class="button">
          <el-button @click="stopGame" type="warning">暂停游戏</el-button>
          <el-button type="primary" @click="continueGame">继续游戏</el-button>
        </div>
      </div>

      <!-- 结束面板 -->
      <div class="fail" v-if="showFail">
        <div class="fail-title">游戏结束!</div>
        <div class="total-score">score:{{ score }}</div>
        <el-button @click="reStart" type="danger">重新开始</el-button>
        <el-button @click="exitGame" type="danger">退出游戏</el-button>
      </div>
    </div>

    <!-- 开始面板 -->
    <div class="login" v-if="showLogin">
      <!-- <div class="title">贪吃蛇大作战</div> -->
      <el-form label-width="500px">
      </el-form>
      <el-form
        ref="form"
        :model="form"
        :rules="rules"
        label-width="70px"
        class="ruleForm"
      >

        <el-form-item label="昵称" prop="name">
          <el-input v-model="form.name" placeholder="请输入昵称" ></el-input>
        </el-form-item>
      <el-button type="primary" @click="active" :disabled="btnState == false">开始游戏</el-button>
      </el-form>

    </div>
  </div>
</template>
<script>
export default {
  // snake-grassland 50*50的格子
  data() {
    return {
      form: {
        name: "",
      },
      rules: {
        name: [
          {
            required: true,
            message: "请输入昵称,长度在 3 到 20 个字符",
            trigger: "blur",
          },
          { min: 3, max: 5, message: "长度在 3 到 20 个字符", trigger: "blur" },
        ],
      },
      name: "", // 玩家名
      score: 0, // 得分
      showLogin: true,
      show: false,
      showFail: false,
      foods: [],
      direction: 3, //初始方向向右
      timer: null,
      snake: [
        { x: 0, y: 0 }, //蛇尾
        { x: 1, y: 0 },
        { x: 2, y: 0 }, //蛇头
      ], //(x, y) 组成蛇的每一块儿的位置
      xStep: 1,
      yStep: 1,
    };
  },
  computed: {
    btnState() {
      return this.form.name !== "";
    },
  },
  created() {
    // 随机生成3个食物
    this.foods = this.generateFoods(3);
  },
  mounted() {
    window.addEventListener("keyup", (event) => {
      // event.key = ArrowUp 上
      switch (event.key) {
        case "ArrowUp":
          this.direction = 0;
          this.snakeMove();
          break;
        case "ArrowDown":
          this.direction = 1;
          this.snakeMove();
          break;
        case "ArrowLeft":
          this.direction = 2;
          this.snakeMove();
          break;
        case "ArrowRight":
          this.direction = 3;
          this.snakeMove();
          break;
        default:
          break;
      }
    });
  },
  methods: {
    // 暂停游戏
    stopGame() {
      clearInterval(this.timer); //清除了定时器
      this.timer = null; //清除了timer的内存占用
    },
    //继续游戏
    continueGame() {
      this.timer = setInterval(() => {
        this.snakeMove();
      }, 200);
    },

    // 重新开始
    reStart() {
      this.showFail = false;

      this.snake = [
        { x: 0, y: 0 },
        { x: 1, y: 0 },
        { x: 2, y: 0 },
      ]; //(x, y) 组成蛇的每一块儿的位置
      this.foods = this.generateFoods(3);
      this.direction = 3;
      this.score = 0;
      this.timer = setInterval(() => {
        this.snakeMove();
      }, 200);
    },
    //退出游戏
    exitGame() {
      this.showFail = false;
      this.showLogin = !this.showLogin;
      this.show = !this.show;
      this.form.name = "";
      this.score = 0;
      clearInterval(this.timer); //清除了定时器
      this.timer = null; //清除了timer的内存占用
    },
    //碰撞检测是否吃到食物
    isEat() {
      // 小蛇移动就是除头部以外的部分向前移动一个身位,即前一个状态的最后一个身位丢弃
      let head = this.snake[this.snake.length - 1];
      let isEat = false;
      // 消除吃掉的食物
      this.foods = this.foods.filter((food) => {
        if (head.x === food.x && head.y === food.y) {
          isEat = true;
          this.eat(); // 加长蛇身
          //碰撞一次加10分
          this.score = this.score + 10;
          return false;
        }
        return true;
      });
      // 添加一个新食物，使食物总量保持不变
      if (isEat) {
        this.foods.push(...this.generateFoods(1));
      }
    },
    // 吃食物
    eat() {
      let tail = this.snake[0];
      let xStep = 0,
        yStep = 0;

      if (this.direction === 0) {
        yStep = -1;
      } else if (this.direction === 1) {
        yStep = 1;
      } else if (this.direction === 2) {
        xStep = -1;
      } else if (this.direction === 3) {
        xStep = 1;
      }
      //添加到数组的开头
      this.snake.unshift({ x: tail.x - xStep, y: tail.y - yStep });
    },
    // 开始游戏
    active() {
      this.show = true;
      this.showLogin = false;

      if (this.form.name.length <= 2) {
        this.showLogin = !this.showLogin;
        this.show = !this.show;
        return alert("用户名不可小于三位字符");
      } else {
        this.snake = [
          { x: 0, y: 0 },
          { x: 1, y: 0 },
          { x: 2, y: 0 },
        ]; //(x, y) 组成蛇的每一块儿的位置
        this.foods = this.generateFoods(3);
        this.direction = 3;
        this.timer = setInterval(() => {
          this.snakeMove();
        }, 200);
      }
    },

    // 随机生成食物
    generateFoods(total) {
      const foods = [];
      for (let i = 0; i < total; i++) {
        //食物的随机x轴坐标，也就是第几行
        const foodX = Math.floor(Math.random() * 50);
        //食物的随机x轴坐标，也就是第几列
        const foodY = Math.floor(Math.random() * 50);
        foods.push({ x: foodX, y: foodY });
      }
      return foods;
    },
    // 获取位置
    location(x, y) {
      return {
        left: x * 10 + "px",
        top: y * 10 + "px",
      };
    },
    //蛇开始动 判断是否超出界限 head表示贪吃蛇的头部，当头部超过地图的范围时
    //先获取下一步数据，坐标值，判断坐标值是否非法，如果不非法就可以动了
    move(xStep, yStep) {
      //定义蛇的头部位置
      let head = this.snake[this.snake.length - 1];
      //需要监听蛇头的方向而且判断
      if (
        (this.direction == 2 && head.x <= 0) ||
        (this.direction == 0 && head.y <= 0) ||
        (this.direction == 3 && head.x >= 49) ||
        (this.direction == 1 && head.y >= 49)
      ) {
        clearInterval(this.timer);
        this.timer = null;
        this.endGame();
      }  else {
        this.snake.push({ x: head.x + xStep, y: head.y + yStep });
        this.snake.shift();
      }

    },
    //结束游戏
    endGame() {
      this.showFail = true;
    },
    // 改变方向
    changeDirection(direction) {
      this.direction = direction;
      this.snakeMove();
    },
    // 控制蛇的方向
    snakeMove() {
      switch (this.direction) {
        case 0: // 上  网上移动就是列的改变，列减1行
          this.move(0, -1);
          break;
        case 1: // 下
          this.move(0, 1);
          break;
        case 2: // 左
          this.move(-1, 0);
          break;
        case 3: // 右
          this.move(1, 0);
          break;
        default:
          break;
      }
      this.isEat();
    },
  },
};
</script>
<style scope="lang">
* {
  padding: 0;
  margin: 0;
}
.can {
  height: 500px;
}
.content {
  width: 750px;
  height: 500px;

  margin-left: 20px;
  position: relative;
  border: 1px solid gainsboro;
  display: flex;
}
.snake-grassland {
  position: relative;
  background-color: #b3db61;
  width: 500px;
  height: 500px;
}
.snake-grassland .snake {
  background-color: #000;
  position: absolute;
  border: 1px solid #ccc;
  box-sizing: border-box;
  width: 10px;
  height: 10px;
}

.snake-grassland .food {
  background-color: red;
  position: absolute;
  border: 1px solid #ccc;
  box-sizing: border-box;
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.right {
  position: absolute;
  width: 200px;
  margin: 150px 500px;
  text-align: left;
  padding: 10px;
}
.button {
  display: flex;
  justify-content: space-evenly;
  margin: 20px 0;
}

.login {
  /* position: absolute; */
  width: 750px;
  height: 500px;
  background:url("../assets/login3.png") no-repeat;
  /* left: 520px; */
}
.ruleForm {
  padding: 180px 60px 20px;
}
.fail {
 position: absolute;
  width: 400px;
  height: 300px;
  background-color: rgb(207, 202, 224);
  top: 150px;
  left: 50px;
  border: 1px solid black;
  border-radius: 25px;
}
.fail-title {
  margin: 20px auto;
  font-size: 28px;
  font-weight: bold;
}
.total-score {
  margin: 40px auto 20px;
  font-size: 28px;
  font-weight: bold;
}
</style>
