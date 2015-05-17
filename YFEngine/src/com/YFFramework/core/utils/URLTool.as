package com.YFFramework.core.utils
{
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
			URLTool.version=versionStr;
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
		
		
		
		/**得到通用技能特效 swf形式
		 */
//		public static function  getSkillCommon_swf(skinId:int):String
//		{
//			return getSkillDir()+"common/"+skinId+".swf"+version;
//		}
//		public static function getSkillCommon_chitu(skinId:int):String
//		{
//			return getSkillDir()+"common/"+skinId+".yf2d"+version;
//		}
		
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
		/**  得到武器 
		 */
		public static function getWeapon(skinId:int):String
		{
			return getRoleDir()+"weapon/"+skinId+".yf2d"+version;	
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
		
		/**得到怪物皮肤地址  宠物的皮肤也在这里面
		 */ 
		public static function getMonster(skinId:int):String
		{
			return getRoleDir()+"monster/"+skinId+".yf2d"+version;	
		}
		/**获取非硬件加速资源
		 */ 
		public static function getMonsterBitMap(skinId:int):String
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
		public static function getCommonEffect_HSWF(str:String):String
		{
			return getMovieDir()+"commonEffect/"+str+".yf2d"+version;
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
		
		/**怪物图像的图像
		 */ 
		private static function getMonsterIconDir():String
		{
			return getAvartarIconDir()+"monster/";
		}
		/**宠物图像的图像
		 */ 
		private static function getPetIconDir():String
		{
			return getAvartarIconDir()+"pet/";
		}
		/**
		 * 获取角色图像 
		 */		
		public static function getRoleIcon(id:int):String
		{
			return getRoleIconDir()+id+".jpg";
		}
		/**
		 *获取宠物图标 
		 */		
		public static function getPetIcon(id:int):String
		{
			return getPetIconDir()+id+".jpg";

		}
		/**获取怪物的图像
		 */ 
		public static function getMonsterIcon(id:int):String
		{
			return getMonsterIconDir()+id+".jpg";

		}
		private static function getMapDir():String
		{
			return getDyUIDir()+"mapScence/"			
		}
		
		
		/**得到低像素的图片
		 */
		public static function getMapLowImage(skinId:int):String
		{
			return getMapDir()+skinId+"m.map"
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
		/** 获取npc  npc 是 .chitu文件格式,name里面已经包含了 .yf2d ,在地编文件.xx里面
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
		/**获取技能图标
		 */		
		public static function getSkillIcon(id:int):String
		{
			return getGoodsDir()+"skill/"+id+".png"+version;
		}
		
		
		
	}
}