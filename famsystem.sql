/*
 Navicat Premium Data Transfer

 Source Server         : MyDatabase
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : famsystem

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 05/07/2022 08:13:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ADMINNAME` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ADMINPASSWORD` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ADMINSTATUS` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0',
  `ADMINSEX` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '111111', '1', '男');
INSERT INTO `admin` VALUES (10, '1234561', '111111', '0', '女');
INSERT INTO `admin` VALUES (15, 'asadman', '111111', '0', '男');
INSERT INTO `admin` VALUES (16, 'asadman', '111111', '0', '男');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `gno` int(11) NOT NULL AUTO_INCREMENT,
  `gname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gprice` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gdate` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `releasdate` date NULL DEFAULT NULL,
  PRIMARY KEY (`gno`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'Dio牌小面包', '40', '15', '2022-07-01');
INSERT INTO `goods` VALUES (2, '西撒牌泡泡水', '6', '1年', '2020-02-18');
INSERT INTO `goods` VALUES (4, '可口可乐（大）', '8', '6个月', '2020-02-18');
INSERT INTO `goods` VALUES (5, '芬达 ', '3', '7个月', '2020-02-18');
INSERT INTO `goods` VALUES (7, '泡面牌泡面（袋）', '1.5', '2年', '2020-02-18');
INSERT INTO `goods` VALUES (8, '奔驰小模型', '100', '/', '2020-02-18');
INSERT INTO `goods` VALUES (9, '遥控小飞机', '69', '/', '2022-06-09');
INSERT INTO `goods` VALUES (10, '老八牌小汉堡', '5', '1天', '2022-06-28');
INSERT INTO `goods` VALUES (11, '不到牌鸡肉卷', '7', '1天', '2022-06-29');
INSERT INTO `goods` VALUES (12, '雀氏牌咖啡', '39', '3个月', '2022-06-29');
INSERT INTO `goods` VALUES (13, '五五牌玩具宝箱', '6', '/', '2022-06-29');

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TITLE` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `NEWSABSTRACT` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `TEXT` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `RELEASDATE` date NULL DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES (1, '修改标题', '改一改', '<p>测试内容111111</p>', '2022-06-09');
INSERT INTO `news` VALUES (2, '测试标题2', '测试摘要2', '<p>测试正文2</p>', '2020-02-18');
INSERT INTO `news` VALUES (3, '测试标题3', '测试摘要3', '<p>测试正文3</p>', '2020-02-18');
INSERT INTO `news` VALUES (4, '测试标题4', '测试摘要4', '<p>测试正文4</p>', '2020-02-18');
INSERT INTO `news` VALUES (5, '测试标题5', '测试摘要5', '<p>测试正文6</p>', '2020-02-18');
INSERT INTO `news` VALUES (6, '测试标题01', '测试摘要01', '<p>测试正文01</p>', '2020-02-18');
INSERT INTO `news` VALUES (7, '测试标题02', '测试摘要02', '<p>测试正文02</p>', '2020-02-18');
INSERT INTO `news` VALUES (8, '测试标题03', '测试摘要03', '<p>测试正文03</p>', '2020-02-18');
INSERT INTO `news` VALUES (9, '测试标题04', '测试摘要04', '<p>测试正文04</p>', '2020-02-18');
INSERT INTO `news` VALUES (13, '开心', '学习是开心的', '我们很忙开发项目', '2022-06-09');
INSERT INTO `news` VALUES (14, '水土不服', '回大沈阳', '<p>坚持住，因为大家也在坚持</p>', '2022-06-09');
INSERT INTO `news` VALUES (15, '测试标题00000', '回大沈阳000000', '<p>坚持住，因为大家也在坚持00000</p>', '2022-06-09');

-- ----------------------------
-- Table structure for stock
-- ----------------------------
DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock`  (
  `stockno` int(11) NOT NULL AUTO_INCREMENT,
  `gname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ammount` int(11) NULL DEFAULT NULL,
  `batch` int(25) NULL DEFAULT NULL,
  PRIMARY KEY (`stockno`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stock
-- ----------------------------
INSERT INTO `stock` VALUES (1, '芬达', '汽水饮料', 200, 22070201);
INSERT INTO `stock` VALUES (3, '玩具汽车', '玩具', 400, 22070201);
INSERT INTO `stock` VALUES (4, '遥控小飞机', '玩具', 300, 22070201);
INSERT INTO `stock` VALUES (5, '小鸡爪', '零食食品', 500, 22070202);
INSERT INTO `stock` VALUES (6, '肥宅快乐水', '休闲食品', 550, 22070201);
INSERT INTO `stock` VALUES (7, '奔驰小模型', '玩具', 500, 22070401);

-- ----------------------------
-- Table structure for vendor
-- ----------------------------
DROP TABLE IF EXISTS `vendor`;
CREATE TABLE `vendor`  (
  `vno` int(11) NOT NULL AUTO_INCREMENT,
  `vname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `vtyp` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `vtele` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  PRIMARY KEY (`vno`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vendor
-- ----------------------------
INSERT INTO `vendor` VALUES (1, '西撒有限公司', '饮品类', '19101234563');
INSERT INTO `vendor` VALUES (2, '可口可乐分公司', '饮品类', '19102345671');
INSERT INTO `vendor` VALUES (4, '六六玩具有限公司', '玩具类', '18723465243');
INSERT INTO `vendor` VALUES (5, '芬达分公司', '饮品类', '16708956753');
INSERT INTO `vendor` VALUES (6, '杂货食品公司', '食品类', '15689756421');
INSERT INTO `vendor` VALUES (7, '不到食品公司', '食品类', '18798656743');

SET FOREIGN_KEY_CHECKS = 1;
