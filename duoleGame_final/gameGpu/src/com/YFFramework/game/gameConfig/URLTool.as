package com.YFFramework.game.gameConfig
{
	import com.YFFramework.core.debug.print;
	
	

	/**文件目录地址
	 * 
	 * @author yefeng
	 *2012-4-21下午8:10:51
	 */
	public class URLTool
	{
		private static var root:String;
		
		/**版本号
		 */		
		private static var version:String;
		
		public function URLTool()
		{
		}
		/**
		 * @param root   根目录 
		 * @param version		 版本号  COnfigManager.getVersionStr
		 */		
		public static function initRoot(root:String,versionStr:String):void
		{
			URLTool.root=root;
			URLTool.version=versionStr;///发布时候待去掉
//			URLTool.version="?"+(new Date()).time+""+Math.random();//getTimer()+""+Math.random();////随机
//			print("URLTool","此处加了随机版本号");
		}
		
		private static function getCommonDir():String
		{
			return root+"common/";
		}
		
		private static function getLoadingDir():String
		{
			return getCommonDir()+"loading/"
		}
		
		/**  dyUI 目录
		 */
		private static function getDyUIDir():String
		{
			return root+"dyUI/";
		}
		/** 物品目录
		 * @return 
		 */		
		private static function getGoodsDir():String
		{
			return getDyUIDir()+"goodsIcon/";
		}
		
		/**养成任务图标目录
		 * @return  
		 */		
		private static function getGrowTaskDir():String{
			return getDyUIDir()+"growTaskIcon/";
		}
		
		private static function getMovieDir():String
		{
			return getDyUIDir()+"movie/";
		}
		
		private static function getRoleDir():String
		{
			return getMovieDir()+"role/";
		}
		
		/**得到技能目录 
		 */
		private static function getSkillDir():String
		{
			return getMovieDir()+"skill/";	
		}
		
		
		/** 得到场景修饰建筑的目录
		 */
		private static function getBuildingDir():String
		{
			return getMapDir()+"building/";
		}
		/**得到场景npc目录
		 */
		private static function getNpcDir():String
		{
			return getMapDir()+"npc/";
		}
		
		private static function getCommonAssetsDir():String
		{
			return getDyUIDir()+"commonAssets/";
		}
		/** 模块UI资源
		 */		
		public static function getDyModuleUI(name:String):String
		{
			return getCommonAssetsDir()+"dyModuleUI/"+name+version;
		}

		/**获取loading目录下 的资源
		 * 资源名称
		 */
		public static function getLoadingAssets(name:String):String
		{
			return getLoadingDir()+name+version;
		}
		
		/**
		 * @param name必须带上资源后缀名     资源名称  得到 commonAssets 文件夹的 资源 该文件主要放一些常用的图片   以及各个模块需要的背景 以及功能swf 
		 * @return   返回资源路径
		 */		
		public static function getCommonAssets(name:String):String
		{
			return getCommonAssetsDir()+name+version;
		}
		
		/**养成任务图标资源
		 * @param iconId
		 * @return 
		 */		
		public static function getGrowTaskIcon(iconId:int):String{
			return getGrowTaskDir()+iconId+".png"+version;
		}
		
		/** 获取技能资源
		 * @param skinId
		 * 
		 */		
		public static function getSkill(skinId:int):String
		{
			return getSkillDir()+skinId+".atfMovie"+version;
		}
		/**获取陷阱资源
		 */		
		public static function getTrap(skinId:int):String
		{
			return getMovieDir()+"trap/"+skinId+".atfMovie"+version;
		}
		
		

		/** 得到套装
		 */
		public  static function getClothStandWalk(skinId:int):String
		{
			return getRoleDir()+"clothStandWalk/"+skinId+".atfMovie"+version;
		}
		
		public  static function getClothStandWalkView(skinId:int):String
		{
			return getRoleDir()+"clothView/"+skinId+".chitu"+version;
		}

		
		/**攻击
		 */
		public  static function getClothFight(skinId:int):String
		{
			return getRoleDir()+"clothFight/"+skinId+".atfMovie"+version;
		}

		/**受击死亡
		 */
		public  static function getClothInjureDead(skinId:int):String
		{
			return getRoleDir()+"clothInjureDead/"+skinId+".atfMovie"+version;
		}
		/**  主角不拿武器的攻击动作    特殊攻击
		 * @param skinId
		 * @return 
		 */		
		public static function getClothAtk(skinId:int):String
		{
			return getRoleDir()+"clothAtk/"+skinId+".atfMovie"+version;	
		}
		/**获取衣服战斗待机
		 */		
		public static function getClothFightStand(skinId:int):String
		{
			return getRoleDir()+"clothFightStand/"+skinId+".atfMovie"+version;	
		}
		/**  衣服光效id 
		 */
		public  static function getClothEffectStandWalk(skinId:int):String
		{
			return getRoleDir()+"clothEffectStandWalk/"+skinId+".atfMovie"+version;
		}
		
		public  static function getClothEffectStandWalkView(skinId:int):String
		{
			return getRoleDir()+"clothEffectView/"+skinId+".chitu"+version;
		}

		
		
		public  static function getClothEffectInjureDead(skinId:int):String
		{
			return getRoleDir()+"clothEffectInjureDead/"+skinId+".atfMovie"+version;
		}

		public  static function getClothEffectFight(skinId:int):String
		{
			return getRoleDir()+"clothEffectFight/"+skinId+".atfMovie"+version;
		}
		/**  衣服战斗光效id 
		 * @param skinId
		 * @return 
		 */		
		public static function getClothEffectAtk(skinId:int):String
		{
			return getRoleDir()+"clothEffectAtk/"+skinId+".atfMovie"+version;	
		}
		/**获取衣服战斗待机光效id 
		 */		
		public static function getClothEffectFightStand(skinId:int):String
		{
			return getRoleDir()+"clothEffectFightStand/"+skinId+".atfMovie"+version;	
		}

		
		
		
		
		/** 武器
		 *  得到武器 
		 */
		public static function getWeaponStandWalk(skinId:int):String
		{
			return getRoleDir()+"weaponStandWalk/"+skinId+".atfMovie"+version;	
		}
		
		public static function getWeaponStandWalkView(skinId:int):String
		{
			return getRoleDir()+"weaponView/"+skinId+".chitu"+version;	
		}

		
		
		public static function getWeaponInjureDead(skinId:int):String
		{
			return getRoleDir()+"weaponInjureDead/"+skinId+".atfMovie"+version;	
		}

		public static function getWeaponFight(skinId:int):String
		{
			return getRoleDir()+"weaponFight/"+skinId+".atfMovie"+version;	
		}
		
		/**武器特殊 攻击动作
		 * @param skinId
		 */		
		public static function getWeaponAtk(skinId:int):String
		{
			return getRoleDir()+"weaponAtk/"+skinId+".atfMovie"+version;	
		}
		/**
		 */		
		public static function getWeaponFightStand(skinId:int):String
		{
			return getRoleDir()+"weaponFightStand/"+skinId+".atfMovie"+version;	
		}
		
		/**获取武器特效id 
		 */
		public static function getWeaponEffectStandWalk(skinId:int):String
		{
			return getRoleDir()+"weaponEffectStandWalk/"+skinId+".atfMovie"+version;	
		}
		public static function getWeaponEffectStandWalkView(skinId:int):String
		{
			return getRoleDir()+"weaponEffectView/"+skinId+".chitu"+version;	
		}

		
		public static function getWeaponEffectInjureDead(skinId:int):String
		{
			return getRoleDir()+"weaponEffectInjureDead/"+skinId+".atfMovie"+version;	
		}
		
		public static function getWeaponEffectFight(skinId:int):String
		{
			return getRoleDir()+"weaponEffectFight/"+skinId+".atfMovie"+version;	
		}
		/**武器 特殊攻击特效id 
		 */
		public static function getWeaponEffectAtk(skinId:int):String
		{
			return getRoleDir()+"weaponEffectAtk/"+skinId+".atfMovie"+version;	
		}
		/**武器战斗待机 特效id 
		 */
		public static function getWeaponEffectFightStand(skinId:int):String
		{
			return getRoleDir()+"weaponEffectFightStand/"+skinId+".atfMovie"+version;	
		}
		

		/**获取翅膀
		 * @param skinId
		 * @return 
		 * 
		 */		
		public static function getWingStandWalk(skinId:int):String
		{
			return getRoleDir()+"wingStandWalk/"+skinId+".atfMovie"+version;	
		}
		
		public static function getWingStandWalkView(skinId:int):String
		{
			return getRoleDir()+"wingView/"+skinId+".chitu"+version;	
		}

		
		public static function getWingInjureDead(skinId:int):String
		{
			return getRoleDir()+"wingInjureDead/"+skinId+".atfMovie"+version;	
		}
		
		public static function getWingFight(skinId:int):String
		{
			return getRoleDir()+"wingFight/"+skinId+".atfMovie"+version;	
		}
		/**翅膀特殊攻击动作
		 */		
		public static function getWingAtk(skinId:int):String
		{
			return getRoleDir()+"wingAtk/"+skinId+".atfMovie"+version;	
		}
		/**获取翅膀战斗待机
		 */		
		public static function getWingFightStand(skinId:int):String
		{
			return getRoleDir()+"wingFightStand/"+skinId+".atfMovie"+version;	
		}

		/**获取坐骑上的翅膀
		 */
		public static function getMountWing(skinId:int):String
		{
			return getRoleDir()+"mountWing/"+skinId+".atfMovie"+version;	
		}
		/**获取人物称号
		 */		
		public static function getTittle(skinId:int):String
		{
			return getRoleDir()+"tittle/"+skinId+".chitu"+version;	
		}
		
		/** 获取采集物  衣服  皮肤 
		 */		
		public static function getGatherCloth(skinId:int):String
		{
			return getRoleDir()+"gather/"+skinId+".atfMovie"+version;	
		}
		/**获取采集的图标
		 */		
		public static function getGatherIcon(skinId:int):String
		{
			return getGoodsDir()+"gatherIcon/"+skinId+".png"+version;	
		}

		/**得到坐骑衣服
		 */		
		public static function getMountCloth(skinId:int):String
		{
			return getRoleDir()+"mountCloth/"+skinId+".atfMovie"+version;	
		}
		
		/**坐骑上衣服特效
		 */
		public static function getMountClothEffect(skinId:int):String
		{
			return getRoleDir()+"mountClothEffect/"+skinId+".atfMovie"+version;	
		}

		/**获得坐骑图标 
		 */		
		public static function getMountIcon(skinId:int):String
		{
			return getGoodsDir()+"monsterIcon/"+skinId+".png"+version;	
		}
		/**得到坐骑 躯干   场景显示
		 */
		public static function getMountBody(skinId:int):String
		{
			return getRoleDir()+"mountBody/"+skinId+".atfMovie"+version;	
		}
		public static function getMountBodyView(skinId:int):String
		{
			return getRoleDir()+"mountBodyView/"+skinId+".chitu"+version;	
		}

		/**得到坐骑的头部 场景显示
		 */		
		public static function getMountHead(skinId:int):String
		{
			return getRoleDir()+"mountHead/"+skinId+".atfMovie"+version;	
		}
		public static function getMountHeadView(skinId:int):String
		{
			return getRoleDir()+"mountHeadView/"+skinId+".chitu"+version;	
		}
		/**获取npc资源
		 */		
		public static function getNPC(skinId:int):String
		{
			return getRoleDir()+"npc/"+skinId+".atfMovie"+version;	
		}
		/** 获取npc 小图标
		 */		
		public static function getNpcSmallIcon(skinId:int):String
		{
			return getGoodsDir()+"npcSmallIcon/"+skinId+".png"+version;
		}
		/** NPC中等像图标
		 */		
		public static function getNPCHalfIcon(skinId:int):String
		{
			return getGoodsDir()+"npcHalfIcon/"+skinId+".swf"+version;
		}

		/**获取活动图标
		 */
		public static function getActivityIcon(skinId:int):String
		{
			return getGoodsDir()+"activityIcon/"+skinId+".png"+version;
		}
		/**获取打坐皮肤
		 */		
		public static function getSitCloth(skinId:int):String
		{
			return getRoleDir()+"sit/"+skinId+".atfMovie"+version;	

		}
		/** 获取打坐的武器
		 */		
		public static function getSitWeapon(skinId:int):String
		{
			return getRoleDir()+"sit/"+skinId+".atfMovie"+version;	
		}
		
		/**得到怪物皮肤地址  宠物的皮肤也在这里面   硬件加速资源
		 */ 
		public static function getMonsterStandWalk(skinId:int):String
		{
			return getRoleDir()+"monsterStandWalk/"+skinId+".atfMovie"+version;	
		}
		
		/** petView 
		 */
		public static function getPetView(skinId:int):String
		{
			return getRoleDir()+"petView/"+skinId+".chitu"+version;	
		}

		/**怪物  受击死亡
		 */
		public static function getMonsterInjureDead(skinId:int):String
		{
			return getRoleDir()+"monsterInjureDead/"+skinId+".atfMovie"+version;	
		}

		/**怪物  战斗
		 */
		public static function getMonsterFight(skinId:int):String
		{
			return getRoleDir()+"monsterFight/"+skinId+".atfMovie"+version;	
		}
		
		
		public static function  getCommonEffect_swf(str:String):String
		{
			return getMovieDir()+"commonEffect/"+str+".swf"+version;
		}

		/** 动画文件格式
		 * @param str
		 * @return
		 */		
		public static function getCommonEffect_yf2d(str:String):String
		{
			return getMovieDir()+"commonEffect/"+str+".atfMovie"+version;
		}
		
		public static function getCommonEffect_Chitu(str:String):String
		{
			return getMovieDir()+"commonEffect/"+str+".chitu"+version;
		}
		
		/**获取怪物的图像
		 */ 
		public static function getMonsterIcon(id:int):String
		{
			return getMonsterIconDir()+id+".png";
		}
		
		/**怪物图像的图像
		 */ 
		private static function getMonsterIconDir():String
		{
			return getGoodsDir()+"monsterIcon/";
		}

		/**获取buff图标
		 */		
		public static function getBuffIcon(id:int):String
		{
			return getGoodsDir()+"buff/"+id+".png"+version;
		}
		
		/**人物图像目录
		 */		
		private static function getAvartarIconDir():String
		{
			return getGoodsDir()+"avatar/";
		}
		/**   人物图像图标  主人物  左上角 的图像
		 * @param id
		 * @return 
		 */		
		public static function getAvatarShowIcon(id:int):String
		{
			return getAvartarIconDir()+"showIcon/"+id+".png"+version;
		}
		/** 获取队员的小图标
		 */		
		public static function getAvatarTeamSmallIcon(id:int):String
		{
			return getAvartarIconDir()+"teamSmallIcon/"+id+".png"+version;
		}
		/**  队员图标  在场景上显示   队友图像，在场景队员列表中显示的图像，左边从上到下的一排队友图像
		 */		
		public static function getAvatarTeamSceneIcon(id:int):String
		{
			return getAvartarIconDir()+"teamSceneIcon/"+id+".png"+version;
		}
		/** 好友列表中的玩家图像
		 */		
		public static function getAvatarFriendIcon(id:int):String
		{
			return getAvartarIconDir()+"friendIcon/"+id+".png"+version;
		}
		/** 好友列表中的 左上角的玩家图像
		 */	
		public static function getAvatarFriendBigIcon(id:int):String
		{
			return getAvartarIconDir()+"friendBigIcon/"+id+".png"+version;
		}
		
		/** 获取玩家的半身像
		 */	
		public static function getAvatarHalfIcon(id:int):String
		{
			return getAvartarIconDir()+"halfIcon/"+id+".swf"+version;
		}

		/**获取场景好友聊天  icon图标
		 */		
		public static function getAvatarFriendSceneIcon(id:int):String
		{
			return getAvartarIconDir()+"friendSceneIcon/"+id+".png"+version;
		}

		private static function getMapDir():String
		{
			return getDyUIDir()+"mapScence/"			
		}
		
		
		/**小地图雷达图片
		 */
		public static function getSmallMapImage(skinId:int):String
		{
			return getMapDir()+skinId+"s.jpg"+version
		}
		/**得到低像素的图片atf
		 *  获取小图片 预览整个场景的图片
		 */
		public static function getLowMapImage(skinId:int):String
		{
			return getMapDir()+skinId+"m.atf"+version
		}
		
		
		
		
		/**得到地图的配置文件
		 */
		public static function getMapConfig(skinId:int):String
		{
			return getMapDir()+skinId+".xx2d"+version;
		}
		/**返回地图编辑器网格数据
		 */
		public static function getMapGridData(skinId:int):Object
		{
			return null;//返回网格数据
		}
		/** 根据skinId 和 图片的 x y 索引 找到对应的图片   atf文件
		 */
		public static function getMapSliceImage(skinId:int,xIndex:int,yIndex:int):String
		{
			return getMapDir()+skinId+"/"+xIndex+"_"+yIndex+".atf"+version;
		}
		
		/** 根据skinId 和 图片的 x y 索引 找到对应的图片  常规图片
		 */
		public static function getMapSliceImageBitmap(skinId:int,xIndex:int,yIndex:int):String
		{
			return getMapDir()+skinId+"m/"+xIndex+"_"+yIndex+".jpg"+version;
		}

		
		
		/**得到建筑物  所有的建筑物都是swf  name里面已经包含了 .atfMovie ,在地编文件.xx里面
		 */
		public static function getMapBuilding(name:String):String
		{
			return getBuildingDir()+name+version;//+".swf";
		}
		/** 获取npc  npc 是 .atfMovie文件格式,name里面已经包含了 .atfMovie ,在地编文件.xx里面
		 *   这个方法要去掉.....
		 */
		public static function getMapNPC(npc:String):String
		{
			return getNpcDir()+npc+version;//+".atfMovie";
		}
		
		/**获得物品图标 ，目录
		 */		
		public static function getGoodsIcon(skinId:int):String
		{
			return getGoodsDir()+"goods/"+skinId+".png"+version;
		}
		
		/**取天命神脉的神脉图标*/
		public static function getPulseIcon(id:int):String
		{
			return getGoodsDir()+"pulseIcon/"+id+".png"+version;
		}
		/**
		 * 天命神脉大图标
		 */		
		public static function getPulseBigIcon(id:int):String
		{
			return getGoodsDir()+"pulseIcon/bigPulse/"+id+".png"+version;
		}
		/**获取物品掉落 图标
		 */		
//		public static function getDropGoodsIcon(skinId:int):String
//		{
//			return getGoodsDir()+"dropIcon/"+skinId+".png"+version;
//		}
		
		/**获取技能图标
		 */		
		public static function getSkillIcon(id:int):String
		{
			return getGoodsDir()+"skill/"+id+".png"+version;
		}
		/**镶嵌宝石存放文件加
		 */		
		public static function getInlayIcon(id:int):String
		{
			return getGoodsDir()+"inlayIcon/"+id+".png"+version;
		}
		
		/**获取背景音乐
		 * @param id
		 */		
		public static function getBgMusic(id:int):String
		{
			return getDyUIDir()+"sound/"+id+".mp3"+version;
		}
		
		/**获取数据路径
		 * @return  
		 */		
		public static function getDataDir():String{
			return root+"data/";
		}
	}
}