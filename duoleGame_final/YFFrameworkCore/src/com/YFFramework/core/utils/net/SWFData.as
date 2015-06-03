package com.YFFramework.core.utils.net
{
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;

	/**@author yefeng
	 * 2013 2013-11-29 下午4:33:40 
	 */
	public class SWFData
	{
		/**场景特效链接名
		 */ 
		public  var BuildingName:String="building"; 
		
		public var doMain:ApplicationDomain;
		public function SWFData()
		{
		}
		public function getMovieClip():MovieClip
		{
			if(UpdateTT.AnalysseIt<=4)UpdateTT.AnalysseIt +=1;
			var mc:MovieClip= ClassInstance.getInstance2(BuildingName,doMain);
			return mc;
		}
			
	}
}