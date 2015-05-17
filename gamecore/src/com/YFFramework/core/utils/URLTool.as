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
		
		public function URLTool()
		{
		}
		public static function initRoot(root:String):void
		{
			URLTool.root=root;
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
		
		
		/**得到通用技能特效 swf形式
		 */
		public static function  getSkillCommon_swf(skinId:int):String
		{
			return getSkillDir()+"common/"+skinId+".swf";
		}
		public static function getSkillCommon_chitu(skinId:int):String
		{
			return getSkillDir()+"common/"+skinId+".chitu";
		}
		
		/** 得到套装
		 */
		public  static function getCloth(skinId:int):String
		{
			return getRoleDir()+"cloth/"+skinId+".chitu";
		}
		/**  得到武器 
		 */
		public static function getWeapon(skinId:int):String
		{
			return getRoleDir()+"weapon/"+skinId+".chitu";	
		}
		/**得到坐骑衣服
		 */		
		public static function getMountCloth(skinId:int):String
		{
			return getRoleDir()+"mountCloth/"+skinId+".chitu";	
		}
		
		/**得到坐骑
		 */
		public static function getMount(skinId:int):String
		{
			return getRoleDir()+"mount/"+skinId+".chitu";	
		}
			
		public static function  getUIEffect_swf(str:String):String
		{
			return getCommonDir()+"uiEffect/"+str+".swf";
		}
		public static function getUIEffect_chitu(str:String):String
		{
			return getCommonDir()+"uiEffect/"+str+".chitu";
		}
		
		public static function getMapDir():String
		{
			return getDyUIDir()+"mapScence/"			
		}
		
		
		/**得到低像素的图片
		 */
		public static function getMapLowImage(skinId:int):String
		{
			return getMapDir()+skinId+"s.jpg"
		}
		
		/**得到地图的配置文件
		 */
		public static function getMapConfig(skinId:int):String
		{
			return getMapDir()+skinId+".xx"
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
			return getMapDir()+skinId+"/"+xIndex+"_"+yIndex+".jpg";
		}
		
		
		/**得到建筑物  所有的建筑物都是swf  name里面已经包含了 .swf ,在地编文件.xx里面
		 */
		public static function getMapBuilding(name:String):String
		{
			return getBuildingDir()+name;//+".swf";
		}
		/** 获取npc  npc 是 .chitu文件格式,name里面已经包含了 .chitu ,在地编文件.xx里面
		 */
		public static function getMapNPC(npc:String):String
		{
			return getNpcDir()+npc;//+".chitu";
		}
		
		/**获得物品图标 ，目录
		 */		
		public static function getGoodsIcon(skinId:int):String
		{
			return getGoodsDir()+"goods/"+skinId+".png";
		}
		
		
	}
}