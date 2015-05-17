package com.YFFramework.core.world.model
{
	/**  缓存 地图数据表  用于 BgMapView
	 * 背景地图 vo
	 * @author yefeng
	 *2012-4-25下午10:07:57
	 */
	public class MapSceneBasicVo
	{
		/**  背景地图id 
		 */
		public var mapId:int;
		/**资源id 
		 */
		public var resId:int;
		
		/** 图片宽
		 */		 
		public var width:int;
		
		/** 图片高
		 */
		public var height:int;
		/** 该地图的场景跳转点数据
		 */		
	//	public var skipArr:Array;
		
		public function MapSceneBasicVo()
		{
		}
		
		/**得到跳转点将要进入的地图id
		 * mapX mapY 玩家地图坐标 
		 */		
//		public function getSkipMapId(mapX:int,mapY:int):int
//		{
//			///解析  [[[1200,2550],[1290,2640],10002,[3480,2640]],[10002,[2730,2310],[2790,2370]]]
//			
//			var startPtArr:Array;//起始点
//			var endPtArr:Array;// 终止点
//			var skipMapId:int;//将要跳转的地图id 
//			for each(var infoArr:Array in skipArr)
//			{
//				startPtArr=infoArr[0];
//				endPtArr=infoArr[1];
//				skipMapId=infoArr[2];
//				//进行坐标比对判断
//				if(mapX>=startPtArr[0]&&mapX<=endPtArr[0]&&mapY>=startPtArr[1]&&mapY<=endPtArr[1])
//				{
//					return skipMapId;			
//				}
//			}
//			return -1;
//		}
	}
}