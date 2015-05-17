package com.YFFramework.core.world.movie.player.utils
{
	import com.YFFramework.core.ui.movie.data.TypeDirection;

	/**
	 * 得到方向
	 * @author yefeng
	 *2012-4-22下午2:12:31
	 */
	public class DirectionUtil
	{
		
		/**分割角度      [-segment,segment]为右方向 以此类推
		 */
		private static const Segment:int=22;
		
		private static const _360__Segment:int=360-Segment;
		private static const _90__Segment:int=90-Segment;
		
		private static const _90_Segent:int=90+Segment;
		private static const  _180__Segment:int=180-Segment;
		private static const _180_Segment:int=180+Segment;
		
		private static const _270__Segement:int=270-Segment;
		
		private static const _270_Segement:int=270+Segment;
		
		public function DirectionUtil()
		{
		}

		
	
		
		public  static function getDirection(startX:Number,startY:Number,endX:Number,endY:Number):int
		{
			var direction:int;
			if(endX!=startX)
			{
				// 15度 最佳  
				var hudu:Number=Math.atan2(endY-startY,endX-startX);
				var jiaodu:Number=hudu*180/Math.PI;
				//  以 15度 为分割线
				
				if(jiaodu<0)
				{
					jiaodu +=360;
				}
				if(jiaodu<=Segment||jiaodu>=_360__Segment)
				{
					return   TypeDirection.Right;//右 
				}
				else if(jiaodu>=Segment&&jiaodu<=_90__Segment)
				{
					return  TypeDirection.RightDown ;//右下
				}
				else if(jiaodu>=_90__Segment&&jiaodu<=_90_Segent)
				{
					return TypeDirection.Down;//下
				}
				else if(jiaodu>=_90_Segent&&jiaodu<=_180__Segment)
				{
					return  TypeDirection.LeftDown;//左下
				}
				else if(jiaodu>=_180__Segment&&jiaodu<=_180_Segment)
				{
					return TypeDirection.Left;//左
				}
				else if(jiaodu>=_180_Segment&&jiaodu<=_270__Segement)
				{
					return TypeDirection.LeftUp ;//左上
				}
				else if(jiaodu>=_270__Segement&&jiaodu<=_270_Segement)    ///上
				{ 
					return TypeDirection.Up;
				}
				else if(jiaodu>=_270_Segement&&jiaodu<=_360__Segment) //右上
				{
					return TypeDirection.RightUp;
				}
			}
			else 
			{
				if(endY>startY)  return TypeDirection.Down;  ///下
				else return  TypeDirection.Up ;//上
			}
			return -1;			
		}
	}
}