package com.YFFramework.game.core.module.notice.model
{
	/**
	 * @version 1.0.0
	 * creation time：2013-8-16 下午5:49:44
	 */
	public class NoticeType{
		/**滚动条提示信息*/		
		public static const Show_Area_Roll:int=1;
		/**系统提示信息（屏幕上方提示信息-非滚动条）*/
		public static const Show_Area_System:int=2;
		/**正下方弹出信息*/
		public static const Show_Area_Popup:int=3;
		/**右下角提示信息*/
		public static const Show_Area_NormalTip:int=4;
		/**聊天提示信息*/		
		public static const Show_Area_Chat:int=5;
		
		//在这里写notice的写死的notice id:
		/**恭喜本次&1前三名：第一名&2，第二名&3，第三名&4！*/
		public static const Notice_id_3:int=3;
		/***********************宠物模块*************************/	
		/**你的&1已提升到&2级！*/
		public static const Notice_id_201:int=201;
		/**&1获得&2点经验。*/
		public static const Notice_id_802:int=802;
		/**恭喜！你的&1强化到&2级！*/
		public static const Notice_id_1001:int=1001;
		/**太遗憾了，&1强化失败了。*/
		public static const Notice_id_1002:int=1002;
		/**&1已学习。*/
		public static const Notice_id_1003:int=1003;
		/**&1领悟了&2！*/
		public static const Notice_id_1004:int=1004;
		/**没有空余技能栏。--暂时没做*/
		public static const Notice_id_1005:int=1005;
		/**恭喜！你的&1融合成功！*/
		public static const Notice_id_1006:int=1006;
		/**很遗憾，融合失败了。&1消失了--暂时没做*/
		public static const Notice_id_1007:int=1007;
		/**&1成功孵化出&2，&3好奇的张望着四周！*/
		public static const Notice_id_1008:int=1008;
		
		/**不能发送空消息*/
		public static const Notice_id_100:int=100;
		/***********************坐骑模块*************************/	
		/**&1成功孵化出&2，&3一声低吼，震倒众人无数！*/
		public static const Notice_id_1101:int=1101;
		
		/***********************组队模块*************************/	
		/**对方已组队。*/
		public static const Notice_id_1401:int=1401;
		/**&1加入队伍。*/
		public static const Notice_id_1402:int=1402;
		/**队伍已满。*/
		public static const Notice_id_1403:int=1403;
		/**&1离开队伍。*/
		public static const Notice_id_1404:int=1404;
		/**&1成为队长。*/
		public static const Notice_id_1405:int=1405;
		/**已申请入队!*/
		public static const Notice_id_1406:int=1406;
		/**该玩家已离线*/
		public static const Notice_id_1407:int=1407;
		/**邀请的队长不在*/
		public static const Notice_id_1408:int=1408;
		/**邀请的队伍已经不存在*/
		public static const Notice_id_1409:int=1409;
		/**【&1】已在你的队伍里*/
		public static const Notice_id_1410:int=1410;
		/**已邀请[&1]组队，等待对方回应。*/
		public static const Notice_id_1411:int=1411;
		
		/**消耗阅历*/
		public static const Notice_id_902:int=902;
		/**&1提升到&2级。*/
		public static const Notice_id_903:int=903;
		/**魔法值不足*/
		public static const Notice_id_904:int=904;
		/**技能正在CD中！*/
		public static const Notice_id_905:int=905;
		/** 906	3	14	#fff0b5	当前无法释放技能！
		 */		
		public static const Notice_id_906:int=906;
		/**907	3	14	#fff0b5	目标错误，不能释放技能！
		 */
		public static const Notice_id_907:int=907;
		
		/*************************公会******************************/
		/**公会名称已存在*/
		public static const Notice_id_1301:int=1301;
		/**你已在公会中*/
		public static const Notice_id_1302:int=1302;
		/**公会名称有非法字符，请重新输入。*/
		public static const Notice_id_1303:int=1303;
		/**&1加入公会！*/
		public static const Notice_id_1304:int=1304;
		/**&1成为&2！*/
		public static const Notice_id_1305:int=1305;
		/**&1离开公会！*/
		public static const Notice_id_1306:int=1306;
		/**公会人员已满，无法招收。*/
		public static const Notice_id_1307:int=1307;
		/**你加入公会：[{&1|#ff5200}]*/
		public static const Notice_id_1308:int=1308;
		//1309<=====================================================
		/**角色名不存在*/
		public static const Notice_id_1310:int=1310;
		/***公会人员已满，无法邀请*/
		public static const Notice_id_1311:int=1311;
		/**你已有公会，无法加入*/
		public static const Notice_id_1312:int=1312;
		/**公会人员已满，无法加入*/
		public static const Notice_id_1313:int=1313;
		/**职位人员已满，无法任命，否则职位任命成功。*/
		public static const Notice_id_1314:int=1314;
		/**只有移交会长后，才能退出公会。*/
		public static const Notice_id_1315:int=1315;
		/**&1发起对会长&2的弹劾，请打开公会界面进行操作！*/
		public static const Notice_id_1316:int=1316;
		/**本次弹劾成功，&1成为新的公会会长！*/
		public static const Notice_id_1317:int=1317;
		/**本次弹劾失败，&1成功连任会长一职！*/
		public static const Notice_id_1318:int=1318;
		//1319<===========================================================
		/**&1升级到&2级！*/
		public static const Notice_id_1320:int=1320;
		/**恭喜，公会成功提升到&1级！*/
		public static const Notice_id_1321:int=1321;
		/**您已申请太多公会，请休息一下！*/
		public static const Notice_id_1322:int=1322;
		/**您已申请过该公会*/
		public static const Notice_id_1323:int=1323;
		/**请输入玩家名*/
		public static const Notice_id_1324:int=1324;
		/**您发布的太频繁了，请稍候再试*/
		public static const Notice_id_1325:int=1325;
		/**今天的发布邀请次数已用完，请明天再发布！*/
		public static const Notice_id_1326:int=1326;
		/**公告未修改不能发布*/
		public static const Notice_id_1327:int=1327;
		/**请输入公会名*/
		public static const Notice_id_1328:int=1328;
		/***技能学习失败！*/
		public static const Notice_id_1329:int=1329;
		/**建筑升级成功*/
		public static const Notice_id_1330:int=1330;
		/**建筑升级失败*/
		public static const Notice_id_1331:int=1331;
		/**接受公会邀请成功*/
		public static const Notice_id_1332:int=1332;
		/**接受公会邀请失败*/
		public static const Notice_id_1333:int=1333;
		/**邀请发送成功*/
		public static const Notice_id_1334:int=1334;
		/***邀请发送失败*/
		public static const Notice_id_1335:int=1335;
		/**公会改名成功*/
		public static const Notice_id_1336:int=1336;
		/**公会改名失败*/
		public static const Notice_id_1337:int=1337;
		/**捐献成功*/
		public static const Notice_id_1338:int=1338;
		/**捐献失败*/
		public static const Notice_id_1339:int=1339;
		/**退出公会成功*/
		public static const Notice_id_1340:int=1340;
		/**退出公会失败*/
		public static const Notice_id_1341:int=1341;
		/**移交会长成功*/
		public static const Notice_id_1342:int=1342;
		/**移交会长失败*/
		public static const Notice_id_1343:int=1343;
		/**开除成功*/
		public static const Notice_id_1344:int=1344;
		/**开除失败*/
		public static const Notice_id_1345:int=1345;
		/**发布公告成功*/
		public static const Notice_id_1346:int=1346;
		/**发布公告失败*/
		public static const Notice_id_1347:int=1347;
		/**职位任命成功*/
		public static const Notice_id_1348:int=1348;
		/**职位任命失败*/
		public static const Notice_id_1349:int=1349;
		/**您已成功申请该公会，请等待公会管理员审核*/
		public static const Notice_id_1350:int=1350;
		/**申请失败*/
		public static const Notice_id_1351:int=1351;
		/**创建公会失败*/
		public static const Notice_id_1352:int=1352;
		/**你没有公会，无法邀请*/
		public static const Notice_id_1353:int=1353;
		/**你的公会职位不能邀请*/
		public static const Notice_id_1354:int=1354;
		/**对方等级不足，无法邀请*/
		public static const Notice_id_1355:int=1355;
		/**对方已有公会，无法邀请。*/
		public static const Notice_id_1356:int=1356;
		/**贡献不足，无法购买此商品*/
		public static const Notice_id_1357:int=1357;
		
		/***********************背包\锻造\市场\活动模块*************************/	
		/** 【&1】活动参加失败 */		
		public static const Notice_id_80:int=80;
		
		/** 获得&1x&2。 */		
		public static const Notice_id_300:int=300;
		/** 获得一件&1。 */		
		public static const Notice_id_301:int=301;
		/** 背包已满！ */		
		public static const Notice_id_302:int=302;
		/** 失去&1x&2。 */		
		public static const Notice_id_303:int=303;
		/** 失去一件&1。 */		
		public static const Notice_id_304:int=304;
		/** 你的&1使用时间已到期，道具已消失！ */		
		public static const Notice_id_305:int=305;
		/** 你的&1还有&2使用时间！ */	
		public static const Notice_id_306:int=306;
		
		/** 你的等级不够，无法穿上这个装备 */	
		public static const Notice_id_307:int=307;
		/** 你的性别不符，无法穿上这个装备 */	
		public static const Notice_id_308:int=308;
		/** 任务道具无法使用 */	
		public static const Notice_id_309:int=309;
		/** 道具在冷却时间中，无法使用 */	
		public static const Notice_id_310:int=310;
		/** 你的等级不够，无法使用这个物品 */	
		public static const Notice_id_311:int=311;
		/** 没有出战宠物无法使用 */	
		public static const Notice_id_312:int=312;
		/** 宠物生命值已满无需喂养 */	
		public static const Notice_id_313:int=313;
		/** 宠物快乐度已满无需喂养 */	
		public static const Notice_id_314:int=314;
		/** 宠物槽已全部开启 */	
		public static const Notice_id_315:int=315;
		/** 坐骑数量已满 */	
		public static const Notice_id_316:int=316;
		/** 你的血量已满 */	
		public static const Notice_id_317:int=317;
		/** 你的魔法值已满 */	
		public static const Notice_id_318:int=318;
		/** 魔钻不足！ */	
		public static const Notice_id_319:int=319;
		/** 使用道具失败！ */	
		public static const Notice_id_320:int=320;
		/** 穿装备失败！ */	
		public static const Notice_id_321:int=321;
		/** 删除背包物品失败！ */	
		public static const Notice_id_322:int=322;
		/** 移动物品失败！ */	
		public static const Notice_id_323:int=323;
		/** 拆分道具失败！ */	
		public static const Notice_id_324:int=324;
		/** 整理背包失败！ */	
		public static const Notice_id_325:int=325;
		/** 整理仓库失败！ */	
		public static const Notice_id_326:int=326;
		/** 扩展失败！ */	
		public static const Notice_id_327:int=327;
		/** 仓库已满，无法存放！ */	
		public static const Notice_id_328:int=328;
		/** 绑定物品不能寄售 */	
		public static const Notice_id_329:int=329;
		/** 任务道具不能出售 */	
		public static const Notice_id_330:int=330;
		/** 装备无需修理 */	
		public static const Notice_id_331:int=331;
		/** 银锭不足！ */	
		public static const Notice_id_332:int=332;
		/** 删除仓库物品失败 */	
		public static const Notice_id_333:int=333;
		/** 任务道具不能拖到仓库 */	
		public static const Notice_id_334:int=334;
		/** 任务道具不能丢弃 */	
		public static const Notice_id_335:int=335;
		
		/** 你获得&1 &2。——金钱，&1数量；&2货币单位 */		
		public static const Notice_id_401:int=401;
		/** 失去&1 &2。同401 */		
		public static const Notice_id_402:int=402;
		/** 你获得&1点经验。——人物经验 */		
		public static const Notice_id_801:int=801;
		/** 恭喜！你的&1强化到&2级！ */		
		public static const Notice_id_1201:int=1201;
		/** 太遗憾了，本次强化失败了。 */		
		public static const Notice_id_1202:int=1202;
		/** &1的&2强化到了&3级！——&1：角色名称；&2装备名称；&3强化等级 (需要全世界广播的)*/		
		public static const Notice_id_1203:int=1203;
		/** 装备进阶成功！ */		
		public static const Notice_id_1204:int=1204;
		/** 镶嵌成功！ */		
		public static const Notice_id_1205:int=1205;
		/** 你已摘除&1个镶嵌宝石。 */		
		public static const Notice_id_1206:int=1206;
		/** 镶嵌失败！ */		
		public static const Notice_id_1207:int=1207;
		/** 装备进阶失败！ */		
		public static const Notice_id_1208:int=1208;
		/** 请先放入装备。 */		
		public static const Notice_id_1209:int=1209;
		/** 装备没有可镶嵌的孔 */		
		public static const Notice_id_1210:int=1210;
		/** 道具不同，无法合成。 */		
		public static const Notice_id_1211:int=1211;
		/** 合成道具已有5个，不能再增加了！ */		
		public static const Notice_id_1212:int=1212;
		/** 很遗憾，本次合成失败了！ */		
		public static const Notice_id_1213:int=1213;
		/** 恭喜！合成成功！ */		
		public static const Notice_id_1214:int=1214;
		
		//////////////////////////////////////////锻造
		
		/** 镶嵌羽毛成功 */		
		public static const Notice_id_1215:int=1215;
		/** 镶嵌羽毛失败 */		
		public static const Notice_id_1216:int=1216;
		/** 翅膀进化成功 */		
		public static const Notice_id_1217:int=1217;
		/** 翅膀进化失败 */		
		public static const Notice_id_1218:int=1218;
		/** 装备分解失败 */		
		public static const Notice_id_1219:int=1219;
		/** 装备分解成功，分解后的材料已放入背包中 */		
		public static const Notice_id_1220:int=1220;
		/** 宝石已用完 */		
		public static const Notice_id_1221:int=1221;
		/** 道具已用完 */		
		public static const Notice_id_1222:int=1222;
		/** 请先选择主翅膀 */		
		public static const Notice_id_1223:int=1223;
		/** 孔已满，不能再放 */		
		public static const Notice_id_1224:int=1224;
		/** 同类型的羽毛只能放一个 */		
		public static const Notice_id_1225:int=1225;
		/** 背包里没有足够的材料 */		
		public static const Notice_id_1226:int=1226;
		/** 请先选择装备 */		
		public static const Notice_id_1227:int=1227;
		
		//////////////////////////////////////////////市场
		
		/** 你寄卖的道具&1已经出售，你获得&2 &3 */		
		public static const Notice_id_1601:int=1601;
		/** 你寄卖的道具&1已到期，请到拍卖行领取道具 */		
		public static const Notice_id_1602:int=1602;
		/** 寄售下架失败 */		
		public static const Notice_id_1603:int=1603;
		/** 寄售物品失败 */		
		public static const Notice_id_1604:int=1604;
		/** 寄售物品超过十条,不能寄售 */		
		public static const Notice_id_1605:int=1605;
		/** 求购下架失败 */		
		public static const Notice_id_1606:int=1606;
		/** 求购物品失败 */		
		public static const Notice_id_1607:int=1607;
		/** 取回物品失败 */		
		public static const Notice_id_1608:int=1608;
		/** 购买失败 */		
		public static const Notice_id_1609:int=1609;
		/** 出售失败 */		
		public static const Notice_id_1610:int=1610;
		/** 不在寄售列表，无法寄售这个物品 */		
		public static const Notice_id_1611:int=1611;
		
		/** 你的职业不符，不能穿上这个装备！ */		
		public static const Notice_id_1700:int=1700;
		/** 你装备的部位不对，不能穿上这个装备！ */		
		public static const Notice_id_1701:int=1701;
		/** 无法装备！ */		
		public static const Notice_id_1702:int=1702;
		/** 您的金钱不够！ */		
		public static const Notice_id_1703:int=1703;
		
		/** 角色查询失败 */		
		public static const Notice_id_1800:int=1800;
		/** 宠物查询失败 */		
		public static const Notice_id_1801:int=1801;
		
		/**  */		
		//		public static const Notice_id_1803:int=1803;
		/**  */		
		//		public static const Notice_id_1804:int=1804;
		/**  */		
		//		public static const Notice_id_1805:int=1805;
		
		/*****************系统奖励*******************************/
		/**领取失败*/
		public static const Notice_id_1900:int=1900;
		/**领取成功*/
		public static const Notice_id_1901:int=1901;
		
		/**********************在线奖励*************************/
		/**请等待XX分YY秒后领取奖励！*/
		public static const Notice_id_2000:int=2000;
		
		/*****************天命神脉*********************************/
		/**xx等级yy升级失败*/
		public static const Notice_id_2100:int=2100;
		/***等级不足，无法学习**/
		public static const Notice_id_2101:int=2101;
		/**阅历不足，无法学习*/
		public static const Notice_id_2102:int=2102;
		/**银锭不足，骚年继续努力吧！*/
		public static const Notice_id_2103:int=2103;
		/**太遗憾了，魔钻不足，不能学习了……*/
		public static const Notice_id_2104:int=2104;
		/**道具数量不足!*/
		public static const Notice_id_2105:int=2105;
		
		
		
		
		/***********************系统常量*************************/	
		/** 银币 */		
		public static const Notice_id_100000:int=100000;
		/** 银锭 */		
		public static const Notice_id_100001:int=100001;
		/** 魔钻 */		
		public static const Notice_id_100002:int=100002;
		/** 礼券 */		
		public static const Notice_id_100003:int=100003;
		//背包
		/** 请输入要拆分的数量 */		
		public static const Notice_id_100004:int=100004;
		/** 确认 */		
		public static const Notice_id_100005:int=100005;
		/** 取消 */		
		public static const Notice_id_100006:int=100006;
		/** 确认销毁【*】? */		
		public static const Notice_id_100007:int=100007;
		/** 确认销毁 */		
		public static const Notice_id_100008:int=100008;
		/** 确认丢弃【*】? */		
		public static const Notice_id_100009:int=100009;
		/** 确认丢弃 */		
		public static const Notice_id_100010:int=100010;
		/** 扩展7格背包，需要花费*魔钻，是否继续？ */		
		public static const Notice_id_100011:int=100011;
		/** 扩展背包 */		
		public static const Notice_id_100012:int=100012;
		/** 魔钻：RMB充值得到，同账号角色共用 */		
		public static const Notice_id_100013:int=100013;
		/** 银币：不绑定的游戏币，可以流通 */		
		public static const Notice_id_100014:int=100014;
		/** 礼券：系统赠送，商城礼券专区使用 */		
		public static const Notice_id_100015:int=100015;
		/** 银锭：绑定的游戏币，不能流通 */		
		public static const Notice_id_100016:int=100016;
		/** 你有更好的装备： */		
		public static const Notice_id_100017:int=100017;
		/** 立即穿上 */		
		public static const Notice_id_100018:int=100018;
		/** 你得到了一个宠物蛋： */		
		public static const Notice_id_100019:int=100019;
		/** 点击孵化 */		
		public static const Notice_id_100020:int=100020;
		/** 使用 */		
		public static const Notice_id_100021:int=100021;
		/** 拆分 */		
		public static const Notice_id_100022:int=100022;
		/** 展示 */		
		public static const Notice_id_100023:int=100023;
		/** 丢弃 */		
		public static const Notice_id_100024:int=100024;
		/** 点击可扩展背包 */		
		public static const Notice_id_100025:int=100025;
		/** 点击可扩展仓库 */		
		public static const Notice_id_100026:int=100026;
		/** 扩展7格仓库，需要花费*银币，是否继续？ */		
		public static const Notice_id_100027:int=100027;
		/** 扩展仓库 */		
		public static const Notice_id_100028:int=100028;
		/** 体质： */		
		public static const Notice_id_100029:int=100029;
		/** 力量： */		
		public static const Notice_id_100030:int=100030;
		/** 敏捷 ：*/		
		public static const Notice_id_100031:int=100031;
		/** 智力 ：*/		
		public static const Notice_id_100032:int=100032;
		/** 精神 ：*/		
		public static const Notice_id_100033:int=100033;
		/** 潜力 ：*/		
		public static const Notice_id_100034:int=100034;
		/** 数量： */		
		public static const Notice_id_100035:int=100035;
		/** 请输入搜索物品 */		
		public static const Notice_id_100036:int=100036;
		/** 重置 */		
		public static const Notice_id_100037:int=100037;
		/** 求购 */		
		public static const Notice_id_100038:int=100038;
		/** 购买 */		
		public static const Notice_id_100039:int=100039;
		/** 出售 */		
		public static const Notice_id_100040:int=100040;
		/** 寄售 */		
		public static const Notice_id_100041:int=100041;
		/** 寄售下架 */		
		public static const Notice_id_100042:int=100042;
		/** 求购下架 */		
		public static const Notice_id_100043:int=100043;
		/** 买入 */		
		public static const Notice_id_100044:int=100044;
		/** 卖出 */		
		public static const Notice_id_100045:int=100045;
		/** 排名分类 */		
		public static const Notice_id_100046:int=100046;
		/** 排行名称 */		
		public static const Notice_id_100047:int=100047;
		/** 排行主体 */		
		public static const Notice_id_100048:int=100048;
		/** 排名 */		
		public static const Notice_id_100049:int=100049;
		/** 排行值 */		
		public static const Notice_id_100050:int=100050;
		/** 请稍候…… */		
		public static const Notice_id_100051:int=100051;
		/** 未上榜 */		
		public static const Notice_id_100052:int=100052;
		/** 宠物类型： */		
		public static const Notice_id_100053:int=100053;
		/** 物理攻击： */		
		public static const Notice_id_100054:int=100054;
		/** 魔法攻击： */		
		public static const Notice_id_100055:int=100055;
		/** 物理防御： */		
		public static const Notice_id_100056:int=100056;
		/** 魔法防御： */		
		public static const Notice_id_100057:int=100057;
		/** 成长率： */		
		public static const Notice_id_100058:int=100058;
		/** 战斗力 ： */		
		public static const Notice_id_100059:int=100059;
		/** 合成费用： */		
		public static const Notice_id_100060:int=100060;
		/**经验*/		
		public static const Notice_id_100061:int=100061;
		/**点击领取奖励*/
		public static const Notice_id_100062:int=100062;
		/**等待*/
		public static const Notice_id_100063:int=100063;
		/**领取在线奖励*/
		public static const Notice_id_100064:int=100064;
		/**装备*/
		public static const Notice_id_100065:int=100065;
		/**道具*/
		public static const Notice_id_100066:int=100066;
		/**阅历*/
		public static const Notice_id_100067:int=100067;
		/**消耗银锭：*/
		public static const Notice_id_100068:int=100068;
		/**等级：*/
		public static const Notice_id_100069:int=100069;
		/**成功率：*/
		public static const Notice_id_100070:int=100070;
		
		/** 你得到了一个坐骑蛋 */		
		public static const Notice_id_100071:int=100071;
		/**贡献*/
		public static const Notice_id_100072:int=100072;

	}
} 