package com.YFFramework.core.utils
{
	import flash.utils.getTimer;
	

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
			URLTool.version=versionStr+Math.random()+"???"+getTimer();////随机
//			print("URLTool","此处加了随机版本号");
		}
		
		private static function getCommonDir():String
		{
			return root+"common/";
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
		/**
		 * @param name必须带上资源后缀名     资源名称  得到 commonAssets 文件夹的 资源 该文件主要放一些常用的图片   以及各个模块需要的背景 以及功能swf 
		 * @return   返回资源路径
		 */		
		public static function getCommonAssets(name:String):String
		{
			return getCommonAssetsDir()+name+version;
		}
		
		
		/** 获取技能资源
		 * @param skinId
		 * 
		 */		
		public static function getSkill(skinId:int):String
		{
			return getSkillDir()+skinId+".yf2d"+version;
		}
		
		
		
		/** 得到套装
		 */
		public  static function getCloth(skinId:int):String
		{
			return getRoleDir()+"cloth/"+skinId+".yf2d"+version;
		}
		/**套装
		 * @param skinId
		 * @return 
		 * 
		 */		
		public  static function getClothNormal(skinId:int):String
		{
			return getRoleDir()+"cloth/"+skinId+".chitu"+version;
		}
		/** 武器
		 *  得到武器 
		 */
		public static function getWeapon(skinId:int):String
		{
			return getRoleDir()+"weapon/"+skinId+".yf2d"+version;	
		}
		
		public static function getWeaponNormal(skinId:int):String
		{
			return getRoleDir()+"weapon/"+skinId+".chitu"+version;	
		}

		/**获取翅膀
		 * @param skinId
		 * @return 
		 * 
		 */		
		public static function getWing(skinId:int):String
		{
			return getRoleDir()+"wing/"+skinId+".yf2d"+version;	
		}
		
		public static function getWingNormal(skinId:int):String
		{
			return getRoleDir()+"head/"+skinId+".chitu"+version;	
		}
		
		

		/**得到坐骑衣服
		 */		
		public static function getMountCloth(skinId:int):String
		{
			return getRoleDir()+"mountCloth/"+skinId+".yf2d"+version;	
		}
		
		/**得到坐骑
		 */
		public static function getMount(skinId:int):String
		{
			return getRoleDir()+"mount/"+skinId+".yf2d"+version;	
		}
		/**获取打坐皮肤
		 */		
		public static function getSitCloth(skinId:int):String
		{
			return getRoleDir()+"sit/"+skinId+".yf2d"+version;	

		}
		/** 获取打坐的武器
		 */		
		public static function getSitWeapon(skinId:int):String
		{
			return getRoleDir()+"sit/"+skinId+".yf2d"+version;	
		}
		
		/**得到怪物皮肤地址  宠物的皮肤也在这里面   硬件加速资源
		 */ 
		public static function getMonster(skinId:int):String
		{
			return getRoleDir()+"monster/"+skinId+".yf2d"+version;	
		}
		/**返回的是怪物资源
		 */			
		public static function getMonsterNormal(skinId:int):String
		{
			return getRoleDir()+"monster/"+skinId+".chitu"+version;	
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
			return getMovieDir()+"commonEffect/"+str+".yf2d"+version;
		}
		
		public static function getCommonEffect_Chitu(str:String):String
		{
			return getMovieDir()+"commonEffect/"+str+".chitu"+version;
		}
		
		/**  人物 宠物的图标
		 */ 
		private static function getAvartarIconDir():String
		{
			return getMovieDir()+"avartarIcon/";
		}
		
		/**玩家图像
		 */ 
		private static function getRoleIconDir():String
		{
			return getAvartarIconDir()+"role/";
		}
		
		/**
		 * 获取角色图像 
		 */		
		public static function getRoleIcon(id:int):String
		{
			return getRoleIconDir()+id+".jpg";
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
			return getGoodsDir()+"buff/"+id+".png";
		}
		/**   人物图像图标
		 * @param id
		 * @return 
		 */		
		public static function getAvatarIcon(id:int):String
		{
			return getGoodsDir()+"avatar/"+id+".png";
		}
		
		
		private static function getMapDir():String
		{
			return getDyUIDir()+"mapScence/"			
		}
		
		
		/**得到低像素的图片
		 */
		public static function getMapLowImage(skinId:int):String
		{
			return getMapDir()+skinId+"s.jpg"
		}
		/**  获取小图片 预览整个场景的图片
		 * @param skinId
		 */		
		public static function getMapSmallImage(skinId:int):String
		{
			return getMapDir()+skinId+"s.jpg"
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
		/** 根据skinId 和 图片的 x y 索引 找到对应的图片
		 */
		public static function getMapSliceImage(skinId:int,xIndex:int,yIndex:int):String
		{
			return getMapDir()+skinId+"/"+xIndex+"_"+yIndex+".map";
		}
		
		
		/**得到建筑物  所有的建筑物都是swf  name里面已经包含了 .yf2d ,在地编文件.xx里面
		 */
		public static function getMapBuilding(name:String):String
		{
			return getBuildingDir()+name+version;//+".swf";
		}
		/** 获取npc  npc 是 .yf2d文件格式,name里面已经包含了 .yf2d ,在地编文件.xx里面
		 */
		public static function getMapNPC(npc:String):String
		{
			return getNpcDir()+npc+version;//+".yf2d";
		}
		
		/**获得物品图标 ，目录
		 */		
		public static function getGoodsIcon(skinId:int):String
		{
			return getGoodsDir()+"goods/"+skinId+".png"+version;
		}
		/**获取物品掉落 图标
		 */		
		public static function getDropGoodsIcon(skinId:int):String
		{
			return getGoodsDir()+"dropIcon/"+skinId+".png"+version;
		}
			
		/**获取技能图标
		 */		
		public static function getSkillIcon(id:int):String
		{
			return getGoodsDir()+"skill/"+id+".png"+version;
		}
		
		/**获取背景音乐
		 * @param id
		 */		
		public static function getBgMusic(id:int):String
		{
			return getDyUIDir()+"sound/"+id+".mp3"+version;
		}
		
		
	}
}